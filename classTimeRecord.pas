unit classTimeRecord;

interface
uses SysUtils, DateUtils;
  type
    TRecord = class
    private
      RecordID       : Integer;
      RecordClient   : String;
      RecordUser     : String;
      RecordTimeDate : TDateTime;
      RecordTimeFrom : TDateTime;
      RecordTimeTo   : TDateTime;
      RecordTimeHours: Double;
      RecordRate     : Double;
      RecordQuantity : Integer;
      RecordAmount   : Double;
      RecordInv      : Integer;
      RecordComment  : String;

    published
      property ID : Integer
        read  RecordId write RecordID;
      property Client : String
        read  RecordClient
        write RecordClient;
      property User : String
        read  RecordUser
        write RecordUser;
      property TimeDate : TDateTime
        read  RecordTimeDate
        write RecordTimeDate;
      property TimeFrom : TDateTime
        read  RecordTimeFrom;
      property TimeTo : TDateTime
        read  RecordTimeTo;
      property TimeHours: Double
        read  RecordTimeHours;
      property Rate : Double
        read  RecordRate
        write RecordRate;
      property Quantity : Integer
        read  RecordQuantity
        write RecordQuantity;
      property Amount : Double
        read  RecordAmount
        write RecordAmount;
      property Inv : Integer
        read  RecordInv
        write RecordInv;
      property Comment : String
        read  RecordComment
        write RecordComment;

      procedure SetTimeFrom(NewFrom : TDateTime);
      procedure SetTimeTo(NewTo : TDateTime);
      function ToString : String;

      constructor Create(ID : Integer; User : String; Client : String;
      TimeDate: TDateTime; TimeFrom : TDateTime; TimeTo : TDateTime; TimeHours : Double;
      Rate : Double; Quantity : Integer; Amount : Double; Inv : Integer;
      Comment : String);
    end;
    type
      // Arr is array of records, IDs is array of those records IDs before they are changed
      TRecordArray = class
        private
          Arr : Array of TRecord;
          IDs : Array of Integer;
        published
          procedure Add(Item : TRecord; Index : Integer);
          procedure Edit(Item : TRecord; Index : Integer);
          function GetCount : Integer;
          function GetRecord(Index : Integer) : TRecord;
          function GetOldID(Index : Integer) : Integer;
          constructor Create(Count: Integer);
      end;
implementation
uses DataController;

  procedure TRecord.SetTimeFrom(NewFrom: TDateTime);
  begin
    RecordTimeFrom := NewFrom;
    RecordTimeHours:= DataController.GetTimeHours(RecordTimeFrom, RecordTimeTo);
  end;

  procedure TRecord.SetTimeTo(NewTo: TDateTime);
  begin
    RecordTimeTo   := NewTo;
    RecordTimeHours:= DataController.GetTimeHours(RecordTimeFrom, RecordTimeTo);
  end;

  function TRecord.ToString : String;
  begin
    Result := RecordClient;
    // Quantity
    if Quantity > 0 then
    begin
      Result := Result + ' - $' + (RecordAmount*RecordQuantity).ToString + sLineBreak +
      'Quantity: ' + RecordQuantity.ToString + sLineBreak +
      'Amount: $' + RecordAmount.ToString + sLineBreak +
      RecordComment;
    end
    else
    // Hourly
    begin
      Result := Result + ' - $' + (RecordTimeHours*RecordRate).ToString + sLineBreak +
      formatdatetime('hh:nn am/pm',RecordTimeFrom)+' - '+formatdatetime('hh:nn am/pm',RecordTimeTo) +
      sLineBreak + RecordTimeHours.ToString + ' hrs' + sLineBreak +
      RecordComment;
    end
  end;

  constructor TRecord.Create( ID : Integer; User: string; Client : String;
  TimeDate : TDateTime; TimeFrom: TDateTime; TimeTo: TDateTime; TimeHours : Double;
  Rate: Double; Quantity: Integer; Amount: Double; Inv : Integer; Comment : String);
  begin
    RecordID       := ID;
    RecordClient   := Client;
    RecordUser     := User;
    RecordTimeDate := trunc(TimeDate);
    RecordTimeFrom := TimeDate + TimeFrom - trunc(TimeFrom);
    RecordTimeTo   := TimeDate + TimeTo - trunc(TimeTo);
    RecordTimeHours:= TimeHours;
    RecordRate     := Rate;
    RecordQuantity := Quantity;
    RecordAmount   := Amount;
    RecordInv      := Inv;
    RecordComment  := Comment;
  end;

  procedure TRecordArray.Add(Item : TRecord; Index : Integer);
  begin
    Arr[Index] := Item;
    IDs[Index] := Item.ID;
  end;

  procedure TRecordArray.Edit(Item : TRecord; Index : Integer);
  begin
    Arr[Index] := Item;
  end;

  function TRecordArray.GetCount : Integer;
  begin
    Result := length(Arr);
  end;

  function TRecordArray.GetRecord(index : Integer) : TRecord;
  begin
    Result := Arr[Index];
  end;

  function TRecordArray.GetOldID(Index: Integer) : Integer;
  begin
    Result := IDs[Index];
  end;

  constructor TRecordArray.Create(Count : Integer);
  begin
    SetLength(Arr,Count);
    SetLength(Ids,Count);
  end;

end.
