////////////////////////////////////////////////////////////////////////////////
//
//
//  FileName    :   WorkSpaceEvent.pas
//  Creator     :   Shen Min
//  Date        :   2002-4-16
//  Comment     :
//
//
////////////////////////////////////////////////////////////////////////////////

unit WorkSpaceEvent;

interface

uses Classes;

type
    TssnWorkSpaceEvent = class
    private
        m_OnWorkSpaceOpenClose : TNotifyEvent;
        m_OnWorkSpaceChange : TNotifyEvent;

    public
        procedure OnWorkSpaceOpenClose(Sender : TObject);
        procedure OnWorkSpaceChange(Sender : TObject);

        procedure SetOnWorkSpaceOpenClose(Value : TNotifyEvent);
        procedure SetOnWorkSpaceChange(Value : TNotifyEvent);
    end;

implementation

{ TssnWorkSpaceEvent }

procedure TssnWorkSpaceEvent.OnWorkSpaceChange(Sender: TObject);
begin
    if Assigned(m_OnWorkSpaceChange) then
        m_OnWorkSpaceChange(Sender);
end;

procedure TssnWorkSpaceEvent.OnWorkSpaceOpenClose(Sender: TObject);
begin
    if Assigned(m_OnWorkSpaceOpenClose) then
        m_OnWorkSpaceOpenClose(Sender);
end;

procedure TssnWorkSpaceEvent.SetOnWorkSpaceChange(Value: TNotifyEvent);
begin
    m_OnWorkSpaceChange := Value;
end;

procedure TssnWorkSpaceEvent.SetOnWorkSpaceOpenClose(Value: TNotifyEvent);
begin
    m_OnWorkSpaceOpenClose := Value;
end;

end.
 