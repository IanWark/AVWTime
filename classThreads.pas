unit classThreads;

interface
uses classes, Threading, UITypes, SysUtils;

type
  TUpdateDatabase = class(TThread)
    published
      procedure Execute; override;
  end;

implementation
uses Main, DataController, NetworkState;

  // Update database asynchronously
  procedure TUpdateDatabase.Execute;
  var
    NS : TNetworkState;
  begin

    try
      try
        HeaderFooterForm.ButtonRefresh.Enabled := False;
        DataController.NumThreads := NumThreads + 1;
        NS := TNetworkState.Create;
        if NS.IsConnected then
        begin
          // DataController
          UpdateAdd;
          UpdateEdit;
          UpdateDelete;
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
      DataController.NumThreads := NumThreads - 1;
      if NumThreads = 0 then HeaderFooterForm.ButtonRefresh.Enabled := True;
    end;
  end;

end.
