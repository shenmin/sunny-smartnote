////////////////////////////////////////////////////////////////////////////////
//
//
//  FileName    :   EditorEvent.pas
//  Creator     :   Shen Min
//  Date        :   2002-4-16
//  Comment     :
//
//
////////////////////////////////////////////////////////////////////////////////

unit EditorEvent;

interface

uses Classes;

type
    TssnEditorEvent = class
    private
        m_OnEditorChange : TNotifyEvent;

    public
        procedure OnEditorSelectionChange(Sender : TObject);

        procedure SetOnEditorSelectionChange(Value : TNotifyEvent);
    end;

implementation

{ TssnEditorEvent }

procedure TssnEditorEvent.OnEditorSelectionChange(Sender : TObject);
begin
    if Assigned(m_OnEditorChange) then
        m_OnEditorChange(Sender);
end;

procedure TssnEditorEvent.SetOnEditorSelectionChange(Value : TNotifyEvent);
begin
    m_OnEditorChange := Value;
end;

end.
 