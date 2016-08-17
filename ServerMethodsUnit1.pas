unit ServerMethodsUnit1;

interface

uses System.SysUtils, System.Classes, System.Json,
    Datasnap.DSServer, Datasnap.DSAuth, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.DB2,
  FireDAC.Phys.DB2Def, FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Stan.StorageBin,
  FireDAC.Stan.StorageJSON, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Comp.UI, FireDAC.Phys.ODBCBase, Data.FireDACJSONReflect, classTimeRecord,
  MiscTypes, System.StrUtils, System.DateUtils, System.Variants;

type
{$METHODINFO ON}
  TServerMethods1 = class(TDataModule)
    FDConnection: TFDConnection;
    FDPhysDB2DriverLink1: TFDPhysDB2DriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDQuery_Clients: TFDQuery;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
    FDQuery_Year: TFDQuery;
    FDQuery_Day: TFDQuery;
    FDQuery_Add: TFDQuery;
    FDQuery_Rate: TFDQuery;
    FDQuery_Edit: TFDQuery;
    FDQuery_Week: TFDQuery;
    FDQuery_LastTime: TFDQuery;
    FDQuery_Month: TFDQuery;
    FDQuery_Delete: TFDQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure TestConnection;
    function GetClients: TFDJSONDataSets;
    function GetYear(Year : Word) : TFDJSONDataSets;
    function GetMonthData(Year: Word; Month : Word) : TFDJSONDataSets;
    function GetWeekData(Date : TDateTime) : TWeek;
    function GetDayData(Date : TDateTime) : TFDJSONDataSets;
    function GetLastTime(Date : TDateTime) : TDateTime;
    function AddRecord(RecArr : TRecordArray) : TRecordArray;
    function EditRecord(RecArr : TRecordArray) : TRecordArray;
    procedure DeleteRecord(RecArr: TRecordArray);
  end;
{$METHODINFO OFF}

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

const
  sTTime = 'TTime';

procedure TServerMethods1.TestConnection;
begin
  // Nothing
end;

function TServerMethods1.GetClients: TFDJSONDataSets;
begin
  // Clear active so that the query will reexecute
  FDQuery_Clients.Active := False;
  Result := TFDJSONDatasets.Create;
  // The "TFDJSONDataSetsWrite" class provides static "ListAdd" method.
  // IT uses reflection to conver results of the query into "TFDJSONDataSets"
  TFDJSONDataSetsWriter.ListAdd(Result, FDQuery_Clients);

end;

function TServerMethods1.GetYear(Year : Word) : TFDJSONDataSets;
begin
  // Clear active so that the query will reexecute
  FDQuery_Year.Active := False;
  // Set query parameters
  FDQuery_Year.ParamByName('Year').AsString := Year.ToString;

  Result := TFDJSONDatasets.Create;
  // The "TFDJSONDataSetsWrite" class provides static "ListAdd" method.
  // IT uses reflection to conver results of the query into "TFDJSONDataSets"
  TFDJSONDataSetsWriter.ListAdd(Result, FDQuery_Year);
end;

function TServerMethods1.GetMonthData(Year: Word; Month: Word) : TFDJSONDataSets;
begin
  // Clear active so that the query will reexecute
  FDQuery_Month.Active := False;
  // Set query parameters
  FDQuery_Month.ParamByName('Year').AsString := Year.ToString;
  FDQuery_Month.ParamByName('Month').AsString := Month.ToString;

  Result := TFDJSONDatasets.Create;
  // The "TFDJSONDataSetsWrite" class provides static "ListAdd" method.
  // IT uses reflection to conver results of the query into "TFDJSONDataSets"
  TFDJSONDataSetsWriter.ListAdd(Result, FDQuery_Month);
end;

function TServerMethods1.GetWeekData(Date : TDateTime) : TWeek;
var
  BeginDate : TDateTime;
  Weekday : Word;
  WeekClient: TClientSummary;
  D: Integer;
  C: Integer;
begin
  Weekday := DayOfWeek(Date) - 1;
  BeginDate := IncDay(Date, -Weekday);

  Result := TWeek.Create(BeginDate);

  for D := 0 to 6 do
  begin
    // Clear active so that the query will reexecute
    FDQuery_Week.Active := False;
    // Set query parameters
    FDQuery_Week.ParamByName('Date').Value := BeginDate;

    // Open query
    FDQuery_Week.Open;

    if FDQuery_Week.Table.Rows.Count > 0 then
    begin
      for C := 0 to FDQuery_Week.Table.Rows.Count-1 do
      begin
        WeekClient := TClientSummary.Create(
        FDQuery_Week.Table.Rows.ItemsI[C].GetValues('client_id'),
        FDQuery_Week.Table.Rows.ItemsI[C].GetValues('hrs'),
        FDQuery_Week.Table.Rows.ItemsI[C].GetValues('earnings'));

        Result.Add(WeekClient, D);
      end;
    end;

    // Move to next day
    BeginDate := IncDay(BeginDate, 1);
  end;


end;

function TServerMethods1.GetDayData(Date : TDateTime) : TFDJSONDataSets;
begin
  // Clear active so that the query will reexecute
  FDQuery_Day.Active := False;

  // Set query parameters.
  FDQuery_Day.ParamByName('Date').Value := Date;

  Result := TFDJSONDatasets.Create;
  // The "TFDJSONDataSetsWrite" class provides static "ListAdd" method.
  // IT uses reflection to conver results of the query into "TFDJSONDataSets"
  TFDJSONDataSetsWriter.ListAdd(Result, FDQuery_Day);
end;

function TServerMethods1.GetLastTime(Date : TDateTime) : TDateTime;
begin
  FDQuery_LastTime.Active := False;

  // Set query parameters
  FDQuery_LastTime.ParamByName('Date').Value := Date;

  // Open query
  FDQuery_LastTime.Open;

  try
    result := FDQuery_LastTime.Table.Rows.ItemsI[0].GetValues('last');
  except
    on E : EVariantTypeCastError do
    begin
      result := EncodeTime(8,0,0,0);
    end;
  end;

end;

// Add new record, return rate, because rate is calculated from server
function TServerMethods1.AddRecord(RecArr: TRecordArray) : TRecordArray;
var
  Rec : TRecord;
  I : Integer;
begin
  Result := RecArr;
  // For each record in array...
  for I := 0 to RecArr.GetCount-1 do
  begin
    Rec := RecArr.GetRecord(I);
    // Clear active so that the query will reexecute
    FDQuery_Add.Active := False;
    FDQuery_Rate.Active:= False;

    // Set query parameters.
    FDQuery_Add.ParamByName('client_id').AsString := Rec.Client;
    FDQuery_Add.ParamByName('tx_date').AsDateTime := Rec.TimeDate;
    FDQuery_Add.ParamByName('tx_from').AsDateTime := Rec.TimeFrom;
    FDQuery_Add.ParamByName('tx_to').AsDateTime := Rec.TimeTo;
    FDQuery_Add.ParamByName('hrs').Value := Rec.TimeHours;
    FDQuery_Add.ParamByName('qty').Value := Rec.Quantity;
    FDQuery_Add.ParamByName('amt').Value := Rec.Amount;
    FDQuery_Add.ParamByName('tx_comment').Value := Rec.Comment;
    if Rec.Client = 'AVW' then
      Rec.Inv := -1;
    FDQuery_Add.ParamByName('inv').Value := Rec.Inv;
    FDQuery_Add.ParamByName('tx_user').Value := Rec.User;

    // Set rate according to client table
    FDQuery_Rate.ParamByName('clientid').Value := Rec.Client;
    FDQuery_Rate.Open;
    FDQuery_Rate.First;
    Rec.Rate := FDQuery_Rate.Fields[0].AsFloat;
    FDQuery_Add.ParamByName('rate').Value := Rec.Rate;

    FDQuery_Add.Open;
    FDQuery_Add.First;
    Rec.ID := FDQuery_Add.Fields[0].AsInteger;

    Result.Edit(Rec, I);
  end;
end;

// Edit record, return rate, because rate is calculated from server
function TServerMethods1.EditRecord(RecArr: TRecordArray) : TRecordArray;
var
  Rec : TRecord;
  I : Integer;
begin
  Result := RecArr;
  // For each record in array...
  for I := 0 to RecArr.GetCount-1 do
  begin
    Rec := RecArr.GetRecord(I);
    // Clear active so that the query will reexecute
    FDQuery_Edit.Active := False;
    FDQuery_Rate.Active:= False;

    // Set query parameters.
    FDQuery_Edit.ParamByName('time_id').Value := Rec.ID;
    FDQuery_Edit.ParamByName('client_id').Value := Rec.Client;
    FDQuery_Edit.ParamByName('tx_date').AsString := FormatDateTime('yyyy-mm-dd',Rec.TimeDate);
    FDQuery_Edit.ParamByName('tx_from').AsString := FormatDateTime('hh.nn.ss',Rec.TimeFrom);
    FDQuery_Edit.ParamByName('tx_to').AsString := FormatDateTime('hh.nn.ss',Rec.TimeTo);
    FDQuery_Edit.ParamByName('hrs').Value := Rec.TimeHours;
    FDQuery_Edit.ParamByName('qty').Value := Rec.Quantity;
    FDQuery_Edit.ParamByName('amt').Value := Rec.Amount;
    FDQuery_Edit.ParamByName('tx_comment').Value := Rec.Comment;
    FDQuery_Edit.ParamByName('inv').Value := Rec.Inv;
    FDQuery_Edit.ParamByName('tx_user').Value := Rec.User;
    // Set rate according to client table
    FDQuery_Rate.ParamByName('clientid').Value := Rec.Client;
    FDQuery_Rate.Open;
    FDQuery_Rate.First;
    Rec.Rate := FDQuery_Rate.Fields[0].AsFloat;
    FDQuery_Edit.ParamByName('rate').Value := Rec.Rate;

    FDQuery_Edit.ExecSQL;

    Result.Add(Rec, I);
  end;
end;

procedure TServerMethods1.DeleteRecord(RecArr: TRecordArray);
var
  I : Integer;
begin
  // For each record in array...
  for I := 0 to RecArr.GetCount-1 do
  begin
    // Clear active so that the query will reexecute
    FDQuery_Delete.Active := False;

    // Set query parameters
    FDQuery_Delete.ParamByName('time_id').Value := RecArr.GetRecord(I).ID;

    FDQuery_Delete.ExecSQL;
  end;
end;

end.

