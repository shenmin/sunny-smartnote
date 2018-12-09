unit UMainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ToolWin, ExtCtrls, StdCtrls, Menus, ImgList, Buttons;

type
  TMainForm = class(TForm)
    CoolBar: TCoolBar;
    ToolBar: TToolBar;
    StatusBar: TStatusBar;
    pnl_WorkSpace: TPanel;
    tb_new: TToolButton;
    tb_open: TToolButton;
    MainMenu: TMainMenu;
    menu_file: TMenuItem;
    menu_new: TMenuItem;
    menu_open: TMenuItem;
    ImageList: TImageList;
    menu_line0: TMenuItem;
    menu_save: TMenuItem;
    tb_save: TToolButton;
    tb_line1: TToolButton;
    menu_saveall: TMenuItem;
    tb_saveall: TToolButton;
    menu_saveas: TMenuItem;
    menu_line1: TMenuItem;
    menu_close: TMenuItem;
    menu_closeall: TMenuItem;
    menu_line2: TMenuItem;
    menu_exit: TMenuItem;
    menu_edit: TMenuItem;
    menu_undo: TMenuItem;
    menu_redo: TMenuItem;
    menu_line3: TMenuItem;
    menu_cut: TMenuItem;
    menu_copy: TMenuItem;
    menu_paste: TMenuItem;
    menu_del: TMenuItem;
    menu_DeleteSelection: TMenuItem;
    menu_DeleteLine: TMenuItem;
    tb_cut: TToolButton;
    tb_copy: TToolButton;
    tb_paste: TToolButton;
    tb_del: TToolButton;
    menu_line4: TMenuItem;
    menu_selectall: TMenuItem;
    tb_line2: TToolButton;
    tb_find: TToolButton;
    menu_search: TMenuItem;
    menu_find: TMenuItem;
    menu_findnext: TMenuItem;
    menu_line5: TMenuItem;
    menu_replace: TMenuItem;
    menu_tools: TMenuItem;
    menu_WorkSpace: TMenuItem;
    menu_Help: TMenuItem;
    menu_wordcount: TMenuItem;
    menu_line6: TMenuItem;
    menu_setting: TMenuItem;
    menu_nextworkspace: TMenuItem;
    menu_about: TMenuItem;
    menu_line7: TMenuItem;
    menu_wrap: TMenuItem;
    procedure menu_newClick(Sender: TObject);
    procedure menu_openClick(Sender: TObject);
    procedure menu_saveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure menu_saveallClick(Sender: TObject);
    procedure menu_saveasClick(Sender: TObject);
    procedure menu_closeClick(Sender: TObject);
    procedure menu_closeallClick(Sender: TObject);
    procedure menu_exitClick(Sender: TObject);
    procedure menu_undoClick(Sender: TObject);
    procedure menu_redoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure menu_cutClick(Sender: TObject);
    procedure menu_copyClick(Sender: TObject);
    procedure menu_pasteClick(Sender: TObject);
    procedure menu_DeleteSelectionClick(Sender: TObject);
    procedure menu_DeleteLineClick(Sender: TObject);
    procedure menu_selectallClick(Sender: TObject);
    procedure menu_findClick(Sender: TObject);
    procedure menu_findnextClick(Sender: TObject);
    procedure menu_replaceClick(Sender: TObject);
    procedure menu_wordcountClick(Sender: TObject);
    procedure menu_nextworkspaceClick(Sender: TObject);
    procedure menu_aboutClick(Sender: TObject);
    procedure menu_settingClick(Sender: TObject);
    procedure menu_wrapClick(Sender: TObject);
  private
    m_LastFindText : String;
    m_LastFindOption : TFindOptions;

  public
    procedure Init();
    procedure UpdateMenuToolBar_WorkSpace();
    procedure UpdateMenuToolBar_Editor();

    procedure OnEditorChange(Sender : TObject);
    procedure OnWorkSpaceOpenClose(Sender : TObject);
    procedure OnWorkSpaceChange(Sender : TObject);
    procedure OnFind(FindText : String; Options : TFindOptions);
    procedure OnReplace(FindText, ReplaceText : String; Options : TFindOptions);
  end;

implementation

uses GlobalObject, WorkSpace, MultiLan, IntfEditor, ssnPublic;

{$R *.DFM}

procedure TMainForm.menu_newClick(Sender: TObject);
begin
    g_WorkSpaceMgr.NewWorkSpace('');
    UpdateMenuToolBar_WorkSpace();
    UpdateMenuToolBar_Editor();
end;

procedure TMainForm.menu_openClick(Sender: TObject);
var
    FileList : TStrings;
    i : Integer;
begin
    FileList := g_InterActive.ShowOpenDlg();
    if FileList = nil then
        Exit;

    for i := 0 to FileList.Count - 1 do
    begin
        try
            g_WorkSpaceMgr.NewWorkSpace(FileList[i]);
        except
            g_InterActive.MessageBox(Format(str_LoadError, [FileList[i]]), Application.Title, MB_ICONSTOP);
        end;
    end;

    UpdateMenuToolBar_WorkSpace();
end;

procedure TMainForm.UpdateMenuToolBar_WorkSpace;
var
    bEnable : Boolean;
    nWorkSpaceCount : Integer;
begin
    nWorkSpaceCount := g_WorkSpaceMgr.GetWorkSpaceCount();

    if nWorkSpaceCount > 0 then
        bEnable := true
    else
        bEnable := false;

    menu_save.Enabled := bEnable;
    tb_save.Enabled := bEnable;
    menu_saveas.Enabled := bEnable;
    menu_saveall.Enabled := bEnable;
    tb_saveall.Enabled := bEnable;
    menu_close.Enabled := bEnable;
    menu_closeall.Enabled := bEnable;
    menu_undo.Enabled := bEnable;
    menu_redo.Enabled := bEnable;
    menu_cut.Enabled := bEnable;
    tb_cut.Enabled := bEnable;
    menu_copy.Enabled := bEnable;
    tb_copy.Enabled := bEnable;
    menu_paste.Enabled := bEnable;
    tb_paste.Enabled := bEnable;
    menu_del.Enabled := bEnable;
    tb_del.Enabled := bEnable;
    menu_selectall.Enabled := bEnable;
    menu_find.Enabled := bEnable;
    tb_find.Enabled := bEnable;
    menu_findnext.Enabled := bEnable;
    menu_replace.Enabled := bEnable;
    menu_wordcount.Enabled := bEnable;
    menu_wrap.Enabled := bEnable;

    if nWorkSpaceCount > 1 then
        menu_nextworkspace.Enabled := true
    else
        menu_nextworkspace.Enabled := false;
end;

procedure TMainForm.menu_saveClick(Sender: TObject);
var
    CurWorkSpace : TssnWorkSpace;
begin
    CurWorkSpace := g_WorkSpaceMgr.GetActiveWorkSpace();
    if CurWorkSpace = nil then
        Exit;
    try
        CurWorkSpace.Save()
    except
        g_InterActive.MessageBox(str_SaveError, Application.Title, MB_ICONSTOP);
        menu_saveas.Click();
    end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    if not g_WorkSpaceMgr.CloseAll() then
        Action := caNone;
end;

procedure TMainForm.menu_saveallClick(Sender: TObject);
begin
    g_WorkSpaceMgr.SaveAll();
end;

procedure TMainForm.menu_saveasClick(Sender: TObject);
var
    CurWorkSpace : TssnWorkSpace;
begin
    CurWorkSpace := g_WorkSpaceMgr.GetActiveWorkSpace();
    if CurWorkSpace = nil then
        Exit;
    try
        CurWorkSpace.SaveAs()
    except
        g_InterActive.MessageBox(str_SaveError, Application.Title, MB_ICONSTOP);
    end;
end;

procedure TMainForm.menu_closeClick(Sender: TObject);
var
    CurWorkSpace : TssnWorkSpace;
begin
    CurWorkSpace := g_WorkSpaceMgr.GetActiveWorkSpace();
    if CurWorkSpace = nil then
        Exit;
    g_WorkSpaceMgr.CloseWorkSpace(CurWorkSpace.GetIndex());
end;

procedure TMainForm.menu_closeallClick(Sender: TObject);
begin
    g_WorkSpaceMgr.CloseAll();
end;

procedure TMainForm.menu_exitClick(Sender: TObject);
begin
    Close();
end;

procedure TMainForm.UpdateMenuToolBar_Editor;
var
    CurWorkSpace : TssnWorkSpace;
begin
    CurWorkSpace := g_WorkSpaceMgr.GetActiveWorkSpace();
    if CurWorkSpace = nil then
        Exit;
    menu_undo.Enabled := CurWorkSpace.CanUndo();
    menu_redo.Enabled := CurWorkSpace.CanRedo();
    menu_cut.Enabled := CurWorkSpace.CanCut();
    tb_cut.Enabled := menu_cut.Enabled;
    menu_copy.Enabled := CurWorkSpace.CanCopy();
    tb_copy.Enabled := menu_copy.Enabled;
    menu_paste.Enabled := CurWorkSpace.CanPaste();
    tb_paste.Enabled := menu_paste.Enabled;
    menu_deleteselection.Enabled := CurWorkSpace.CanDeleteSelection();
    tb_del.Enabled := menu_deleteselection.Enabled;
end;

procedure TMainForm.menu_undoClick(Sender: TObject);
var
    CurWorkSpace : TssnWorkSpace;
begin
    CurWorkSpace := g_WorkSpaceMgr.GetActiveWorkSpace();
    if CurWorkSpace = nil then
        Exit;
    CurWorkSpace.Undo();
    UpdateMenuToolBar_Editor();
end;

procedure TMainForm.menu_redoClick(Sender: TObject);
var
    CurWorkSpace : TssnWorkSpace;
begin
    CurWorkSpace := g_WorkSpaceMgr.GetActiveWorkSpace();
    if CurWorkSpace = nil then
        Exit;
    CurWorkSpace.Redo();
    UpdateMenuToolBar_Editor();
end;

procedure TMainForm.Init;
begin
    UpdateMenuToolBar_WorkSpace();
    UpdateMenuToolBar_Editor();
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
    g_EditorEvent.SetOnEditorSelectionChange(OnEditorChange);
    g_WorkSpaceEvent.SetOnWorkSpaceOpenClose(OnWorkSpaceOpenClose);
    g_WorkSpaceEvent.SetOnWorkSpaceChange(OnWorkSpaceChange);
end;

procedure TMainForm.OnEditorChange(Sender: TObject);
begin
    UpdateMenuToolBar_Editor();
end;

procedure TMainForm.menu_cutClick(Sender: TObject);
var
    CurWorkSpace : TssnWorkSpace;
begin
    CurWorkSpace := g_WorkSpaceMgr.GetActiveWorkSpace();
    if CurWorkSpace = nil then
        Exit;
    CurWorkSpace.Cut();
    UpdateMenuToolBar_Editor();
end;

procedure TMainForm.menu_copyClick(Sender: TObject);
var
    CurWorkSpace : TssnWorkSpace;
begin
    CurWorkSpace := g_WorkSpaceMgr.GetActiveWorkSpace();
    if CurWorkSpace = nil then
        Exit;
    CurWorkSpace.Copy();
    UpdateMenuToolBar_Editor();
end;

procedure TMainForm.menu_pasteClick(Sender: TObject);
var
    CurWorkSpace : TssnWorkSpace;
begin
    CurWorkSpace := g_WorkSpaceMgr.GetActiveWorkSpace();
    if CurWorkSpace = nil then
        Exit;
    CurWorkSpace.Paste();
    UpdateMenuToolBar_Editor();
end;

procedure TMainForm.menu_DeleteSelectionClick(Sender: TObject);
var
    CurWorkSpace : TssnWorkSpace;
begin
    CurWorkSpace := g_WorkSpaceMgr.GetActiveWorkSpace();
    if CurWorkSpace = nil then
        Exit;
    CurWorkSpace.DeleteSelection();
    UpdateMenuToolBar_Editor();
end;

procedure TMainForm.menu_DeleteLineClick(Sender: TObject);
var
    CurWorkSpace : TssnWorkSpace;
begin
    CurWorkSpace := g_WorkSpaceMgr.GetActiveWorkSpace();
    if CurWorkSpace = nil then
        Exit;
    CurWorkSpace.DeleteLine();
    UpdateMenuToolBar_Editor();
end;

procedure TMainForm.OnWorkSpaceOpenClose(Sender: TObject);
begin
    UpdateMenuToolBar_WorkSpace();
end;

procedure TMainForm.menu_selectallClick(Sender: TObject);
var
    CurWorkSpace : TssnWorkSpace;
begin
    CurWorkSpace := g_WorkSpaceMgr.GetActiveWorkSpace();
    if CurWorkSpace = nil then
        Exit;
    CurWorkSpace.SelectAll();
    UpdateMenuToolBar_Editor();
end;

procedure TMainForm.menu_findClick(Sender: TObject);
var
    CurWorkSpace : TssnWorkSpace;
begin
    CurWorkSpace := g_WorkSpaceMgr.GetActiveWorkSpace();
    if CurWorkSpace = nil then
        Exit;
    g_InterActive.ShowFindDlg(CurWorkSpace.GetSelectText(), OnFind);
    UpdateMenuToolBar_Editor();
end;

procedure TMainForm.OnFind(FindText: String; Options: TFindOptions);
var
    CurWorkSpace : TssnWorkSpace;
begin
    CurWorkSpace := g_WorkSpaceMgr.GetActiveWorkSpace();
    if CurWorkSpace = nil then
        Exit;
    m_LastFindText := FindText;
    m_LastFindOption := Options;
    if not CurWorkSpace.FindNext(FindText, Options) then
        g_InterActive.MessageBox(Format(str_NotFindText, [FindText]), Application.Title, MB_ICONINFORMATION);
    UpdateMenuToolBar_Editor();
end;

procedure TMainForm.menu_findnextClick(Sender: TObject);
var
    CurWorkSpace : TssnWorkSpace;
begin
    CurWorkSpace := g_WorkSpaceMgr.GetActiveWorkSpace();
    if CurWorkSpace = nil then
        Exit;
    if not CurWorkSpace.FindNext(m_LastFindText, m_LastFindOption) then
        g_InterActive.MessageBox(Format(str_NotFindText, [m_LastFindText]), Application.Title, MB_ICONINFORMATION);
    UpdateMenuToolBar_Editor();
end;

procedure TMainForm.OnReplace(FindText, ReplaceText: String;
  Options: TFindOptions);
var
    CurWorkSpace : TssnWorkSpace;
    ReplaceCount : Integer;
begin
    CurWorkSpace := g_WorkSpaceMgr.GetActiveWorkSpace();
    if CurWorkSpace = nil then
        Exit;
    ReplaceCount := CurWorkSpace.Replace(FindText, ReplaceText, Options);
    if frReplaceAll in Options then
        g_InterActive.MessageBox(Format(str_ReplacedAll, [ReplaceCount]), Application.Title, MB_ICONINFORMATION)
    else if not CurWorkSpace.FindNext(FindText, Options) then
        g_InterActive.MessageBox(Format(str_NotFindText, [m_LastFindText]), Application.Title, MB_ICONINFORMATION);
    UpdateMenuToolBar_Editor();
end;

procedure TMainForm.menu_replaceClick(Sender: TObject);
var
    CurWorkSpace : TssnWorkSpace;
begin
    CurWorkSpace := g_WorkSpaceMgr.GetActiveWorkSpace();
    if CurWorkSpace = nil then
        Exit;
    g_InterActive.ShowReplaceDlg(CurWorkSpace.GetSelectText(), OnFind, OnReplace);
    UpdateMenuToolBar_Editor();
end;

procedure TMainForm.menu_wordcountClick(Sender: TObject);
var
    CurWorkSpace : TssnWorkSpace;
    CountResult : TssnWordCountRec;
begin
    CurWorkSpace := g_WorkSpaceMgr.GetActiveWorkSpace();
    if CurWorkSpace = nil then
        Exit;
    CountResult := CurWorkSpace.GetWordCount();
    g_InterActive.MessageBox(
        String(str_CountResult) +
        SSN_ENTER_CHAR + SSN_ENTER_CHAR +
        String(str_AnsiChar) + IntToStr(CountResult.AnsiChar) + SSN_ENTER_CHAR +
        String(str_MultiChar) + IntToStr(CountResult.MultiChar) + SSN_ENTER_CHAR +
        String(str_NumChar) + IntToStr(CountResult.NumChar) + SSN_ENTER_CHAR +
        String(str_OtherChar) + IntToStr(CountResult.Other),
        Application.Title,
        MB_ICONINFORMATION
    );
    UpdateMenuToolBar_Editor();
end;

procedure TMainForm.menu_nextworkspaceClick(Sender: TObject);
begin
    g_WorkSpaceMgr.ActiveNextWorkSpace();
end;

procedure TMainForm.menu_aboutClick(Sender: TObject);
begin
    g_InterActive.MessageBox(
        'Sunny SmartNote 5.0 (OpenSource Edition)' + SSN_ENTER_CHAR + SSN_ENTER_CHAR +
        'build 2002.5.17' + SSN_ENTER_CHAR + SSN_ENTER_CHAR +
        'Author : Shen Min' + SSN_ENTER_CHAR +
        'Copyright(c) 1999-2002 by Sunisoft' + SSN_ENTER_CHAR +
        'http://www.sunisoft.com',
        Application.Title,
        MB_ICONINFORMATION
    );
end;

procedure TMainForm.menu_settingClick(Sender: TObject);
var
    Font : TFont;
begin
    Font := g_InterActive.ShowFontDlg();
    if Font <> nil then
        g_SettingMgr.SetDefaultFont(Font);
end;

procedure TMainForm.menu_wrapClick(Sender: TObject);
var
    CurWorkSpace : TssnWorkSpace;
begin
    CurWorkSpace := g_WorkSpaceMgr.GetActiveWorkSpace();
    if CurWorkSpace = nil then
        Exit;
    CurWorkSpace.SetWordWrap(menu_wrap.Checked);
    UpdateMenuToolBar_Editor();
end;

procedure TMainForm.OnWorkSpaceChange(Sender: TObject);
var
    CurWorkSpace : TssnWorkSpace;
begin
    CurWorkSpace := g_WorkSpaceMgr.GetActiveWorkSpace();
    if CurWorkSpace = nil then
        Exit;
    menu_wrap.Checked := CurWorkSpace.GetWordWrap();
    StatusBar.SimpleText := CurWorkSpace.GetFileName(); 
end;

end.
