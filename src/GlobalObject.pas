////////////////////////////////////////////////////////////////////////////////
//
//
//  FileName    :   GlobalObject.pas
//  Creator     :   Shen Min
//  Date        :   2002-4-2
//  Comment     :
//
//
////////////////////////////////////////////////////////////////////////////////

unit GlobalObject;

interface

uses Forms, SysUtils,
     WorkSpaceMgr, EditorCtor, InterActive, UMainForm, EditorEvent,
     WorkSpaceEvent, SettingMgr;

var
    g_EditorCtor : TssnEditorCtor = nil;
    g_WorkSpaceMgr : TssnWorkSpaceMgr = nil;
    g_InterActive : TssnInterActive = nil;
    g_EditorEvent : TssnEditorEvent = nil;
    g_WorkSpaceEvent : TssnWorkSpaceEvent = nil;
    g_SettingMgr : TssnSettingMgr = nil;

    g_MainForm: TMainForm = nil;


    function InitObjects() : Integer;
    procedure UnInitObjects();

implementation

uses WorkSpaceMgrCtor;

function InitObjects() : Integer;
var
    WorkSpaceMgrCtor : TssnWorkSpaceMgrCtor;
begin
    g_SettingMgr := TssnSettingMgr.Create(ChangeFileExt(ExtractFileName(Application.ExeName), ''), true);

    g_EditorEvent := TssnEditorEvent.Create();
    g_WorkSpaceEvent := TssnWorkSpaceEvent.Create();
    Application.CreateForm(TMainForm, g_MainForm);

    WorkSpaceMgrCtor := TssnTabWorkSpaceMgrCtor.Create();
    g_EditorCtor := TssnRichEditorCtor.Create();

    WOrkSpaceMgrCtor.CreateAWorkSpaceMgr(g_WorkSpaceMgr, g_MainForm.pnl_WorkSpace);
    WorkSpaceMgrCtor.Free();

    g_InterActive := TssnInterActive.Create(g_MainForm.Handle);

    g_MainForm.Init();

    Result := 1;
end;

procedure UnInitObjects();
begin
    g_InterActive.Free();
    g_InterActive := nil;

    g_EditorCtor.Free();
    g_EditorCtor := nil;

    g_WorkSpaceMgr.Free();
    g_WorkSpaceMgr := nil;

    g_WorkSpaceEvent.Free();
    g_WorkSpaceEvent := nil;

    g_EditorEvent.Free();
    g_EditorEvent := nil;

    g_SettingMgr.Free();
    g_SettingMgr := nil;
end;

end.
