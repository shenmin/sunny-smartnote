////////////////////////////////////////////////////////////////////////////////
//
//
//  FileName    :   TabWorkSpaceMgr.pas
//  Creator     :   Shen Min
//  Date        :   2002-4-2
//  Comment     :
//
//
////////////////////////////////////////////////////////////////////////////////

unit TabWorkSpaceMgr;

interface

uses comctrls, Classes, ExtCtrls, Controls, Sysutils,
     WorkSpaceMgr, WorkSpace, MultiLan;

type
    TssnTabWorkSpaceMgr = class(TssnWorkSpaceMgr)
    private
        m_Tab : TPageControl;

    protected
        function DoNewWorkSpace(var WorkSpace : TssnWorkSpace; FileName : String; nIndex : Integer) : Integer; override;
        procedure DoActiveWorkSpace(nIndex : Integer); override;
        function GetActiveWorkSpaceIndex() : Integer; override;

    public
        constructor Create(ParentCtrl : TWinControl);
        destructor Destroy(); override;

    end;

    TssnTabWorkSpace = class(TssnWorkSpace)
    private
        m_TabSheet : TTabSheet;
        procedure SetCaption(FileName : String);

    protected
        procedure OnSave(); override;

    public
        constructor Create(Mgr : TPageControl; FileName : String; nIndex : Integer);
        destructor Destroy(); override;

        function TabWS_GetPageIndex() : Integer;
    end;

implementation

uses GlobalObject;

{ TssnTabWorkSpaceMgr }

constructor TssnTabWorkSpaceMgr.Create(ParentCtrl: TWinControl);
begin
    inherited Create();

    m_Tab := TPageControl.Create(ParentCtrl);
    m_Tab.Parent := ParentCtrl;
    m_Tab.Align := alClient;
    m_Tab.Visible := true;
    m_Tab.OnChange := g_WorkSpaceEvent.OnWorkSpaceChange;
end;

destructor TssnTabWorkSpaceMgr.Destroy;
begin
    inherited;

    m_Tab.Free();
    m_Tab := nil;
end;

function TssnTabWorkSpaceMgr.DoNewWorkSpace(var WorkSpace: TssnWorkSpace; FileName : String; nIndex : Integer): Integer;
begin
    WorkSpace := TssnTabWorkSpace.Create(self.m_Tab, FileName, nIndex);
    Result := Integer(WorkSpace <> nil);
end;

procedure TssnTabWorkSpaceMgr.DoActiveWorkSpace(nIndex: Integer);
begin
    m_Tab.ActivePageIndex := TssnTabWorkSpace(m_WorkList[nIndex]).TabWS_GetPageIndex;
end;

function TssnTabWorkSpaceMgr.GetActiveWorkSpaceIndex: Integer;
begin
    Result := 0;
    if m_Tab.PageCount = 0 then
        Exit;
        
    Result := m_Tab.ActivePage.Tag;
end;

{ TssnTabWorkSpace }

constructor TssnTabWorkSpace.Create(Mgr : TPageControl; FileName : String; nIndex : Integer);
begin
    m_TabSheet := TTabSheet.Create(nil);
    m_TabSheet.PageControl := Mgr;
    m_TabSheet.Align := alClient;
    m_TabSheet.Visible := true;
    m_TabSheet.Tag := nIndex;

    SetCaption(FileName);
    inherited Create(m_TabSheet, FileName, nIndex);
end;

destructor TssnTabWorkSpace.Destroy;
begin
    inherited;

    m_TabSheet.Free();
    m_TabSheet := nil;
end;

procedure TssnTabWorkSpace.OnSave;
begin
    SetCaption(m_Editor.GetFileName());
end;

procedure TssnTabWorkSpace.SetCaption(FileName : String);
begin
    if FileName = '' then
        m_TabSheet.Caption := str_NoTitle
    else
        m_TabSheet.Caption := System.Copy(ExtractFileName(FileName), 1, 10);
end;

function TssnTabWorkSpace.TabWS_GetPageIndex: Integer;
begin
    Result := m_TabSheet.PageIndex;
end;

end.
