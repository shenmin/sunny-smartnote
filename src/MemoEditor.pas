////////////////////////////////////////////////////////////////////////////////
//
//
//  FileName    :   MemoEditor.pas
//  Creator     :   Shen Min
//  Date        :   2002-4-2
//  Comment     :
//
//
////////////////////////////////////////////////////////////////////////////////

unit MemoEditor;

interface

uses StdCtrls, Controls, Graphics, Classes, Dialogs, SysUtils,
     Editor, IntfEditor;

type
    TssnMemoEditor = class(TssnEditor)
    private
        m_Edit : TMemo;

    protected
        procedure DoLoadFromFile(FileName : String); override;

        procedure OnMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
        procedure OnKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);

        function GetText() : String; override;

    public
        constructor Create(ParentCtrl : TWinControl);
        destructor Destroy(); override;
        
        procedure SaveToFile(FileName: String); override;

        // GetFileName
        function GetSaved() : Boolean; override;
        // Save
        // SaveAs
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
        // GetWordCount
        function GetWordWrap() : Boolean; override;
        procedure SetWordWrap(WordWrap : Boolean); override;
    end;

implementation

{ TssnMemoEditor }

function TssnMemoEditor.CanCopy: Boolean;
begin
    Result := m_Edit.SelLength <> 0;
end;

function TssnMemoEditor.CanCut: Boolean;
begin
    Result := m_Edit.SelLength <> 0;
end;

function TssnMemoEditor.CanDeleteSelection: Boolean;
begin
    Result := m_Edit.SelLength <> 0;
end;

function TssnMemoEditor.CanPaste: Boolean;
begin
    Result := true;
end;

function TssnMemoEditor.CanRedo: Boolean;
begin
    Result := true;
end;

function TssnMemoEditor.CanUndo: Boolean;
begin
    Result := true;
end;

procedure TssnMemoEditor.Copy;
begin
    m_Edit.CopyToClipboard();
end;

constructor TssnMemoEditor.Create(ParentCtrl: TWinControl);
begin
    m_Edit := TMemo.Create(nil);
    m_Edit.Parent := ParentCtrl;
    m_Edit.Align := alClient;
    m_Edit.Visible := true;
    m_Edit.WordWrap := false;
    m_Edit.ScrollBars := ssBoth;
    m_Edit.OnMouseUp := OnMouseUp;
    m_Edit.OnKeyUp := OnKeyUp;
    if m_Edit.CanFocus() then
        m_Edit.SetFocus();
end;

procedure TssnMemoEditor.Cut;
begin
    m_Edit.CutToClipboard();
end;

procedure TssnMemoEditor.DeleteLine;
begin
    m_Edit.SelStart := m_Edit.SelStart - m_Edit.CaretPos.X;
    m_Edit.SelLength := Length(m_Edit.Lines[m_Edit.CaretPos.Y]) + 2;
    m_Edit.ClearSelection();
end;

procedure TssnMemoEditor.DeleteSelection;
begin
    m_Edit.ClearSelection();
end;

function TssnMemoEditor.FindNext(Text: String; Option: TFindOptions) : Boolean;
var
    FoundAt : Integer;
    LastFoundAt : Integer;
    AllText : String;
begin
    Result := false;

    if frDown in Option then
        AllText := System.Copy(m_Edit.Text, m_Edit.SelStart + m_Edit.SelLength + 1, Length(m_Edit.Text))
    else
        AllText := System.Copy(m_Edit.Text, 1, m_Edit.SelStart);

    if frMatchCase in Option then
    begin
        AllText := UpperCase(AllText);
        Text := UpperCase(Text);
    end;

    if frDown in Option then
    begin
        FoundAt := Pos(Text, AllText);
        if FoundAt = 0 then
            Exit;
        m_Edit.SelStart := m_Edit.SelStart + m_Edit.SelLength + FoundAt;
    end
    else
    begin
        LastFoundAt := 0;
        repeat
            FoundAt := Pos(Text, AllText);
            if FoundAt <> 0 then
            begin
                AllText := System.Copy(AllText, FoundAt + 1, Length(AllText));
                LastFoundAt := LastFoundAt + FoundAt;
            end
        until FoundAt = 0;
        if LastFoundAt = 0 then
            Exit;
        m_Edit.SelStart := LastFoundAt;
    end;

    m_Edit.SelLength := Length(Text);
    Result := true;
    if m_Edit.CanFocus() then
        m_Edit.SetFocus();
end;

function TssnMemoEditor.GetSaved: Boolean;
begin
    Result := not m_Edit.Modified;
end;

function TssnMemoEditor.GetSelectText: String;
begin
    Result := m_Edit.SelText;
end;

procedure TssnMemoEditor.OnKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    OnEditorSelectionChange(Sender);
end;

procedure TssnMemoEditor.DoLoadFromFile(FileName: String);
begin
    m_Edit.Lines.LoadFromFile(FileName);
end;

procedure TssnMemoEditor.OnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    OnEditorSelectionChange(Sender);
end;

procedure TssnMemoEditor.Paste;
begin
    m_Edit.PasteFromClipboard();
end;

procedure TssnMemoEditor.Redo;
begin
    m_edit.Undo();
end;

function TssnMemoEditor.Replace(FindText, ReplaceText: String;
  Option: TFindOptions): Integer;
var
    SelText : String;
begin
    Result := 0;
    
    if frMatchCase in Option then
    begin
        SelText := UpperCase(m_Edit.SelText);
        FindText := UpperCase(FindText);
    end
    else
        SelText := m_Edit.SelText;

    if FindText = SelText then
    begin
        m_Edit.SelText := ReplaceText;
        Result := 1;
    end;

    if not (frReplaceAll in Option) then
        Exit;

    while FindNext(FindText, Option) do
    begin
        m_Edit.SelText := ReplaceText;
        Inc(Result);
    end;
end;

procedure TssnMemoEditor.SaveToFile(FileName: String);
begin
    m_Edit.Lines.SaveToFile(FileName);
end;

procedure TssnMemoEditor.SelectAll;
begin
    m_Edit.SelectAll();
end;

procedure TssnMemoEditor.SetFont(Font: TFont);
begin
    m_Edit.Font := Font;
end;

procedure TssnMemoEditor.Undo;
begin
    m_edit.Undo();
end;

function TssnMemoEditor.GetText: String;
begin
    Result := m_Edit.Lines.Text;
end;

function TssnMemoEditor.GetWordWrap: Boolean;
begin
    Result := m_Edit.WordWrap;
end;

procedure TssnMemoEditor.SetWordWrap(WordWrap: Boolean);
begin
    m_Edit.WordWrap := WordWrap;
    if WordWrap then
        m_Edit.ScrollBars := ssVertical
    else
        m_Edit.ScrollBars := ssBoth;
end;

destructor TssnMemoEditor.Destroy;
begin
    m_Edit.Free();
    m_Edit := nil;
end;

end.
