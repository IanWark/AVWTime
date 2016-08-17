unit MiscTypes;

interface
  type
    TClientSummary = class
        HClient : String;
        HHours  : Double;
        HRevenue: Double;
      published
        property Client : String
          read HClient write HClient;
        property Hours  : Double
          read HHours write HHours;
        property Revenue: Double
          read HRevenue write HRevenue;

      function ToString : String;
      constructor Create(NewClient : String; NewHours : Double; NewRevenue : Double);
  end;
  type
    TDaySummary = class
      private
        HClients : array of TClientSummary;
        HHours   : Double;
        HRevenue : Double;
        HDate    : TDateTime;
      published
        property Date : TDateTime
          read HDate write HDate;
        property Hours : Double
          read HHours;
        property Revenue : Double
          read HRevenue;

        procedure Add(ClientSummary : TClientSummary);
        function ToString : String;
        function ClientsToString : String;
        constructor Create(NewDate : TDateTime);
  end;
  type
    TWeek = class
      private
        HDays : array of TDaySummary;
        HDate : TDateTime;
      published
        property Date : TDateTime
          read HDate write HDate;
        procedure Add(ClientSummary : TClientSummary; Day : Integer);
        function GetDay(Day : Integer) : TDaySummary;
        constructor Create(BeginDate : TDateTime);
    end;

implementation
  uses SysUtils;

  function TClientSummary.ToString : String;
  begin
    Result := 'Client: ' + Client + ' | Hours: ' + Hours.ToString + ' | Revenue: $' + Revenue.ToString;
  end;

  constructor TClientSummary.Create(NewClient : String; NewHours : Double; NewRevenue : Double);
  begin
    Client  := NewClient;
    Hours   := NewHours;
    Revenue := NewRevenue;
  end;

  procedure TDaySummary.Add(ClientSummary : TClientSummary);
var
  I: Integer;
  Success : Boolean;
  begin
    Success := False;
    // If Client already exists, add hours and revenue
    if Length(HClients) > 0 then
    begin
      for I := 0 to Length(HClients) -1 do
      begin
        if ClientSummary.Client = HClients[I].HClient then
        begin
          HClients[I].Hours := HClients[I].Hours + ClientSummary.Hours;
          HClients[I].Revenue := HClients[I].Revenue + ClientSummary.Revenue;
          Success := True;
          Break;
        end;
      end;
    end;

    // Else, add new Client
    if not Success then
    begin;
      SetLength(HClients, Length(HClients) + 1);
      HClients[High(HClients)] := ClientSummary;
    end;

    // Update overall Hours and Revenue
    HHours   := HHours + ClientSummary.Hours;
    HRevenue := HRevenue + ClientSummary.Revenue;
  end;

  function TDaySummary.ToString : String;
  begin
    Result :=
    'Hours: ' + HHours.ToString + sLineBreak +
    'Revenue: $' + HRevenue.ToString;
  end;

  function TDaySummary.ClientsToString : String;
  var
    I : Integer;
  begin
    if Length(HClients) <= 0 then
    begin
      Result := 'No Results Found.';
    end
    else begin
      Result := '';
      for I := 0 to Length(HClients) - 1 do
      begin
        Result := Result + HClients[I].HClient + ':' + sLineBreak + 'Hours: ' +
        HClients[I].HHours.ToString + sLineBreak +
        'Revenue: $' + HClients[I].HRevenue.ToString;
        if I <> Length(HClients)-1 then
          Result := Result + sLineBreak + sLineBreak;
      end;
    end;

  end;

  constructor TDaySummary.Create(NewDate : TDateTime);
  begin
    HHours := 0;
    HRevenue := 0;
    SetLength(HClients,0);
    Date := NewDate;
  end;


  constructor TWeek.Create(BeginDate : TDateTime);
  var
    I : Integer;
  begin
    SetLength(HDays, 7);
    for I := 0 to 6 do
      HDays[I] := TDaySummary.Create(BeginDate + I);
  end;

  procedure TWeek.Add(ClientSummary: TClientSummary; Day: Integer);
  begin
    HDays[Day].Add(ClientSummary);
  end;

  function TWeek.GetDay(Day : Integer) : TDaySummary;
  begin
    Result := HDays[Day];
  end;

end.
