////////////////////////////////////////////////////////////////////////////////
//
//
//  FileName    :   Editor.pas
//  Creator     :   Shen Min
//  Date        :   2002-4-2
//  Comment     :
//
//
////////////////////////////////////////////////////////////////////////////////

unit Editor;

interface

uses Controls, Graphics,
     IntfEditor;

type
    TssnEditor = class(IssnEditor)
    private
        m_FileName : String;
        
    protected
        procedure DoLoadFromFile(FileName : String); virtual; abstract;
        procedure OnEditorSelectionChange(Sender : TObject);

        function GetText() : String; virtual; abstract;

    public
        procedure LoadFromFile(FileName : String);
        procedure SaveToFile(FileName : String); virtual; abstract;
        function Save() : Boolean; override;
        function SaveAs() : Boolean; override;
        function GetWordCount() : TssnWordCountRec; override;

        function GetFileName() : String; override;
    end;

implementation

uses GlobalObject;

{ TssnEditor }

function TssnEditor.GetFileName: String;
begin
    Result := m_FileName;
end;

function TssnEditor.GetWordCount: TssnWordCountRec;
var
    AllText : String;
    bHalf : Boolean;
    i : Integer;
    nAsc : Integer;
begin
    AllText := GetText();
    bHalf := false;

    for i := 1 to Length(AllText) do
    begin
        nAsc := ord(AllText[i]);

        if bHalf then
        begin
            bHalf := false;
            nAsc := 0;
        end;

        if nAsc > 127 then
        begin //chinese
            if not bHalf then
                Inc(Result.MultiChar);
            bHalf := not bHalf;
        end

        else if (nAsc >= 48) and (nAsc <= 57) then
            Inc(Result.NumChar)

        else if (nAsc >= 65) and (nAsc <= 90) then
            Inc(Result.AnsiChar)

        else if (nAsc >= 97) and (nAsc <= 122) then
            Inc(Result.AnsiChar)

        else if (nAsc <> 32) and (nAsc <> 0) and (nAsc <> 13) and (nAsc <> 10) then
            Inc(Result.Other);
    end;
end;

procedure TssnEditor.LoadFromFile(FileName: String);
begin
    m_FileName := FileName;
    if FileName <> '' then
        DoLoadFromFile(FileName);
end;

procedure TssnEditor.OnEditorSelectionChange(Sender: TObject);
begin
    g_EditorEvent.OnEditorSelectionChange(Sender);
end;

function TssnEditor.Save: Boolean;
begin
    if m_FileName = '' then
    begin
        Result := SaveAs();
        Exit;
    end;

    SaveToFile(m_Filename);
    Result := true;
end;

function TssnEditor.SaveAs: Boolean;
var
    FileName : String;
begin
    Result := false;
    FileName := g_InterActive.ShowSaveDlg();
    if FileName = '' then
        Exit;
    SaveToFile(FileName);
    m_FileName := FileName;
    Result := true;
end;

end.
