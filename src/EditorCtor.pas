////////////////////////////////////////////////////////////////////////////////
//
//
//  FileName    :   EditorCtor.pas
//  Creator     :   Shen Min
//  Date        :   2002-4-2
//  Comment     :
//
//
////////////////////////////////////////////////////////////////////////////////

unit EditorCtor;

interface

uses stdctrls, controls,
     Editor;

type
    TssnEditorCtor = class
    protected
        function DoCreateAnEditor(var Editor : TssnEditor; ParentCtrl : TWinControl) : Integer; virtual; abstract;
    public
        function CreateAnEditor(var Editor : TssnEditor; ParentCtrl : TWinControl) : Integer;
    end;

    TssnMemoEditorCtor = class(TssnEditorCtor)
    protected
        function DoCreateAnEditor(var Editor : TssnEditor; ParentCtrl : TWinControl) : Integer; override;
    end;

    TssnRichEditorCtor = class(TssnEditorCtor)
    protected
        function DoCreateAnEditor(var Editor : TssnEditor; ParentCtrl : TWinControl) : Integer; override;
    end;

implementation

uses MemoEditor, RichEditor, SettingMgr, GlobalObject;

{ tssnMemoEdtitorCtor }

function TssnMemoEditorCtor.DoCreateAnEditor(var Editor: TssnEditor; ParentCtrl : TWinControl): Integer;
begin
    Editor := TssnMemoEditor.Create(ParentCtrl);
    Result := Integer(Editor <> nil);
end;

{ TssnEditorCtor }

function TssnEditorCtor.CreateAnEditor(var Editor: TssnEditor;
  ParentCtrl: TWinControl): Integer;
begin
    Result := DoCreateAnEditor(Editor, ParentCtrl);
    if Boolean(Result) then
        Editor.SetFont(g_SettingMgr.GetDefaultFont());
end;

{ TssnRichEditorCtor }

function TssnRichEditorCtor.DoCreateAnEditor(var Editor: TssnEditor;
  ParentCtrl: TWinControl): Integer;
begin
    Editor := TssnRichEditor.Create(ParentCtrl);
    Result := Integer(Editor <> nil);
end;

end.
