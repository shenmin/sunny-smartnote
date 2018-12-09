////////////////////////////////////////////////////////////////////////////////
//
//
//  FileName    :   WorkSpace.pas
//  Creator     :   Shen Min
//  Date        :   2002-4-2
//  Comment     :
//
//
////////////////////////////////////////////////////////////////////////////////

unit WorkSpace;

interface

uses Controls, Forms, Windows, Graphics, Dialogs,
     Editor, IntfEditor;

type
    TssnWorkSpace = class(IssnEditor)
    protected
        m_Editor : TssnEditor;
        m_Index : Integer;

        procedure OnSave(); virtual; abstract;

    public
        constructor Create(ParentCtrl : TWinControl; FileName : String; nIndex : Integer);

        function Close() : Integer;
        function GetIndex() : Integer;

        function GetFileName() : String; override;
        function GetSaved() : Boolean; override;
        function Save() : Boolean; override;
        function SaveAs() : Boolean; override;
        function GetSelectText() : String; override;
        procedure SetFont(Font : TFont); override;
        procedure Undo(); override;
        function CanUndo() : Boolean; override;
        procedure Redo(); override;
        function CanRedo() : Boolean; override;
        procedure Cut(); override;
        function CanCut() : Boolean; override;
        procedure Copy(); override;
        function CanCopy() : Boolean; override;
        procedure Paste(); override;
        function CanPaste() : Boolean; override;
        procedure DeleteSelection(); override;
        function CanDeleteSelection() : Boolean; override;
        procedure DeleteLine(); override;
        procedure SelectAll(); override;
        function FindNext(Text : String; Option : TFindOptions) : Boolean; override;
        function Replace(FindText, ReplaceText : String; Option : TFindOptions) : Integer; override;
        function GetWordCount() : TssnWordCountRec; override;
        function GetWordWrap() : Boolean; override;
        procedure SetWordWrap(WordWrap : Boolean); override;
    end;

implementation

uses GlobalObject, MultiLan;

{ TssnWorkSpace }

function TssnWorkSpace.CanCopy: Boolean;
begin
    Result := m_Editor.CanCopy();
end;

function TssnWorkSpace.CanCut: Boolean;
begin
    Result := m_Editor.CanCut();
end;

function TssnWorkSpace.CanDeleteSelection: Boolean;
begin
    Result := m_Editor.CanDeleteSelection();
end;

function TssnWorkSpace.CanPaste: Boolean;
begin
    Result := m_Editor.CanPaste();
end;

function TssnWorkSpace.CanRedo: Boolean;
begin
    Result := m_Editor.CanRedo();
end;

function TssnWorkSpace.CanUndo: Boolean;
begin
    Result := m_Editor.CanUndo();
end;

function TssnWorkSpace.Close: Integer;
var
    AskRusult : Integer;
begin
    Result := 0;

    if not m_Editor.GetSaved() then
    begin
        AskRusult := g_InterActive.MessageBox(str_PromptSave, Application.Title, MB_YESNOCANCEL or MB_ICONQUESTION);
        if AskRusult = IDYES then
        begin // save
            try
                if not m_Editor.Save() then
                    Exit;
            except
                g_InterActive.MessageBox(str_SaveError, Application.Title, MB_ICONSTOP);
                Exit;
            end;
        end
        else if AskRusult = IDCANCEL then
            Exit;
    end;

    m_Editor.Free();
    m_Editor := nil;

    Result := 1;
end;

procedure TssnWorkSpace.Copy;
begin
    m_Editor.Copy();
end;

constructor TssnWorkSpace.Create(ParentCtrl : TWinControl; FileName : String; nIndex : Integer);
begin
    g_EditorCtor.CreateAnEditor(m_Editor, ParentCtrl);

    if FileName <> '' then
        m_Editor.LoadFromFile(FileName);

    m_Index := nIndex;
end;

procedure TssnWorkSpace.Cut;
begin
    m_Editor.Cut();
end;

procedure TssnWorkSpace.DeleteLine;
begin
    m_Editor.DeleteLine();
end;

procedure TssnWorkSpace.DeleteSelection;
begin
    m_Editor.DeleteSelection();
end;

function TssnWorkSpace.FindNext(Text: String; Option: TFindOptions) : Boolean;
begin
    Result := m_Editor.FindNext(Text, Option);
end;

function TssnWorkSpace.GetFileName: String;
begin
    Result := m_Editor.GetFileName();
end;

function TssnWorkSpace.GetIndex: Integer;
begin
    Result := m_Index;
end;

function TssnWorkSpace.GetSaved: Boolean;
begin
    Result := m_Editor.GetSaved();
end;

function TssnWorkSpace.GetSelectText: String;
begin
    Result := m_Editor.GetSelectText();
end;

function TssnWorkSpace.GetWordCount: TssnWordCountRec;
begin
    Result := m_Editor.GetWordCount();
end;

function TssnWorkSpace.GetWordWrap: Boolean;
begin
    Result := m_Editor.GetWordWrap();
end;

procedure TssnWorkSpace.Paste;
begin
    m_Editor.Paste();
end;

procedure TssnWorkSpace.Redo;
begin
    m_Editor.Redo();
end;

function TssnWorkSpace.Replace(FindText, ReplaceText: String;
  Option: TFindOptions): Integer;
begin
    Result := m_Editor.Replace(FindText, ReplaceText, Option);
end;

function TssnWorkSpace.Save : Boolean;
begin
    Result := m_Editor.Save();
    OnSave();
end;

function TssnWorkSpace.SaveAs: Boolean;
begin
    Result := m_Editor.SaveAs();
    OnSave();
end;

procedure TssnWorkSpace.SelectAll;
begin
    m_Editor.SelectAll();
end;

procedure TssnWorkSpace.SetFont(Font: TFont);
begin
    m_Editor.SetFont(Font);
end;

procedure TssnWorkSpace.SetWordWrap(WordWrap: Boolean);
begin
    m_Editor.SetWordWrap(WordWrap);
end;

procedure TssnWorkSpace.Undo;
begin
    m_Editor.Undo();
end;

end.
