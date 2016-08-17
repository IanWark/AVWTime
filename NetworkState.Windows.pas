unit NetworkState.Windows;

interface

uses
  NetworkState;

type
  TPlatformNetworkState = class(TCustomNetworkState)
  public
    function CurrentSSID: string; override;
    function IsConnected: Boolean; override;
    function IsWifiConnected: Boolean; override;
    function IsMobileConnected: Boolean; override;
  end;

implementation

uses
  System.SysUtils;

{ TPlatformNetworkState }

function TPlatformNetworkState.CurrentSSID: string;
begin
  Result := '';
end;

function TPlatformNetworkState.IsConnected: Boolean;
begin
  Result := True;
end;

function TPlatformNetworkState.IsMobileConnected: Boolean;
begin
  Result := True;
end;

function TPlatformNetworkState.IsWifiConnected: Boolean;
begin
  Result := True;
end;

end.
