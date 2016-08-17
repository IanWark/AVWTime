unit FileController;

// Controls saving, loading, deleting files

interface
uses Main, Add, IOUtils, SysUtils, ClientModuleUnit, Data.FireDACJSONReflect, NetworkState,
     UITypes;

var
  AddFilename: string;
  EditFilename: string;
  DeleteFilename: string;

// If AVW folder doesn't exist, create it
// Should be called before saving any file
procedure EnsureDirExists;
procedure GetFromFile;
procedure RemoveFile(Str : string);
procedure RefreshClients;

implementation

  // If AVW folder doesn't exist, create it
  // Should be called before saving any file
  procedure EnsureDirExists;
  var
    DirName : String;
  begin
    DirName := IOUtils.TPath.Combine(IOUtils.TPath.GetDocumentsPath, 'AVW');
    if not DirectoryExists(DirName) then
    begin
      CreateDir(DirName);
    end;
  end;

  procedure GetFromFile;
  begin
    // Set global file names
    AddFilename := IOUtils.TPath.Combine(IOUtils.TPath.GetDocumentsPath, IOUtils.TPath.Combine('AVW','ToAdd'));
    EditFilename:= IOUtils.TPath.Combine(IOUtils.TPath.GetDocumentsPath, IOUtils.TPath.Combine('AVW','ToEdit'));
    DeleteFileName := IOUtils.TPath.Combine(IOUtils.TPath.GetDocumentsPath, IOUtils.TPath.Combine('AVW','ToDelete'));

    // If there were records added while offline, add to MemTable
    if FileExists(AddFilename+'.FDS') then
    begin
      Main.HeaderFooterForm.FDMemTable_Add.LoadFromFile(AddFilename);
      SysUtils.DeleteFile(AddFilename+'.FDS');
    end;

    // If there were records edited while offline, add to MemTable
    if FileExists(EditFilename+'.FDS') then
    begin
      Main.HeaderFooterForm.FDMemTable_Edit.LoadFromFile(EditFilename);
      SysUtils.DeleteFile(EditFilename+'.FDS');
    end;

    // If there were records deleted while offline, add to MemTable
    if FileExists(DeleteFilename+'.FDS') then
    begin
      Main.HeaderFooterForm.FDMemTable_Delete.LoadFromFile(DeleteFilename);
      SysUtils.DeleteFile(DeleteFilename+'.FDS');
    end;
  end;

  procedure RemoveFile(Str : string);
  begin
    if FileExists(Str+'.FDS') then
    begin
      DeleteFile(Str);
    end;
  end;

  procedure RefreshClients;
  var
    LDataSetList: TFDJSONDataSets;
    NS: TNetworkState;
  begin
    try
      try
        NS := TNetworkState.Create;
        if NS.IsConnected then
        begin
          // Empties the memory table of any existing data before adding the new context.
          Add.FormAdd.FDMemTable_Clients.Close;
          // Get dataset list containing Employee names
          LDataSetList := ClientModule.ServerMethods1Client.GetClients;

          // Add to MemTable
          Add.FormAdd.FDMemTable_Clients.AppendData(TFDJSONDataSetsReader.GetListValue(LDataSetList, 0));
          Add.FormAdd.FDMemTable_Clients.Open;

          // Save to file to access when offline
          EnsureDirExists;
          Add.FormAdd.FDMemTable_Clients.SaveToFile(IOUtils.TPath.Combine(IOUtils.TPath.GetDocumentsPath, IOUtils.TPath.Combine('AVW','ClientList')));
        end
        else
        begin
          Add.FormAdd.Print('You must be connected to the server to get the client list.');
        end;

      except
        on E : Exception do
        begin
          Add.FormAdd.Print((E.ClassName+' error raised with message : '+E.Message));
        end;
      end;
    finally
      NS.Free;
    end;
  end;

end.
