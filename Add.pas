unit Add;

// Form for adding, editing, or deleting a record

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox, Main, FMX.Edit,
  FMX.EditBox, FMX.NumberBox, FMX.Layouts, FMX.DateTimeCtrls, classTimeRecord,
  FMX.Objects, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, FireDAC.Stan.StorageJSON, Data.Bind.Components,
  Data.Bind.DBScope, FMX.ListView, Threading;

type
  TFormAdd = class(TForm)
    EditClient: TComboBox;
    LabelUser: TLabel;
    LabelClient: TLabel;
    ButtonBack: TButton;
    ButtonQuantity: TRadioButton;
    ButtonHourly: TRadioButton;
    LayoutTop: TLayout;
    LayoutClient: TLayout;
    LayoutRadio: TLayout;
    LayoutHourly: TLayout;
    LabelFrom: TLabel;
    LabelTo: TLabel;
    LayoutFrom: TLayout;
    LayoutQuantity: TLayout;
    LabelQuantity: TLabel;
    LabelAmount: TLabel;
    EditQuantity: TNumberBox;
    EditAmount: TNumberBox;
    ButtonAdd: TButton;
    LayoutTo: TLayout;
    Layout1: TLayout;
    LayoutAmount: TLayout;
    LayoutComment: TLayout;
    LabelComment: TLabel;
    EditComment: TEdit;
    LayoutInv: TLayout;
    LabelInv: TLabel;
    EditInv: TNumberBox;
    LayoutUser: TLayout;
    LabelAllan: TLabel;
    FDMemTable_Clients: TFDMemTable;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    LinkFillControlToField2: TLinkFillControlToField;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    FDStanStorageJSONLink2: TFDStanStorageJSONLink;
    EditFromHour: TNumberBox;
    EditFromMinute: TNumberBox;
    LabelFromColon: TLabel;
    EditToMinute: TNumberBox;
    LabelToColon: TLabel;
    ButtonFromInc: TButton;
    ButtonFromDec: TButton;
    ButtonFromSet: TButton;
    ButtonToDec: TButton;
    ButtonToInc: TButton;
    ButtonToSet: TButton;
    EditToHour: TNumberBox;
    ButtonLast: TButton;
    ButtonClientRefresh: TButton;
    RectangleBottom: TRectangle;
    LabelTitle: TLabel;
    ButtonDelete: TButton;
    LayoutLast: TLayout;
    RectangleBackground: TRectangle;

    // Set focus to nothing - closes any open keyboards
    procedure RectangleBackgroundClick(Sender: TObject);

    procedure FormActivate(Sender: TObject);
    procedure GetClients;

    procedure ButtonLastClick(Sender: TObject);
    procedure ButtonFromIncClick(Sender: TObject);
    procedure ButtonFromDecClick(Sender: TObject);
    procedure ButtonFromSetClick(Sender: TObject);
    procedure ButtonToIncClick(Sender: TObject);
    procedure ButtonToDecClick(Sender: TObject);
    procedure ButtonToSetClick(Sender: TObject);
    procedure ButtonHourlyClick(Sender: TObject);
    procedure ButtonQuantityClick(Sender: TObject);
    procedure ButtonBackClick(Sender: TObject);
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonDeleteClick(Sender: TObject);

    procedure PrepareAdd;
    procedure PrepareEdit(Item : TRecord);
    procedure ButtonClientRefreshClick(Sender: TObject);
    procedure Print(str : String);
  private
    { Private declarations }
  public
    { Public declarations }
    function RoundTo15(obj : Word) : Word;
    function QuarterHour(obj: TTime) : TTime;
  end;

var
  FormAdd: TFormAdd;
  ID : Integer;
  Rate : Double;

implementation
uses DataController, FileController, ClientModuleUnit, Data.FireDACJSONReflect, DateUtils, IOUtils;

{$R *.fmx}

// Set focus to nothing - closes any open keyboards
procedure TFormAdd.RectangleBackgroundClick(Sender: TObject);
begin
  FormAdd.Focused := NIL;
end;

function TFormAdd.RoundTo15( obj : Word) : Word;
var
  Diff : Word;
begin
  Diff := obj mod 15;
  Result :=  obj - Diff;
  if Diff > 6 then
  begin
    Result := Result + 15;
  end;
end;

function TFormAdd.QuarterHour(obj: TTime) : TTime;
var
  Hours : Word;
  Minutes : Word;
  Seconds : Word;
  Milliseconds: Word;
begin
  DecodeTime(obj, Hours, Minutes, Seconds, Milliseconds);

  Minutes := RoundTo15(Minutes);

  Result := EncodeTime(Hours, Minutes, 0, 0);
end;

procedure TFormAdd.FormActivate(Sender: TObject);
begin
  if EditClient.Items.IndexOf('BAN') = -1 then GetClients;
  EditClient.ItemIndex := EditClient.Items.IndexOf('BAN');
end;

procedure TFormAdd.GetClients;
begin
  try
    FDMemTable_Clients.LoadFromFile(IOUtils.TPath.Combine(IOUtils.TPath.GetDocumentsPath, IOUtils.TPath.Combine('AVW','ClientList')));
    except
      // If cannot open file, get it from the server
      on E : EFOpenError do
      begin
        FileController.RefreshClients;
      end;
  end;
end;

procedure TFormAdd.ButtonClientRefreshClick(Sender: TObject);
begin
  FileController.RefreshClients;
  EditClient.ItemIndex := EditClient.Items.IndexOf('BAN');
end;

// Sets From time to last To time for that day
procedure TFormAdd.ButtonLastClick(Sender: TObject);
var
  LastTime : TDateTime;
  Hour, Min, Sec, Mil : Word;
begin
  try
    LastTime := ClientModule.ServerMethods1Client.GetLastTime(Main.HeaderFooterForm.DateEdit.Date);

    DecodeTime(LastTime,Hour,Min,Sec,Mil);
    EditFromHour.Value := Hour;
    EditFromMinute.Value := Min;
  except
    on E : Exception do
    begin
      // Do Nothing
    end;
  end;
end;

// Decreases From time by 15 min
procedure TFormAdd.ButtonFromDecClick(Sender: TObject);
var
  Minute: Integer;
begin
  Minute := Round(EditFromMinute.Value) - 15;
  if Minute < 0 then
  begin
    EditFromHour.Value := EditFromHour.Value - 1;
    Minute := 45;
    if EditFromHour.Value <= 0 then
    begin
      EditFromHour.Value := 23;
    end;
  end;
  EditFromMinute.Value := Minute;
end;

// Increases From time by 15 min
procedure TFormAdd.ButtonFromIncClick(Sender: TObject);
var
  Minute: Integer;
begin
  Minute := Round(EditFromMinute.Value) + 15;
  if Minute >= 60 then
  begin
    EditFromHour.Value := EditFromHour.Value + 1;
    Minute := 0;
    if EditFromHour.Value > 23 then
    begin
      EditFromHour.Value := 0;
    end;
  end;
  EditFromMinute.Value := Minute;
end;

// Sets From time to current
procedure TFormAdd.ButtonFromSetClick(Sender: TObject);
var
  Hour, Minute, Second, Milli : Word;
begin
  DecodeTime(time,Hour,Minute,Second,Milli);
  Minute := RoundTo15(Minute);
  if Minute >= 60 then
  begin
    Hour := Hour + 1;
    Minute := 0;
  end;
  EditFromHour.Value       := Hour;
  EditFromMinute.Value     := Minute;
end;

// Decreases To time by 15 min
procedure TFormAdd.ButtonToDecClick(Sender: TObject);
var
  Minute: Integer;
begin
  Minute := Round(EditToMinute.Value) - 15;
  if Minute < 0 then
  begin
    EditToHour.Value := EditToHour.Value - 1;
    Minute := 45;
    if EditToHour.Value <= 0 then
    begin
      EditToHour.Value := 23;
    end;
  end;
  EditToMinute.Value := Minute;
end;

// Increases To time by 15 min
procedure TFormAdd.ButtonToIncClick(Sender: TObject);
var
  Minute: Integer;
begin
  Minute := Round(EditToMinute.Value) + 15;
  if Minute >= 60 then
  begin
    EditToHour.Value := EditToHour.Value + 1;
    Minute := 0;
    if EditToHour.Value > 23 then
    begin
      EditToHour.Value := 0;
    end;
  end;
  EditToMinute.Value := Minute;
end;

// Sets To time to current
procedure TFormAdd.ButtonToSetClick(Sender: TObject);
var
  Hour, Minute, Second, Milli : Word;
begin
  DecodeTime(time,Hour,Minute,Second,Milli);
  Minute := RoundTo15(Minute);
  if Minute >= 60 then
  begin
    Hour := Hour + 1;
    Minute := 0;
  end;

  EditToHour.Value := Hour;
  EditToMinute.Value := Minute;
end;

// Switches to Hourly mode
procedure TFormAdd.ButtonHourlyClick(Sender: TObject);
begin
  // Set button on, other button off
  ButtonQuantity.IsChecked := False;
  ButtonHourly.IsChecked := True;

  // Show options for Hourly record
  LayoutQuantity.Visible := False;
  LayoutHourly.Visible := True;
end;

// Switches to Quantity mode
procedure TFormAdd.ButtonQuantityClick(Sender: TObject);
begin
  // Set button on, other button off
  ButtonQuantity.IsChecked := True;
  ButtonHourly.IsChecked := False;

  // Show options for Quantity record
  LayoutHourly.Visible := False;
  LayoutQuantity.Visible := True;
end;

// Goes back to Main
procedure TFormAdd.ButtonBackClick(Sender: TObject);
begin
  Main.HeaderFooterForm.Show;
end;

procedure TFormAdd.ButtonDeleteClick(Sender: TObject);
begin
  DeleteRecord(ID);
  // Async-ly update database, show main page
  UpdateDatabase;
  Main.HeaderFooterForm.Show;
end;

procedure TFormAdd.ButtonAddClick(Sender: TObject);
var
  Str : String;

  GenID    : Integer;
  User     : String;
  Client   : String;
  TimeDate : TDateTime;
  TimeFrom : TDateTime;
  TimeTo   : TDateTime;
  TimeHours: Double;
  Quantity : Integer;
  Amount   : Double;
  Inv      : Integer;
  Comment  : String;
  Item     : TRecord;

  Success  : Boolean;
begin
  Success := True;
  // Get data from fields
  // Get User
  User := DataController.CurrentUser;

  // Get Client
  if EditClient.ItemIndex = -1 then
  begin
    Success := False;
    Str := Str + 'Please choose a Client.' + sLineBreak;
  end
  else
  begin
    Client := EditClient.Selected.Text;
  end;

  // Get Inv
  Inv := Trunc(EditInv.Value);
  // Get Comment
  Comment := EditComment.Text;

  // Get Date
  TimeDate := Main.HeaderFooterForm.DateEdit.Date;

  if (ButtonHourly.IsChecked) then
  begin
    TimeFrom := EncodeTime(Round(EditFromHour.Value),Round(EditFromMinute.Value),0,0);
    TimeTo   := EncodeTime(Round(EditToHour.Value),Round(EditToMinute.Value),0,0);

    Quantity := 0;
    Amount   := 0;
  end
  else if (ButtonQuantity.IsChecked) then
  begin
    TimeFrom := 0;
    TimeTo   := 0;
    Rate     := 0;

    Quantity := Trunc(EditQuantity.Value);
    if Quantity = 0 then
    begin
      Success := False;
      Str := Str + 'Quantity must be greater than 0.' + sLineBreak;
    end;

    Amount   := EditAmount.Value;
  end
  // No button is checked.
  else
  begin
    Success := False;
    Str := 'Please pick either Quantity or Hourly.';
  end;

    // Create record, send to Controller to add or edit
  if Success then
  begin
    TimeHours := GetTimeHours(TimeFrom, TimeTo);
    if LabelTitle.Text = 'Add Record' then
    begin
      GenID := Main.HeaderFooterForm.GetLowestID;
      Item := TRecord.Create(GenID, User, Client,
      TimeDate, TimeFrom, TimeTo, TimeHours, Rate, Quantity, Amount, Inv, Comment);
      AddRecord(Item);
    end
    else if LabelTitle.Text = 'Edit Record' then
    begin
      Item := TRecord.Create(ID, User, Client,
      TimeDate, TimeFrom, TimeTo, TimeHours, Rate, Quantity, Amount, Inv, Comment);
      EditRecord(Item);
    end;

    // Async-ly update database, show main page
    DataController.UpdateDatabase;
    HeaderFooterForm.Show;
  end
  else ShowMessage(Str);
end;

// Sets default values to blank when adding a new entry
procedure TFormAdd.PrepareAdd;
var
  Hour, Minute, Second, Milli : Word;
begin
  DecodeTime(time,Hour,Minute,Second,Milli);
  Minute := RoundTo15(Minute);
  if Minute >= 60 then
  begin
    Hour := Hour + 1;
    Minute := 0;
  end;

  ButtonHourlyClick(Self);
  LabelAllan.Text          := CurrentUser;
  EditClient.ItemIndex     := EditClient.Items.IndexOf('BAN');
  EditFromHour.Value       := Hour;
  EditFromMinute.Value     := Minute;
  EditToHour.Value         := Hour;
  EditToMinute.Value       := Minute;
  EditQuantity.Value       := 0;
  EditAmount.Value         := 0;
  EditInv.Value            := 0;
  EditComment.Text         := '';
  ButtonHourly.isChecked   := True;
  LayoutHourly.Visible     := True;
  ButtonQuantity.isChecked := False;
  LayoutQuantity.Visible     := False;
  LabelTitle.Text := 'Add Record';

  ButtonDelete.Visible := False;
end;

// Sets default values to previous information when editing record
procedure TFormAdd.PrepareEdit(Item : TRecord);
var
  Index : Integer;
  Hour, Minute, Second, Milli : Word;
begin
  DecodeTime(time,Hour,Minute,Second,Milli);

  ID := Item.Id;
  LabelAllan.Text       := Item.User;
  Index := EditClient.Items.IndexOf(Item.Client);
  EditClient.ItemIndex  := Index;
  DecodeTime(Item.TimeFrom,Hour,Minute,Second,Milli);
  EditFromHour.Value    := Hour;
  EditFromMinute.Value  := Minute;
  DecodeTime(Item.TimeTo,Hour,Minute,Second,Milli);
  EditToHour.Value      := Hour;
  EditToMinute.Value    := Minute;
  Rate                  := Item.Rate;
  EditQuantity.Value    := Item.Quantity;
  EditAmount.Value      := Item.Amount;
  EditInv.Value         := Item.Inv;
  EditComment.Text      := Item.Comment;
  if Item.Quantity > 0 then
  begin
    ButtonHourly.isChecked   := False;
    LayoutHourly.Visible     := False;
    ButtonQuantity.isChecked := True;
    LayoutQuantity.Visible   := True;
  end
  else
  begin
    ButtonHourly.isChecked   := True;
    LayoutHourly.Visible     := True;
    ButtonQuantity.isChecked := False;
    LayoutQuantity.Visible   := False;
  end;
  LabelTitle.Text := 'Edit Record';

  ButtonDelete.Visible := True;
end;

procedure TFormAdd.Print(str : string);
begin
  ShowMessage(str);
end;

end.
