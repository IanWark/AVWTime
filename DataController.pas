unit DataController;

interface
  uses Main, classTimeRecord, FileController, FMX.ListBox, Data.FireDACJSONReflect,
  UITypes, SysUtils, DateUtils;

  var
    RecordArray : array of TRecord;
    CurrentDate : TDateTime;
    CurrentUser : String;
    NumThreads  : Integer;

  const
    LongDayNames : array [0..6] of string = ( 'Sunday      ',
                                              'Monday     ',
                                              'Tuesday     ',
                                              'Wednesday',
                                              'Thursday    ',
                                              'Friday         ',
                                              'Saturday     ');
    LongMonthNames: array [1..12] of string = ('January',
                                                'February',
                                                'March',
                                                'April',
                                                'May',
                                                'June',
                                                'July',
                                                'August',
                                                'September',
                                                'October',
                                                'November',
                                                'December');

  procedure OnCreate;
  function GetTimeHours(TimeFrom : TDateTime; TimeTo : TDateTime) : Double;
  procedure SetNewDate(NewDate : TDateTime);

  procedure RefreshData;
  procedure RefreshOffline; // If attempting to refresh offline

  procedure AddRecord(Item : TRecord);
  procedure EditRecord(Item : TRecord);
  procedure DeleteRecord(TimeID : Integer);

  procedure UpdateDatabase;
  procedure UpdateAdd;
  procedure UpdateEdit;
  procedure UpdateDelete;

implementation
  uses ClientModuleUnit, UIConsts,
  FireDac.Comp.Client, DB, NetworkState, classThreads;

  procedure OnCreate;
  begin
    NumThreads := 0;
    CurrentUser := 'Allan';
    CurrentDate := 0;
    FileController.GetFromFile;
    UpdateDatabase;
    Main.HeaderFooterForm.DateEdit.Date := date;
  end;

  function GetTimeHours(TimeFrom: TDateTime; TimeTo: TDateTime) : Double;
  begin
    if TimeFrom > TimeTo then
      TimeTo := IncDay(TimeTo,1);
    Result:= DateUtils.MinutesBetween(TimeTo, TimeFrom)/60;
  end;

// Sets new date and refreshes information based on whether week/month/year changed
procedure SetNewDate(NewDate : TDateTime);
var
  NS: TNetworkState;
  nYear, nMonth, nDay : Word;
  oYear, oMonth, oDay : Word;
begin
  DecodeDate(CurrentDate, oYear, oMonth, oDay);
  DecodeDate(NewDate, nYear, nMonth, nDay);
  CurrentDate := NewDate;
  Main.HeaderFooterForm.LabelWeekday.Text := LongDayNames[DayOfTheWeek(NewDate)];
  Main.HeaderFooterForm.MonthName.Text := LongMonthNames[nMonth];
  Main.HeaderFooterForm.OfflineAddEditView;

  try
    try
      NS := TNetworkState.Create;
      if NS.IsConnected then
      begin
        Main.HeaderFooterForm.GetDayData;
        Main.HeaderFooterForm.GetWeekData;

        if nMonth <> oMonth then
        begin
          Main.HeaderFooterForm.GetMonthData;
        end;
        if nYear <> oYear then
        begin
          Main.HeaderFooterForm.GetYearData;
        end;

        // Set status circle to green (online)
        Main.HeaderFooterForm.CircleOnlineStatus.Fill.Color := claGreen;
      end
      else
      begin
        // Offline
        RefreshOffline;
      end;

    except
      // Exception occured
      on E : Exception do
      begin
        Main.HeaderFooterForm.Print((E.ClassName+' error raised with message : '+E.Message));
        RefreshOffline;
      end;
    end;

  finally
    NS.Free;
  end;
end;

// Get data
procedure RefreshData;
var
  NS : TNetworkState;
  Test : Integer;
begin
  if NumThreads = 0 then
  begin
    try
      try
        NS := TNetworkState.Create;
        if NS.IsConnected then
        begin
          // Online
          UpdateDatabase;
          Main.HeaderFooterForm.GetDayData;
          Main.HeaderFooterForm.GetWeekData;
          Main.HeaderFooterForm.GetMonthData;
          Main.HeaderFooterForm.GetYearData;

          // Set status circle to green (online)
          Main.HeaderFooterForm.CircleOnlineStatus.Fill.Color := TAlphaColorRec.Green;
        end
        else
        begin
          // Offline
          RefreshOffline;
        end;

      except
        // Exception occured
        on E : Exception do
        begin
          Main.HeaderFooterForm.Print((E.ClassName+' error raised with message : '+E.Message));
          RefreshOffline;
        end;
      end;

    finally
      NS.Free;
    end;
  end
  else
  begin
    HeaderFooterForm.Print('Please wait a couple seconds and try again.');
  end;
end;

  procedure RefreshOffline;
  begin
    begin
      // Set status circle to red (offline)
      Main.HeaderFooterForm.CircleOnlineStatus.Fill.Color := claRed;

      // Save records to be added to local for later
      if not Main.HeaderFooterForm.FDMemTable_Add.IsEmpty then
      begin
        EnsureDirExists;
        Main.HeaderFooterForm.FDMemTable_Add.SaveToFile(AddFilename);
        end;
      // Save records to be edited to local for later
      if not Main.HeaderFooterForm.FDMemTable_Edit.IsEmpty then
      begin
        EnsureDirExists;
        Main.HeaderFooterForm.FDMemTable_Edit.SaveToFile(EditFilename);
      end;
      if not Main.HeaderFooterForm.FDMemTable_Delete.IsEmpty then
      begin
        EnsureDirExists;
        Main.HeaderFooterForm.FDMemTable_Delete.SaveToFile(DeleteFilename);
      end;
    end;
  end;

  procedure AddRecord(Item : TRecord);
  begin
    // Add to list to add
    with Main.HeaderFooterForm.FDMemTable_Add do
      begin
        if not Active then Open;
        Append;
        Fields[0].AsInteger := Item.ID;
        Fields[1].AsString := Item.Client;
        Fields[2].AsDateTime := Item.TimeDate;
        Fields[3].AsDateTime := Item.TimeFrom;
        Fields[4].AsDateTime := Item.TimeTo;
        Fields[5].AsFloat := Item.TimeHours;
        Fields[6].AsFloat := Item.Rate;
        Fields[7].AsInteger := Item.Quantity;
        Fields[8].AsFloat := Item.Amount;
        Fields[9].AsInteger := Item.Inv;
        Fields[10].AsString := Item.Comment;
        Post;
      end;

    // Add to listbox
    Main.HeaderFooterForm.AddToDayList(Item);
  end;

  procedure EditRecord(Item : TRecord);
  begin;
    // If ID less than 0, its an offline add
    // Find entry in FDMemTable_Add with same ID, change it
    if Item.Id < 0 then
    begin
      with Main.HeaderFooterForm.FDMemTable_Add do
      begin
        if not Active then Open;
        First;
        while not EOF do
        begin
        if Fields[0].AsInteger = Item.ID then
          begin
            Edit;
            Fields[0].AsInteger := Item.ID;
            Fields[1].AsString := Item.Client;
            Fields[2].AsDateTime := Item.TimeDate;
            Fields[3].AsDateTime := Item.TimeFrom;
            Fields[4].AsDateTime := Item.TimeTo;
            Fields[5].AsFloat := Item.TimeHours;
            Fields[6].AsFloat := Item.Rate;
            Fields[7].AsInteger := Item.Quantity;
            Fields[8].AsFloat := Item.Amount;
            Fields[9].AsInteger := Item.Inv;
            Fields[10].AsString := Item.Comment;
            Post;

            Break;
          end;
          Next;
        end;
      end;
    end
    // If editing a record that was not added offline
    else
    begin
    with Main.HeaderFooterForm.FDMemTable_Edit do
      begin
        Append;
        Fields[0].AsInteger := Item.ID;
        Fields[1].AsString := Item.Client;
        Fields[2].AsDateTime := Item.TimeDate;
        Fields[3].AsDateTime := Item.TimeFrom;
        Fields[4].AsDateTime := Item.TimeTo;
        Fields[5].AsFloat := Item.TimeHours;
        Fields[6].AsFloat := Item.Rate;
        Fields[7].AsInteger := Item.Quantity;
        Fields[8].AsFloat := Item.Amount;
        Fields[9].AsInteger := Item.Inv;
        Fields[10].AsString := Item.Comment;
        Post;
      end;
    end;

    HeaderFooterForm.EditDayList(Item,Item.ID);
  end;

  procedure DeleteRecord(TimeID : Integer);
  var
    I : Integer;
  begin;
    // If ID less than 0, its an offline add
    // Find entry in FDMemTable_Add with same ID, remove it
    if TimeID < 0 then
    begin
      with Main.HeaderFooterForm.FDMemTable_Add do
      begin
        if not Active then Open;
        First;
        while not EOF do
        begin
        if Fields[0].AsInteger = TimeID then
          begin
            Edit;
            Delete;

            Break;
          end;
          Next;
        end;
      end;
    end
    // If editing a record that was not added offline
    else
    begin
    with Main.HeaderFooterForm.FDMemTable_Delete do
      begin
        if not Active then Open;
        Append;
        Fields[0].AsInteger := TimeID;
      end;
    end;

    // Delete entry in Listbox
    with Main.HeaderFooterForm.ListBoxDay do
    begin
      I := Items.IndexOf(TimeID.ToString);
      Items.Delete(I);
    end;
  end;

  procedure UpdateDatabase;
  var
    aThread : TUpdateDatabase;
  begin
    aThread := TUpdateDatabase.Create(True);
    aThread.FreeOnTerminate := True;
    aThread.Start;
  end;

  procedure UpdateAdd;
  var
    TimeRecord : TRecord;
    RecordArray : TRecordArray;
    I : Integer;
    Rate : Double;
    Item : TRecord;
  begin
    with Main.HeaderFooterForm.FDMemTable_Add do
    begin
      // If add table isn't empty, try to add record to database
      if not IsEmpty then
      begin
        if State in dsEditModes then Post;
        RecordArray := TRecordArray.Create(Table.Rows.Count);
        for I := 0 to Table.Rows.Count-1 do
        begin
          TimeRecord := TRecord.Create(
          Table.Rows.ItemsI[I].GetValues('time_id'),
          CurrentUser,
          Table.Rows.ItemsI[I].GetValues('client_id'),
          Table.Rows.ItemsI[I].GetValues('tx_date'),
          Table.Rows.ItemsI[I].GetValues('tx_from'),
          Table.Rows.ItemsI[I].GetValues('tx_to'),
          Table.Rows.ItemsI[I].GetValues('hrs'),
          Table.Rows.ItemsI[I].GetValues('rate'),
          Table.Rows.ItemsI[I].GetValues('qty'),
          Table.Rows.ItemsI[I].GetValues('amt'),
          Table.Rows.ItemsI[I].GetValues('inv'),
          Table.Rows.ItemsI[I].GetValues('tx_comment'));

          RecordArray.Add(TimeRecord,I);
        end;

        // Send to server, update items with rate, empty table, delete file
        RecordArray := ClientModule.ServerMethods1Client.AddRecord(RecordArray);
        for I := 0 to RecordArray.GetCount - 1 do
        begin
          HeaderFooterForm.EditDayList(RecordArray.GetRecord(I), RecordArray.GetOldID(I));
        end;

        EmptyDataSet;
        RemoveFile(AddFilename);
      end;
    end;
  end;

  procedure UpdateEdit;
  var
    TimeRecord : TRecord;
    RecordArray : TRecordArray;
    I : Integer;
  begin
    with Main.HeaderFooterForm.FDMemTable_Edit do
    begin
      // If edit table isn't empty, try to add record to database
      if not IsEmpty then
      begin
        if State in dsEditModes then Post;
        RecordArray := TRecordArray.Create(Table.Rows.Count);
        for I := 0 to Table.Rows.Count-1 do
        begin
          TimeRecord := TRecord.Create(
          Table.Rows.ItemsI[I].GetValues('time_id'),
          CurrentUser,
          Table.Rows.ItemsI[I].GetValues('client_id'),
          Table.Rows.ItemsI[I].GetValues('tx_date'),
          Table.Rows.ItemsI[I].GetValues('tx_from'),
          Table.Rows.ItemsI[I].GetValues('tx_to'),
          Table.Rows.ItemsI[I].GetValues('hrs'),
          Table.Rows.ItemsI[I].GetValues('rate'),
          Table.Rows.ItemsI[I].GetValues('qty'),
          Table.Rows.ItemsI[I].GetValues('amt'),
          Table.Rows.ItemsI[I].GetValues('inv'),
          Table.Rows.ItemsI[I].GetValues('tx_comment'));

          RecordArray.Add(TimeRecord,I);
        end;

        // Send to server, update items with rate, empty table, delete file
        RecordArray := ClientModule.ServerMethods1Client.EditRecord(RecordArray);
        for I := 0 to RecordArray.GetCount - 1 do
        begin
          HeaderFooterForm.EditDayList(RecordArray.GetRecord(I),RecordArray.GetOldID(I));
        end;

        EmptyDataSet;
        RemoveFile(EditFilename);
      end;
    end;
  end;

  procedure UpdateDelete;
  var
    TimeRecord : TRecord;
    RecordArray : TRecordArray;
    I : Integer;
  begin
    with Main.HeaderFooterForm.FDMemTable_Delete do
    begin
      // If delete table isn't empty, try to delete record
      if not IsEmpty then
      begin
        if State in dsEditModes then Post;
        RecordArray := TRecordArray.Create(Table.Rows.Count);
        for I := 0 to Table.Rows.Count-1 do
        begin
          TimeRecord := TRecord.Create(FieldByName('time_id').Value,
          '','',0,0,0,0,0,0,0,0,'');
          RecordArray.Add(TimeRecord, I);

          Next;
        end;
        // Send to server, empty table, delete file
        ClientModule.ServerMethods1Client.DeleteRecord(RecordArray);
        Close;
        RemoveFile(DeleteFilename);
      end;
    end;
  end;

end.
