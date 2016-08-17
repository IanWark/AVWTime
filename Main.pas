unit Main;

// Main form when you open the app - summaries and list of records on a day

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.ListBox, FMX.TabControl, FMX.Controls.Presentation,
  FMX.DateTimeCtrls, FMX.Objects, classTimeRecord, MiscTypes, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.StorageJSON,
  FireDAC.Stan.StorageBin, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Components, Data.Bind.DBScope, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  System.Actions, FMX.ActnList, Data.FireDACJSONReflect, Datasnap.DBClient,
  FMX.TMSCustomEdit, FMX.TMSEdit, FMX.TMSCalendar, Threading, FMX.Styles.Objects;

type
  THeaderFooterForm = class(TForm)
    Footer: TToolBar;
    ButtonAdd: TButton;
    TabControl1: TTabControl;
    TabDay: TTabItem;
    TabWeek: TTabItem;
    TabMonth: TTabItem;
    TabYear: TTabItem;
    LayoutThisMonth: TLayout;
    LayoutLastMonth: TLayout;
    Layout4: TLayout;
    LabelThisMonth: TLabel;
    LayoutThisMonthUnpaid: TLayout;
    RectThisMonth: TRectangle;
    Header: TToolBar;
    ListBoxDay: TListBox;
    ListBoxWeek: TListBox;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    FDMemTable_Year: TFDMemTable;
    BindingsList1: TBindingsList;
    FDMemTable_Day: TFDMemTable;
    ButtonRefresh: TButton;
    ActionList1: TActionList;
    FDMemTable_Add: TFDMemTable;
    FDMemTable_Edit: TFDMemTable;
    StyleBook1: TStyleBook;
    FDMemTable_Month: TFDMemTable;
    MonthName: TLabel;
    LayoutThisYear: TLayout;
    RectThisYear: TRectangle;
    LabelThisYear: TLabel;
    LayoutThisYearHours: TLayout;
    LabelThisYearHoursTitle: TLabel;
    LabelThisYearHoursData: TLabel;
    LayoutThisYearEarnings: TLayout;
    LabelThisYearEarningsTitle: TLabel;
    LabelThisYearEarningsData: TLabel;
    LayoutThisYearPaid: TLayout;
    LabelThisYearPaidTitle: TLabel;
    LabelThisYearPaidData: TLabel;
    LayoutThisYearUnpaid: TLayout;
    LabelThisYearUnpaidTitle: TLabel;
    LabelThisYearUnpaidData: TLabel;
    LayoutThisMonthEarnings: TLayout;
    LabelThisMonthEarningsTitle: TLabel;
    LabelThisMonthEarningsData: TLabel;
    LayoutThisMonthPaid: TLayout;
    LabelThisMonthPaidTitle: TLabel;
    LabelThisMonthPaidData: TLabel;
    LabelThisMonthUnpaidTitle: TLabel;
    LabelThisMonthUnpaidData: TLabel;
    LayoutThisMonthHours: TLayout;
    LabelThisMonthHoursTitle: TLabel;
    LabelThisMonthHoursData: TLabel;
    Layout3: TLayout;
    LabelLastMonth: TLabel;
    RectLastMonth: TRectangle;
    LayoutLastMonthHours: TLayout;
    LabelLastMonthHoursTitle: TLabel;
    LabelLastMonthHoursData: TLabel;
    LayoutLastMonthEarnings: TLayout;
    LabelLastMonthEarningsTitle: TLabel;
    LabelLastMonthEarningsData: TLabel;
    LayoutLastMonthPaid: TLayout;
    LabelLastMonthPaidTitle: TLabel;
    LabelLastMonthPaidData: TLabel;
    LayoutLastMonthUnpaid: TLayout;
    LabelLastMonthUnpaidData: TLabel;
    LabelLastMonthUnpaidTitle: TLabel;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    CircleOnlineStatus: TCircle;
    CircleAdd: TCircle;
    LayoutAdd: TLayout;
    Line1: TLine;
    Line2: TLine;
    DateEdit: TTMSFMXCalendarPicker;
    ButtonDateForward: TButton;
    ButtonDateBackward: TButton;
    LayoutLastYear: TLayout;
    RectLastYear: TRectangle;
    LayoutLastYearHours: TLayout;
    LabelLastYearHoursTitle: TLabel;
    LabelLastYearHoursData: TLabel;
    LayoutLastYearEarnings: TLayout;
    LabelLastYearEarningsTitle: TLabel;
    LabelLastYearEarningsData: TLabel;
    LayoutLastYearPaid: TLayout;
    LabelLastYearPaidTitle: TLabel;
    LabelLastYearPaidData: TLabel;
    LayoutLastYearUnpaid: TLayout;
    LabelLastYearUnpaidTitle: TLabel;
    LabelLastYearUnpaidData: TLabel;
    LabelLastYear: TLabel;
    FDMemTable_Delete: TFDMemTable;
    RectangleDay: TRectangle;
    LabelWeekday: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);

    procedure DateEditChange(Sender: TObject);

    procedure ButtonDateBackwardClick(Sender: TObject);
    procedure ButtonDateForwardClick(Sender: TObject);

    procedure ButtonAddClick(Sender: TObject);
    procedure ListBoxDayItemClick(const Sender: TCustomListBox;
      const BoxItem: TListBoxItem);
    procedure ListBoxWeekItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);

    procedure OfflineAddEditView;

    procedure GetYearData;
    procedure GetMonthData;
    procedure GetWeekData;
    procedure GetDayData;

    procedure AddToDayList(TimeRecord : TRecord);
    procedure EditDayList(TimeRecord : TRecord; TargetID : Integer);

    procedure DayDataToRecord;
    procedure ButtonRefreshClick(Sender: TObject);
    procedure Print(str : String);
    function GetLowestID : Integer;

  private

  public

  end;

var
  HeaderFooterForm: THeaderFooterForm;
  OneTimeStartUp: Boolean;


implementation

{$R *.fmx}

uses Add, DataController, ClientModuleUnit, IOUtils, DateUtils;

procedure THeaderFooterForm.FormCreate(Sender: TObject);
begin
  OneTimeStartUp := True;
end;

procedure THeaderFooterForm.FormActivate(Sender: TObject);
begin
  if OneTimeStartUp then
  begin
    DataController.OnCreate;
    OneTimeStartup := False;
  end;
end;

procedure THeaderFooterForm.ButtonRefreshClick(Sender: TObject);
begin
  DataController.RefreshData;
end;

procedure THeaderFooterForm.DateEditChange(Sender: TObject);
begin
  DataController.SetNewDate(DateEdit.Date);
end;

procedure THeaderFooterForm.ButtonDateBackwardClick(Sender: TObject);
begin
  DateEdit.Date := IncDay(DateEdit.Date,-1);
end;

procedure THeaderFooterForm.ButtonDateForwardClick(Sender: TObject);
begin
  DateEdit.Date := IncDay(DateEdit.Date,1);
end;

procedure THeaderFooterForm.ButtonAddClick(Sender: TObject);
begin
  Add.FormAdd.Show;
  Add.FormAdd.PrepareAdd;
end;

procedure THeaderFooterForm.ListBoxDayItemClick(const Sender: TCustomListBox;
  const BoxItem: TListBoxItem);
begin
  Add.FormAdd.Show;
  Add.FormAdd.PrepareEdit(BoxItem.Data as TRecord);
end;

procedure THeaderFooterForm.ListBoxWeekItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
var
  MessageText : String;
  Summary     : TDaySummary;
begin
  Summary := Item.Data as TDaySummary;
  MessageText := Summary.ClientsToString;
  if MessageText <> 'No Results Found.' then showMessage(MessageText);
end;

// Adds entries from the add and edit tables to the listbox if offline
procedure THeaderFooterForm.OfflineAddEditView;
var
  I : Integer;
  TimeRecord : TRecord;
begin
  ListBoxDay.BeginUpdate;
  // Empty ListBox
  ListBoxDay.Items.Clear;

  // Add entries from the Add table to the listbox
  with FDMemTable_Add do
  begin
    if not IsEmpty then
    begin
      for I := 0 to Table.Rows.Last.Index do
      begin
        if Table.Rows.ItemsI[I].GetValues('tx_date') = CurrentDate then
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

          AddToDayList(TimeRecord);
        end;
      end;
    end;
  end;

  // Add entries from the Edit table to the listbox
  with FDMemTable_Edit do
  begin
    if not IsEmpty then
    begin
      for I := 0 to Table.Rows.Last.Index do
      begin
        if Table.Rows.ItemsI[I].GetValues('tx_date') = CurrentDate then
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

          AddToDayList(TimeRecord);
        end;
      end;
    end;
  end;
  ListBoxDay.EndUpdate;
end;

// Gets data for Year view
procedure THeaderFooterForm.GetYearData;
var
  LDataSetList: TFDJSONDataSets;
  Day : Word;
  Month : Word;
  Year : Word;
begin
  // Get dataset list
  DecodeDate(DateEdit.Date, Year, Month, Day);
  LDataSetList := ClientModule.ServerMethods1Client.GetYear(Year);

  // Empties the memory table of any existing data before adding the new context.
  FDMemTable_Year.Close;
  FDMemTable_Year.AppendData(TFDJSONDataSetsReader.GetListValue(LDataSetList, 0));
  FDMemTable_Year.Open;

  // This year
  FDMemTable_Year.First;
  LabelThisYear.Text             := Year.ToString;
  LabelThisYearHoursData.Text    := FDMemTable_Year.FieldByName('hours').AsString;
  LabelThisYearPaidData.Text     := FDMemTable_Year.FieldByName('paid').AsString;
  LabelThisYearUnpaidData.Text   := FDMemTable_Year.FieldByName('unpaid').AsString;
  LabelThisYearEarningsData.Text := FDMemTable_Year.FieldByName('earnings').AsString;

  // Last Year
  FDMemTable_Year.Next;
  LabelLastYear.Text             := (Year-1).ToString;
  LabelLastYearHoursData.Text    := FDMemTable_Year.FieldByName('hours').AsString;
  LabelLastYearPaidData.Text     := FDMemTable_Year.FieldByName('paid').AsString;
  LabelLastYearUnpaidData.Text   := FDMemTable_Year.FieldByName('unpaid').AsString;
  LabelLastYearEarningsData.Text := FDMemTable_Year.FieldByName('earnings').AsString;
end;

// Gets data for Month view
procedure THeaderFooterForm.GetMonthData;
var
  LDataSet: TFDJSONDataSets;
  Day : Word;
  Month : Word;
  Year : Word;
begin
  // Empty memTables
  DecodeDate(DateEdit.Date, Year, Month, Day);
  LDataSet := ClientModule.ServerMethods1Client.GetMonthData(Year, Month);
  FDMemTable_Month.Close;
  FDMemTable_Month.AppendData(TFDJSONDataSetsReader.GetListValue(LDataSet, 0));
  FDMemTable_Month.Open;

    // This year
  FDMemTable_Month.First;
  LabelThisMonth.Text             := Year.ToString;
  LabelThisMonthHoursData.Text    := FDMemTable_Month.FieldByName('hours').AsString;
  LabelThisMonthPaidData.Text     := FDMemTable_Month.FieldByName('paid').AsString;
  LabelThisMonthUnpaidData.Text   := FDMemTable_Month.FieldByName('unpaid').AsString;
  LabelThisMonthEarningsData.Text := FDMemTable_Month.FieldByName('earnings').AsString;

  // Last Year
  FDMemTable_Month.Next;
  LabelLastMonth.Text             := (Year-1).ToString;
  LabelLastMonthHoursData.Text    := FDMemTable_Month.FieldByName('hours').AsString;
  LabelLastMonthPaidData.Text     := FDMemTable_Month.FieldByName('paid').AsString;
  LabelLastMonthUnpaidData.Text   := FDMemTable_Month.FieldByName('unpaid').AsString;
  LabelLastMonthEarningsData.Text := FDMemTable_Month.FieldByName('earnings').AsString;
end;

// Gets data for Week view
procedure THeaderFooterForm.GetWeekData;
var
  Week: TWeek;
  I : Integer;
  ListBoxItem : TListBoxItem;
begin

  Week := ClientModule.ServerMethods1Client.GetWeekData(DateEdit.Date);

  // Add Summaries of days to Week list.
  ListBoxWeek.BeginUpdate;
  ListBoxWeek.Items.Clear;
  for I := 0 to 6 do
  begin
    ListBoxItem := TListBoxItem.Create(ListBoxWeek);
    ListBoxItem.Text := LongDayNames[I]+'   '+DateToStr(Week.GetDay(I).Date);
    ListBoxItem.Data := Week.GetDay(I);
    ListBoxItem.ItemData.Detail := Week.GetDay(I).ToString;
    ListBoxItem.StyleLookup := 'ListBoxItemWeekStyle';
    ListBoxWeek.AddObject(ListBoxItem);
  end;
  ListBoxWeek.EndUpdate;
end;

// Gets data for Day view
procedure THeaderFooterForm.GetDayData;
var
  LDataSetList: TFDJSONDataSets;
begin
  // Empties the memory table of any existing data before adding the new context.
  FDMemTable_Day.Close;
  FDMemTable_Day.Open;

  // Get dataset list
  LDataSetList := ClientModule.ServerMethods1Client.GetDayData(DateEdit.Date);

  FDMemTable_Day.AppendData(TFDJSONDataSetsReader.GetListValue(LDataSetList, 0));

  DayDataToRecord;
end;

// Adds a TimeRecord to ListBoxDay with proper formatting
procedure THeaderFooterForm.AddToDayList(TimeRecord : TRecord);
var
  ListBoxItem : TListBoxItem;
begin
  ListBoxItem := TListBoxItem.Create(ListBoxDay);
  ListBoxItem.Text := TimeRecord.Id.ToString;
  ListBoxItem.Data := TimeRecord;
  ListBoxItem.ItemData.Detail:= TimeRecord.ToString;
  ListBoxItem.StyleLookup := 'ListBoxItem2Style1';
  ListBoxDay.AddObject(ListBoxItem);
end;

procedure THeaderFooterForm.EditDayList(TimeRecord : TRecord; TargetID : Integer);
var
  ListBoxItem : TListBoxItem;
begin
  // Change entry in Listbox
  with Main.HeaderFooterForm.ListBoxDay do
  begin
    ListBoxItem := ListItems[Items.IndexOf(TargetID.ToString)];
    ListBoxItem.Text := TimeRecord.ID.ToString;
    ListBoxItem.Data := TimeRecord;
    ListBoxItem.ItemData.Detail := TimeRecord.ToString;
  end;
end;

// Turns data for Day view to TimeRecord and adds to Day list view
procedure THeaderFooterForm.DayDataToRecord;
var
  I : Integer;
  TimeRecord : TRecord;
begin
  ListBoxDay.BeginUpdate;
  // Empty ListBox
  ListBoxDay.Items.Clear;
  // For each row in MemTable make into TimeRecord and add to ListBox
  if FDMemTable_Day.Table.Rows.Count > 0 then
  begin
    for I := 0 to FDMemTable_Day.Table.Rows.Last.Index do
    begin
      TimeRecord := TRecord.Create(
      FDMemTable_Day.Table.Rows.ItemsI[I].GetValues('time_id'),
      CurrentUser,
      FDMemTable_Day.Table.Rows.ItemsI[I].GetValues('client_id'),
      DateEdit.Date,
      FDMemTable_Day.Table.Rows.ItemsI[I].GetValues('tx_from'),
      FDMemTable_Day.Table.Rows.ItemsI[I].GetValues('tx_to'),
      FDMemTable_Day.Table.Rows.ItemsI[I].GetValues('hrs'),
      FDMemTable_Day.Table.Rows.ItemsI[I].GetValues('rate'),
      FDMemTable_Day.Table.Rows.ItemsI[I].GetValues('qty'),
      FDMemTable_Day.Table.Rows.ItemsI[I].GetValues('amt'),
      FDMemTable_Day.Table.Rows.ItemsI[I].GetValues('inv'),
      FDMemTable_Day.Table.Rows.ItemsI[I].GetValues('tx_comment'));

      AddToDayList(TimeRecord);
    end;
  end;
  ListBoxDay.EndUpdate;
end;

procedure THeaderFooterForm.Print(str: string);
begin
  ShowMessage(str);
end;

function THeaderFooterForm.GetLowestID : Integer;
begin
  if ListBoxDay.Count > 0 then
  begin
    Result := -ListBoxDay.Count-1;
  end
  else
  begin
    Result := -1;
  end;
end;

end.
