////////////////////////////////////////////////////////////////////////////////
//
//
//  FileName    :   InterActive.pas
//  Creator     :   Shen Min
//  Date        :   2002-4-5
//  Comment     :   Default use Win32 API
//
//
////////////////////////////////////////////////////////////////////////////////

unit InterActive;

interface

uses Windows, Dialogs, Graphics, Classes;

type
    TssnOnFindEvent = procedure (FindText : String; Options : TFindOptions) of Object;
    TssnOnReplaceEvent = procedure (FindText, ReplaceText : String; Options : TFindOptions) of Object;

    TssnInterActive = class
    private
        m_hWnd : HWND;
        m_SaveDlg : TSaveDialog;
        m_FontDlg : TFontDialog;
        m_OpenDlg : TOpenDialog;
        m_FindDlg : TFindDialog;
        m_ReplaceDlg : TReplaceDialog;

        m_OnFindCallBack : TssnOnFindEvent;
        m_OnReplaceCallBack : TssnOnReplaceEvent;
        procedure OnFind(Sender : TObject);
        procedure OnReplace(Sender : TObject);
        procedure OnReplaceFind(Sender : TObject);

    public
        constructor Create(MainWnd : HWND);
        destructor Destroy(); override;

        function MessageBox(Text, Caption : String; uType : Cardinal) : Integer; virtual;
        function ShowSaveDlg() : string; virtual;
        function ShowFontDlg() : TFont; virtual;
        function ShowOpenDlg() : TStrings; virtual;
        procedure ShowFindDlg(defFindText : String; pfOnFind : TssnOnFindEvent); virtual;
        procedure ShowReplaceDlg(defFindText : String; pfOnFind : TssnOnFindEvent; pfOnReplace : TssnOnReplaceEvent); virtual;
    end;

implementation


{ TssnInterActive }

constructor TssnInterActive.Create(MainWnd: HWND);
begin
    m_OnFindCallBack := nil;
    m_hWnd := MainWnd;

    m_SaveDlg := TSaveDialog.Create(nil);
    m_SaveDlg.Options := [ofOverwritePrompt, ofHideReadOnly];

    m_FontDlg := TFontDialog.Create(nil);

    m_OpenDlg := TOpenDialog.Create(nil);
    m_OpenDlg.Options := [ofAllowMultiSelect, ofFileMustExist];

    m_FindDlg := TFindDialog.Create(nil);
    m_FindDlg.OnFind := OnFind;

    m_ReplaceDlg := TReplaceDialog.Create(nil);
    m_ReplaceDlg.OnFind := OnReplaceFind;
    m_ReplaceDlg.OnReplace := OnReplace;
end;

destructor TssnInterActive.Destroy;
begin
    m_ReplaceDlg.Free();
    m_ReplaceDlg := nil;

    m_FindDlg.Free();
    m_FindDlg := nil;

    m_OpenDlg.Free();
    m_OpenDlg := nil;

    m_FontDlg.Free();
    m_FontDlg := nil;

    m_SaveDlg.Free();
    m_SaveDlg := nil;

    m_hWnd := 0;
end;

function TssnInterActive.MessageBox(Text, Caption: String;
  uType: Cardinal): Integer;
begin
    Result := Windows.MessageBox(m_hWnd, PChar(Text), PChar(Caption), uType);
end;

procedure TssnInterActive.OnFind(Sender: TObject);
begin
    m_FindDlg.CloseDialog();
    if Assigned(m_OnFindCallBack) then
        m_OnFindCallBack(m_FindDlg.FindText, m_FindDlg.Options);
end;

procedure TssnInterActive.OnReplace(Sender: TObject);
begin
    if Assigned(m_OnReplaceCallBack) then
        m_OnReplaceCallBack(m_ReplaceDlg.FindText, m_ReplaceDlg.ReplaceText, m_ReplaceDlg.Options);
end;

procedure TssnInterActive.OnReplaceFind(Sender: TObject);
begin
    if Assigned(m_OnFindCallBack) then
        m_OnFindCallBack(m_ReplaceDlg.FindText, m_ReplaceDlg.Options);
end;

procedure TssnInterActive.ShowFindDlg(defFindText : String; pfOnFind : TssnOnFindEvent);
begin
    m_OnFindCallBack := pfOnFind;
    m_FindDlg.FindText := defFindText;
    m_FindDlg.Execute();
end;

function TssnInterActive.ShowFontDlg: TFont;
begin
    Result := nil;
    if m_FontDlg.Execute() then
        Result := m_FontDlg.Font;
end;

function TssnInterActive.ShowOpenDlg: TStrings;
begin
    Result := nil;
    if m_OpenDlg.Execute() then
        Result := m_OpenDlg.Files;
end;

procedure TssnInterActive.ShowReplaceDlg(defFindText: String;
  pfOnFind: TssnOnFindEvent; pfOnReplace: TssnOnReplaceEvent);
begin
    m_OnReplaceCallBack := pfOnReplace;
    m_OnFindCallBack := pfOnFind;
    m_ReplaceDlg.Execute();
end;

function TssnInterActive.ShowSaveDlg: string;
begin
    Result := '';

    if m_SaveDlg.Execute() then
        Result := m_SaveDlg.FileName;
end;

end.
