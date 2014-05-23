program snote;

uses
  Forms,
  UMainForm in 'UMainForm.pas' {MainForm},
  Editor in 'Editor.pas',
  ssnPublic in 'ssnPublic.pas',
  WorkSpaceMgr in 'WorkSpaceMgr.pas',
  WorkSpace in 'WorkSpace.pas',
  TabWorkSpaceMgr in 'TabWorkSpaceMgr.pas',
  GlobalObject in 'GlobalObject.pas',
  EditorCtor in 'EditorCtor.pas',
  MemoEditor in 'MemoEditor.pas',
  WorkSpaceMgrCtor in 'WorkSpaceMgrCtor.pas',
  MultiLan in 'MultiLan.pas',
  InterActive in 'InterActive.pas',
  IntfEditor in 'IntfEditor.pas',
  SettingMgr in 'SettingMgr.pas',
  EditorEvent in 'EditorEvent.pas',
  WorkSpaceEvent in 'WorkSpaceEvent.pas',
  RichEditor in 'RichEditor.pas';

{$R *.RES}

begin
    Application.Initialize;
    try
        InitObjects();
        Application.Title := 'Sunny SmartNote 5';
        Application.Run;
    finally
        UnInitObjects();
    end;
end.
