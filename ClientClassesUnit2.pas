//
// Created by the DataSnap proxy generator.
// 8/16/2016 8:44:50 PM
//

unit ClientClassesUnit2;

interface

uses System.JSON, Datasnap.DSProxyRest, Datasnap.DSClientRest, Data.DBXCommon, Data.DBXClient, Data.DBXDataSnap, Data.DBXJSON, Datasnap.DSProxy, System.Classes, System.SysUtils, Data.DB, Data.SqlExpr, Data.DBXDBReaders, Data.DBXCDSReaders, Data.FireDACJSONReflect, MiscTypes, classTimeRecord, Data.DBXJSONReflect;

type

  IDSRestCachedTRecordArray = interface;
  IDSRestCachedTFDJSONDataSets = interface;
  IDSRestCachedTWeek = interface;

  TServerMethods1Client = class(TDSAdminRestClient)
  private
    FTestConnectionCommand: TDSRestCommand;
    FGetClientsCommand: TDSRestCommand;
    FGetClientsCommand_Cache: TDSRestCommand;
    FGetYearCommand: TDSRestCommand;
    FGetYearCommand_Cache: TDSRestCommand;
    FGetMonthDataCommand: TDSRestCommand;
    FGetMonthDataCommand_Cache: TDSRestCommand;
    FGetWeekDataCommand: TDSRestCommand;
    FGetWeekDataCommand_Cache: TDSRestCommand;
    FGetDayDataCommand: TDSRestCommand;
    FGetDayDataCommand_Cache: TDSRestCommand;
    FGetLastTimeCommand: TDSRestCommand;
    FAddRecordCommand: TDSRestCommand;
    FAddRecordCommand_Cache: TDSRestCommand;
    FEditRecordCommand: TDSRestCommand;
    FEditRecordCommand_Cache: TDSRestCommand;
    FDeleteRecordCommand: TDSRestCommand;
  public
    constructor Create(ARestConnection: TDSRestConnection); overload;
    constructor Create(ARestConnection: TDSRestConnection; AInstanceOwner: Boolean); overload;
    destructor Destroy; override;
    procedure TestConnection;
    function GetClients(const ARequestFilter: string = ''): TFDJSONDataSets;
    function GetClients_Cache(const ARequestFilter: string = ''): IDSRestCachedTFDJSONDataSets;
    function GetYear(Year: Word; const ARequestFilter: string = ''): TFDJSONDataSets;
    function GetYear_Cache(Year: Word; const ARequestFilter: string = ''): IDSRestCachedTFDJSONDataSets;
    function GetMonthData(Year: Word; Month: Word; const ARequestFilter: string = ''): TFDJSONDataSets;
    function GetMonthData_Cache(Year: Word; Month: Word; const ARequestFilter: string = ''): IDSRestCachedTFDJSONDataSets;
    function GetWeekData(Date: TDateTime; const ARequestFilter: string = ''): TWeek;
    function GetWeekData_Cache(Date: TDateTime; const ARequestFilter: string = ''): IDSRestCachedTWeek;
    function GetDayData(Date: TDateTime; const ARequestFilter: string = ''): TFDJSONDataSets;
    function GetDayData_Cache(Date: TDateTime; const ARequestFilter: string = ''): IDSRestCachedTFDJSONDataSets;
    function GetLastTime(Date: TDateTime; const ARequestFilter: string = ''): TDateTime;
    function AddRecord(RecArr: TRecordArray; const ARequestFilter: string = ''): TRecordArray;
    function AddRecord_Cache(RecArr: TRecordArray; const ARequestFilter: string = ''): IDSRestCachedTRecordArray;
    function EditRecord(RecArr: TRecordArray; const ARequestFilter: string = ''): TRecordArray;
    function EditRecord_Cache(RecArr: TRecordArray; const ARequestFilter: string = ''): IDSRestCachedTRecordArray;
    procedure DeleteRecord(RecArr: TRecordArray);
  end;

  IDSRestCachedTRecordArray = interface(IDSRestCachedObject<TRecordArray>)
  end;

  TDSRestCachedTRecordArray = class(TDSRestCachedObject<TRecordArray>, IDSRestCachedTRecordArray, IDSRestCachedCommand)
  end;
  IDSRestCachedTFDJSONDataSets = interface(IDSRestCachedObject<TFDJSONDataSets>)
  end;

  TDSRestCachedTFDJSONDataSets = class(TDSRestCachedObject<TFDJSONDataSets>, IDSRestCachedTFDJSONDataSets, IDSRestCachedCommand)
  end;
  IDSRestCachedTWeek = interface(IDSRestCachedObject<TWeek>)
  end;

  TDSRestCachedTWeek = class(TDSRestCachedObject<TWeek>, IDSRestCachedTWeek, IDSRestCachedCommand)
  end;

const
  TServerMethods1_GetClients: array [0..0] of TDSRestParameterMetaData =
  (
    (Name: ''; Direction: 4; DBXType: 37; TypeName: 'TFDJSONDataSets')
  );

  TServerMethods1_GetClients_Cache: array [0..0] of TDSRestParameterMetaData =
  (
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'String')
  );

  TServerMethods1_GetYear: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Year'; Direction: 1; DBXType: 12; TypeName: 'Word'),
    (Name: ''; Direction: 4; DBXType: 37; TypeName: 'TFDJSONDataSets')
  );

  TServerMethods1_GetYear_Cache: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Year'; Direction: 1; DBXType: 12; TypeName: 'Word'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'String')
  );

  TServerMethods1_GetMonthData: array [0..2] of TDSRestParameterMetaData =
  (
    (Name: 'Year'; Direction: 1; DBXType: 12; TypeName: 'Word'),
    (Name: 'Month'; Direction: 1; DBXType: 12; TypeName: 'Word'),
    (Name: ''; Direction: 4; DBXType: 37; TypeName: 'TFDJSONDataSets')
  );

  TServerMethods1_GetMonthData_Cache: array [0..2] of TDSRestParameterMetaData =
  (
    (Name: 'Year'; Direction: 1; DBXType: 12; TypeName: 'Word'),
    (Name: 'Month'; Direction: 1; DBXType: 12; TypeName: 'Word'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'String')
  );

  TServerMethods1_GetWeekData: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Date'; Direction: 1; DBXType: 11; TypeName: 'TDateTime'),
    (Name: ''; Direction: 4; DBXType: 37; TypeName: 'TWeek')
  );

  TServerMethods1_GetWeekData_Cache: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Date'; Direction: 1; DBXType: 11; TypeName: 'TDateTime'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'String')
  );

  TServerMethods1_GetDayData: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Date'; Direction: 1; DBXType: 11; TypeName: 'TDateTime'),
    (Name: ''; Direction: 4; DBXType: 37; TypeName: 'TFDJSONDataSets')
  );

  TServerMethods1_GetDayData_Cache: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Date'; Direction: 1; DBXType: 11; TypeName: 'TDateTime'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'String')
  );

  TServerMethods1_GetLastTime: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Date'; Direction: 1; DBXType: 11; TypeName: 'TDateTime'),
    (Name: ''; Direction: 4; DBXType: 11; TypeName: 'TDateTime')
  );

  TServerMethods1_AddRecord: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'RecArr'; Direction: 1; DBXType: 37; TypeName: 'TRecordArray'),
    (Name: ''; Direction: 4; DBXType: 37; TypeName: 'TRecordArray')
  );

  TServerMethods1_AddRecord_Cache: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'RecArr'; Direction: 1; DBXType: 37; TypeName: 'TRecordArray'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'String')
  );

  TServerMethods1_EditRecord: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'RecArr'; Direction: 1; DBXType: 37; TypeName: 'TRecordArray'),
    (Name: ''; Direction: 4; DBXType: 37; TypeName: 'TRecordArray')
  );

  TServerMethods1_EditRecord_Cache: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'RecArr'; Direction: 1; DBXType: 37; TypeName: 'TRecordArray'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'String')
  );

  TServerMethods1_DeleteRecord: array [0..0] of TDSRestParameterMetaData =
  (
    (Name: 'RecArr'; Direction: 1; DBXType: 37; TypeName: 'TRecordArray')
  );

implementation

procedure TServerMethods1Client.TestConnection;
begin
  if FTestConnectionCommand = nil then
  begin
    FTestConnectionCommand := FConnection.CreateCommand;
    FTestConnectionCommand.RequestType := 'GET';
    FTestConnectionCommand.Text := 'TServerMethods1.TestConnection';
  end;
  FTestConnectionCommand.Execute;
end;

function TServerMethods1Client.GetClients(const ARequestFilter: string): TFDJSONDataSets;
begin
  if FGetClientsCommand = nil then
  begin
    FGetClientsCommand := FConnection.CreateCommand;
    FGetClientsCommand.RequestType := 'GET';
    FGetClientsCommand.Text := 'TServerMethods1.GetClients';
    FGetClientsCommand.Prepare(TServerMethods1_GetClients);
  end;
  FGetClientsCommand.Execute(ARequestFilter);
  if not FGetClientsCommand.Parameters[0].Value.IsNull then
  begin
    FUnMarshal := TDSRestCommand(FGetClientsCommand.Parameters[0].ConnectionHandler).GetJSONUnMarshaler;
    try
      Result := TFDJSONDataSets(FUnMarshal.UnMarshal(FGetClientsCommand.Parameters[0].Value.GetJSONValue(True)));
      if FInstanceOwner then
        FGetClientsCommand.FreeOnExecute(Result);
    finally
      FreeAndNil(FUnMarshal)
    end
  end
  else
    Result := nil;
end;

function TServerMethods1Client.GetClients_Cache(const ARequestFilter: string): IDSRestCachedTFDJSONDataSets;
begin
  if FGetClientsCommand_Cache = nil then
  begin
    FGetClientsCommand_Cache := FConnection.CreateCommand;
    FGetClientsCommand_Cache.RequestType := 'GET';
    FGetClientsCommand_Cache.Text := 'TServerMethods1.GetClients';
    FGetClientsCommand_Cache.Prepare(TServerMethods1_GetClients_Cache);
  end;
  FGetClientsCommand_Cache.ExecuteCache(ARequestFilter);
  Result := TDSRestCachedTFDJSONDataSets.Create(FGetClientsCommand_Cache.Parameters[0].Value.GetString);
end;

function TServerMethods1Client.GetYear(Year: Word; const ARequestFilter: string): TFDJSONDataSets;
begin
  if FGetYearCommand = nil then
  begin
    FGetYearCommand := FConnection.CreateCommand;
    FGetYearCommand.RequestType := 'GET';
    FGetYearCommand.Text := 'TServerMethods1.GetYear';
    FGetYearCommand.Prepare(TServerMethods1_GetYear);
  end;
  FGetYearCommand.Parameters[0].Value.SetUInt16(Year);
  FGetYearCommand.Execute(ARequestFilter);
  if not FGetYearCommand.Parameters[1].Value.IsNull then
  begin
    FUnMarshal := TDSRestCommand(FGetYearCommand.Parameters[1].ConnectionHandler).GetJSONUnMarshaler;
    try
      Result := TFDJSONDataSets(FUnMarshal.UnMarshal(FGetYearCommand.Parameters[1].Value.GetJSONValue(True)));
      if FInstanceOwner then
        FGetYearCommand.FreeOnExecute(Result);
    finally
      FreeAndNil(FUnMarshal)
    end
  end
  else
    Result := nil;
end;

function TServerMethods1Client.GetYear_Cache(Year: Word; const ARequestFilter: string): IDSRestCachedTFDJSONDataSets;
begin
  if FGetYearCommand_Cache = nil then
  begin
    FGetYearCommand_Cache := FConnection.CreateCommand;
    FGetYearCommand_Cache.RequestType := 'GET';
    FGetYearCommand_Cache.Text := 'TServerMethods1.GetYear';
    FGetYearCommand_Cache.Prepare(TServerMethods1_GetYear_Cache);
  end;
  FGetYearCommand_Cache.Parameters[0].Value.SetUInt16(Year);
  FGetYearCommand_Cache.ExecuteCache(ARequestFilter);
  Result := TDSRestCachedTFDJSONDataSets.Create(FGetYearCommand_Cache.Parameters[1].Value.GetString);
end;

function TServerMethods1Client.GetMonthData(Year: Word; Month: Word; const ARequestFilter: string): TFDJSONDataSets;
begin
  if FGetMonthDataCommand = nil then
  begin
    FGetMonthDataCommand := FConnection.CreateCommand;
    FGetMonthDataCommand.RequestType := 'GET';
    FGetMonthDataCommand.Text := 'TServerMethods1.GetMonthData';
    FGetMonthDataCommand.Prepare(TServerMethods1_GetMonthData);
  end;
  FGetMonthDataCommand.Parameters[0].Value.SetUInt16(Year);
  FGetMonthDataCommand.Parameters[1].Value.SetUInt16(Month);
  FGetMonthDataCommand.Execute(ARequestFilter);
  if not FGetMonthDataCommand.Parameters[2].Value.IsNull then
  begin
    FUnMarshal := TDSRestCommand(FGetMonthDataCommand.Parameters[2].ConnectionHandler).GetJSONUnMarshaler;
    try
      Result := TFDJSONDataSets(FUnMarshal.UnMarshal(FGetMonthDataCommand.Parameters[2].Value.GetJSONValue(True)));
      if FInstanceOwner then
        FGetMonthDataCommand.FreeOnExecute(Result);
    finally
      FreeAndNil(FUnMarshal)
    end
  end
  else
    Result := nil;
end;

function TServerMethods1Client.GetMonthData_Cache(Year: Word; Month: Word; const ARequestFilter: string): IDSRestCachedTFDJSONDataSets;
begin
  if FGetMonthDataCommand_Cache = nil then
  begin
    FGetMonthDataCommand_Cache := FConnection.CreateCommand;
    FGetMonthDataCommand_Cache.RequestType := 'GET';
    FGetMonthDataCommand_Cache.Text := 'TServerMethods1.GetMonthData';
    FGetMonthDataCommand_Cache.Prepare(TServerMethods1_GetMonthData_Cache);
  end;
  FGetMonthDataCommand_Cache.Parameters[0].Value.SetUInt16(Year);
  FGetMonthDataCommand_Cache.Parameters[1].Value.SetUInt16(Month);
  FGetMonthDataCommand_Cache.ExecuteCache(ARequestFilter);
  Result := TDSRestCachedTFDJSONDataSets.Create(FGetMonthDataCommand_Cache.Parameters[2].Value.GetString);
end;

function TServerMethods1Client.GetWeekData(Date: TDateTime; const ARequestFilter: string): TWeek;
begin
  if FGetWeekDataCommand = nil then
  begin
    FGetWeekDataCommand := FConnection.CreateCommand;
    FGetWeekDataCommand.RequestType := 'GET';
    FGetWeekDataCommand.Text := 'TServerMethods1.GetWeekData';
    FGetWeekDataCommand.Prepare(TServerMethods1_GetWeekData);
  end;
  FGetWeekDataCommand.Parameters[0].Value.AsDateTime := Date;
  FGetWeekDataCommand.Execute(ARequestFilter);
  if not FGetWeekDataCommand.Parameters[1].Value.IsNull then
  begin
    FUnMarshal := TDSRestCommand(FGetWeekDataCommand.Parameters[1].ConnectionHandler).GetJSONUnMarshaler;
    try
      Result := TWeek(FUnMarshal.UnMarshal(FGetWeekDataCommand.Parameters[1].Value.GetJSONValue(True)));
      if FInstanceOwner then
        FGetWeekDataCommand.FreeOnExecute(Result);
    finally
      FreeAndNil(FUnMarshal)
    end
  end
  else
    Result := nil;
end;

function TServerMethods1Client.GetWeekData_Cache(Date: TDateTime; const ARequestFilter: string): IDSRestCachedTWeek;
begin
  if FGetWeekDataCommand_Cache = nil then
  begin
    FGetWeekDataCommand_Cache := FConnection.CreateCommand;
    FGetWeekDataCommand_Cache.RequestType := 'GET';
    FGetWeekDataCommand_Cache.Text := 'TServerMethods1.GetWeekData';
    FGetWeekDataCommand_Cache.Prepare(TServerMethods1_GetWeekData_Cache);
  end;
  FGetWeekDataCommand_Cache.Parameters[0].Value.AsDateTime := Date;
  FGetWeekDataCommand_Cache.ExecuteCache(ARequestFilter);
  Result := TDSRestCachedTWeek.Create(FGetWeekDataCommand_Cache.Parameters[1].Value.GetString);
end;

function TServerMethods1Client.GetDayData(Date: TDateTime; const ARequestFilter: string): TFDJSONDataSets;
begin
  if FGetDayDataCommand = nil then
  begin
    FGetDayDataCommand := FConnection.CreateCommand;
    FGetDayDataCommand.RequestType := 'GET';
    FGetDayDataCommand.Text := 'TServerMethods1.GetDayData';
    FGetDayDataCommand.Prepare(TServerMethods1_GetDayData);
  end;
  FGetDayDataCommand.Parameters[0].Value.AsDateTime := Date;
  FGetDayDataCommand.Execute(ARequestFilter);
  if not FGetDayDataCommand.Parameters[1].Value.IsNull then
  begin
    FUnMarshal := TDSRestCommand(FGetDayDataCommand.Parameters[1].ConnectionHandler).GetJSONUnMarshaler;
    try
      Result := TFDJSONDataSets(FUnMarshal.UnMarshal(FGetDayDataCommand.Parameters[1].Value.GetJSONValue(True)));
      if FInstanceOwner then
        FGetDayDataCommand.FreeOnExecute(Result);
    finally
      FreeAndNil(FUnMarshal)
    end
  end
  else
    Result := nil;
end;

function TServerMethods1Client.GetDayData_Cache(Date: TDateTime; const ARequestFilter: string): IDSRestCachedTFDJSONDataSets;
begin
  if FGetDayDataCommand_Cache = nil then
  begin
    FGetDayDataCommand_Cache := FConnection.CreateCommand;
    FGetDayDataCommand_Cache.RequestType := 'GET';
    FGetDayDataCommand_Cache.Text := 'TServerMethods1.GetDayData';
    FGetDayDataCommand_Cache.Prepare(TServerMethods1_GetDayData_Cache);
  end;
  FGetDayDataCommand_Cache.Parameters[0].Value.AsDateTime := Date;
  FGetDayDataCommand_Cache.ExecuteCache(ARequestFilter);
  Result := TDSRestCachedTFDJSONDataSets.Create(FGetDayDataCommand_Cache.Parameters[1].Value.GetString);
end;

function TServerMethods1Client.GetLastTime(Date: TDateTime; const ARequestFilter: string): TDateTime;
begin
  if FGetLastTimeCommand = nil then
  begin
    FGetLastTimeCommand := FConnection.CreateCommand;
    FGetLastTimeCommand.RequestType := 'GET';
    FGetLastTimeCommand.Text := 'TServerMethods1.GetLastTime';
    FGetLastTimeCommand.Prepare(TServerMethods1_GetLastTime);
  end;
  FGetLastTimeCommand.Parameters[0].Value.AsDateTime := Date;
  FGetLastTimeCommand.Execute(ARequestFilter);
  Result := FGetLastTimeCommand.Parameters[1].Value.AsDateTime;
end;

function TServerMethods1Client.AddRecord(RecArr: TRecordArray; const ARequestFilter: string): TRecordArray;
begin
  if FAddRecordCommand = nil then
  begin
    FAddRecordCommand := FConnection.CreateCommand;
    FAddRecordCommand.RequestType := 'POST';
    FAddRecordCommand.Text := 'TServerMethods1."AddRecord"';
    FAddRecordCommand.Prepare(TServerMethods1_AddRecord);
  end;
  if not Assigned(RecArr) then
    FAddRecordCommand.Parameters[0].Value.SetNull
  else
  begin
    FMarshal := TDSRestCommand(FAddRecordCommand.Parameters[0].ConnectionHandler).GetJSONMarshaler;
    try
      FAddRecordCommand.Parameters[0].Value.SetJSONValue(FMarshal.Marshal(RecArr), True);
      if FInstanceOwner then
        RecArr.Free
    finally
      FreeAndNil(FMarshal)
    end
    end;
  FAddRecordCommand.Execute(ARequestFilter);
  if not FAddRecordCommand.Parameters[1].Value.IsNull then
  begin
    FUnMarshal := TDSRestCommand(FAddRecordCommand.Parameters[1].ConnectionHandler).GetJSONUnMarshaler;
    try
      Result := TRecordArray(FUnMarshal.UnMarshal(FAddRecordCommand.Parameters[1].Value.GetJSONValue(True)));
      if FInstanceOwner then
        FAddRecordCommand.FreeOnExecute(Result);
    finally
      FreeAndNil(FUnMarshal)
    end
  end
  else
    Result := nil;
end;

function TServerMethods1Client.AddRecord_Cache(RecArr: TRecordArray; const ARequestFilter: string): IDSRestCachedTRecordArray;
begin
  if FAddRecordCommand_Cache = nil then
  begin
    FAddRecordCommand_Cache := FConnection.CreateCommand;
    FAddRecordCommand_Cache.RequestType := 'POST';
    FAddRecordCommand_Cache.Text := 'TServerMethods1."AddRecord"';
    FAddRecordCommand_Cache.Prepare(TServerMethods1_AddRecord_Cache);
  end;
  if not Assigned(RecArr) then
    FAddRecordCommand_Cache.Parameters[0].Value.SetNull
  else
  begin
    FMarshal := TDSRestCommand(FAddRecordCommand_Cache.Parameters[0].ConnectionHandler).GetJSONMarshaler;
    try
      FAddRecordCommand_Cache.Parameters[0].Value.SetJSONValue(FMarshal.Marshal(RecArr), True);
      if FInstanceOwner then
        RecArr.Free
    finally
      FreeAndNil(FMarshal)
    end
    end;
  FAddRecordCommand_Cache.ExecuteCache(ARequestFilter);
  Result := TDSRestCachedTRecordArray.Create(FAddRecordCommand_Cache.Parameters[1].Value.GetString);
end;

function TServerMethods1Client.EditRecord(RecArr: TRecordArray; const ARequestFilter: string): TRecordArray;
begin
  if FEditRecordCommand = nil then
  begin
    FEditRecordCommand := FConnection.CreateCommand;
    FEditRecordCommand.RequestType := 'POST';
    FEditRecordCommand.Text := 'TServerMethods1."EditRecord"';
    FEditRecordCommand.Prepare(TServerMethods1_EditRecord);
  end;
  if not Assigned(RecArr) then
    FEditRecordCommand.Parameters[0].Value.SetNull
  else
  begin
    FMarshal := TDSRestCommand(FEditRecordCommand.Parameters[0].ConnectionHandler).GetJSONMarshaler;
    try
      FEditRecordCommand.Parameters[0].Value.SetJSONValue(FMarshal.Marshal(RecArr), True);
      if FInstanceOwner then
        RecArr.Free
    finally
      FreeAndNil(FMarshal)
    end
    end;
  FEditRecordCommand.Execute(ARequestFilter);
  if not FEditRecordCommand.Parameters[1].Value.IsNull then
  begin
    FUnMarshal := TDSRestCommand(FEditRecordCommand.Parameters[1].ConnectionHandler).GetJSONUnMarshaler;
    try
      Result := TRecordArray(FUnMarshal.UnMarshal(FEditRecordCommand.Parameters[1].Value.GetJSONValue(True)));
      if FInstanceOwner then
        FEditRecordCommand.FreeOnExecute(Result);
    finally
      FreeAndNil(FUnMarshal)
    end
  end
  else
    Result := nil;
end;

function TServerMethods1Client.EditRecord_Cache(RecArr: TRecordArray; const ARequestFilter: string): IDSRestCachedTRecordArray;
begin
  if FEditRecordCommand_Cache = nil then
  begin
    FEditRecordCommand_Cache := FConnection.CreateCommand;
    FEditRecordCommand_Cache.RequestType := 'POST';
    FEditRecordCommand_Cache.Text := 'TServerMethods1."EditRecord"';
    FEditRecordCommand_Cache.Prepare(TServerMethods1_EditRecord_Cache);
  end;
  if not Assigned(RecArr) then
    FEditRecordCommand_Cache.Parameters[0].Value.SetNull
  else
  begin
    FMarshal := TDSRestCommand(FEditRecordCommand_Cache.Parameters[0].ConnectionHandler).GetJSONMarshaler;
    try
      FEditRecordCommand_Cache.Parameters[0].Value.SetJSONValue(FMarshal.Marshal(RecArr), True);
      if FInstanceOwner then
        RecArr.Free
    finally
      FreeAndNil(FMarshal)
    end
    end;
  FEditRecordCommand_Cache.ExecuteCache(ARequestFilter);
  Result := TDSRestCachedTRecordArray.Create(FEditRecordCommand_Cache.Parameters[1].Value.GetString);
end;

procedure TServerMethods1Client.DeleteRecord(RecArr: TRecordArray);
begin
  if FDeleteRecordCommand = nil then
  begin
    FDeleteRecordCommand := FConnection.CreateCommand;
    FDeleteRecordCommand.RequestType := 'POST';
    FDeleteRecordCommand.Text := 'TServerMethods1."DeleteRecord"';
    FDeleteRecordCommand.Prepare(TServerMethods1_DeleteRecord);
  end;
  if not Assigned(RecArr) then
    FDeleteRecordCommand.Parameters[0].Value.SetNull
  else
  begin
    FMarshal := TDSRestCommand(FDeleteRecordCommand.Parameters[0].ConnectionHandler).GetJSONMarshaler;
    try
      FDeleteRecordCommand.Parameters[0].Value.SetJSONValue(FMarshal.Marshal(RecArr), True);
      if FInstanceOwner then
        RecArr.Free
    finally
      FreeAndNil(FMarshal)
    end
    end;
  FDeleteRecordCommand.Execute;
end;

constructor TServerMethods1Client.Create(ARestConnection: TDSRestConnection);
begin
  inherited Create(ARestConnection);
end;

constructor TServerMethods1Client.Create(ARestConnection: TDSRestConnection; AInstanceOwner: Boolean);
begin
  inherited Create(ARestConnection, AInstanceOwner);
end;

destructor TServerMethods1Client.Destroy;
begin
  FTestConnectionCommand.DisposeOf;
  FGetClientsCommand.DisposeOf;
  FGetClientsCommand_Cache.DisposeOf;
  FGetYearCommand.DisposeOf;
  FGetYearCommand_Cache.DisposeOf;
  FGetMonthDataCommand.DisposeOf;
  FGetMonthDataCommand_Cache.DisposeOf;
  FGetWeekDataCommand.DisposeOf;
  FGetWeekDataCommand_Cache.DisposeOf;
  FGetDayDataCommand.DisposeOf;
  FGetDayDataCommand_Cache.DisposeOf;
  FGetLastTimeCommand.DisposeOf;
  FAddRecordCommand.DisposeOf;
  FAddRecordCommand_Cache.DisposeOf;
  FEditRecordCommand.DisposeOf;
  FEditRecordCommand_Cache.DisposeOf;
  FDeleteRecordCommand.DisposeOf;
  inherited;
end;

end.

