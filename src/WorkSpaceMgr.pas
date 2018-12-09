////////////////////////////////////////////////////////////////////////////////
//
//
//  FileName    :   WorkSpaceMgr.pas
//  Creator     :   Shen Min
//  Date        :   2002-4-2
//  Comment     :
//
//
////////////////////////////////////////////////////////////////////////////////

unit WorkSpaceMgr;

interface

uses controls, dialogs, SysUtils,
     ssnPublic, WorkSpace;

type
    TssnWorkSpaceStatusRec = record
        Opened : Boolean;
    end;

    TssnWorkSpaceMgr = class
    private
        m_OpenedCount : Integer;

    protected
        m_WorkList : array [1 .. SSN_MAX_WORKSPACE] of TssnWorkSpace;
        m_WorkStatus : array [1 .. SSN_MAX_WORKSPACE] of TssnWorkSpaceStatusRec;

        function DoNewWorkSpace(var WorkSpace : TssnWorkSpace; FileName : String; nIndex : Integer) : Integer; virtual; abstract;
        procedure DoActiveWorkSpace(nIndex : Integer); virtual; abstract;
        function GetActiveWorkSpaceIndex() : Integer; virtual; abstract;

    public
        constructor Create();
        destructor Destroy(); override;

        function NewWorkSpace(FileName : String) : Integer;
        function CloseWorkSpace(nIndex : Integer) : Boolean;
        procedure ActiveWorkSpace(nIndex : Integer);
        function GetWorkSpace(nIndex : Integer) : TssnWorkSpace;
        function GetWorkSpaceCount() : Integer;

        function CloseAll() : Boolean;
        function SaveAll() : Boolean;

        function ActiveNextWorkSpace() : Integer;
        function GetActiveWorkSpace() : TssnWorkSpace;
    end;

implementation

uses GlobalObject;

{ TssnWorkSpaceMgr }

constructor TssnWorkSpaceMgr.Create();
var
    i : Integer;
begin
    for i := 1 to SSN_MAX_WORKSPACE do
    begin
        m_WorkList[i] := nil;
        m_WorkStatus[i].Opened := false;
    end;

    m_OpenedCount := 0;
end;

destructor TssnWorkSpaceMgr.Destroy();
var
    i : Integer;
begin
    for i := 1 to SSN_MAX_WORKSPACE do
    begin
        if m_WorkStatus[i].Opened then
        begin
            m_WorkList[i].Free();
            m_WorkList[i] := nil;
            m_WorkStatus[i].Opened := false;
        end;
    end;
end;

function TssnWorkSpaceMgr.CloseWorkSpace(nIndex : Integer): Boolean;
var
    i : Integer;
begin
    Result := false;

    if nIndex = 0 then
        Exit;
    if not m_WorkStatus[nIndex].Opened then
        Exit;

    if m_WorkList[nIndex].Close() <> 0 then
    begin
        Result := true;
        m_WorkList[nIndex].Free();
        m_WorkList[nIndex] := nil;
        m_WorkStatus[nIndex].Opened := false;
        Dec(m_OpenedCount);

        for i := nIndex - 1 downto 1 do
        begin
            if m_WorkStatus[i].Opened then
            begin
                ActiveWorkSpace(i);
                Exit;
            end;
        end;

        for i := nIndex + 1 to SSN_MAX_WORKSPACE do
        begin
            if m_WorkStatus[i].Opened then
            begin
                ActiveWorkSpace(i);
                Exit;
            end;
        end;
    end;

    g_WorkSpaceEvent.OnWorkSpaceOpenClose(nil);
end;

function TssnWorkSpaceMgr.NewWorkSpace(FileName : String): Integer;
var
    i : Integer;
begin
    Result := 0;

    for i := 1 to SSN_MAX_WORKSPACE do
    begin
        if not m_WorkStatus[i].Opened then
        begin
            Result := i;
            break;
        end;
    end;

    if Result <> 0 then
    begin
        m_WorkStatus[i].Opened := true;
        DoNewWorkSpace(m_WorkList[i], FileName, i);
        ActiveWorkSpace(i);
        Inc(m_OpenedCount);
    end;

    g_WorkSpaceEvent.OnWorkSpaceOpenClose(nil);
end;

procedure TssnWorkSpaceMgr.ActiveWorkSpace(nIndex: Integer);
begin
    if nIndex = 0 then
        Exit;
    if not m_WorkStatus[nIndex].Opened then
        Exit;
    DoActiveWorkSpace(nIndex);
end;

function TssnWorkSpaceMgr.GetActiveWorkSpace: TssnWorkSpace;
var
    nActive : Integer;
begin
    Result := nil;
    nActive := GetActiveWorkSpaceIndex();
    if nActive = 0 then
        Exit;
    Result := m_WorkList[nActive];
end;

function TssnWorkSpaceMgr.GetWorkSpace(nIndex : Integer): TssnWorkSpace;
begin
    Result := nil;
    if m_WorkStatus[nIndex].Opened then
        Result := m_WorkList[nIndex];
end;

function TssnWorkSpaceMgr.GetWorkSpaceCount: Integer;
begin
    Result := m_OpenedCount;
end;

function TssnWorkSpaceMgr.CloseAll: Boolean;
var
    i : Integer;
begin
    Result := false;
    for i := 1 to SSN_MAX_WORKSPACE do
    begin
        if not m_WorkStatus[i].Opened then
            continue;
        if not CloseWorkSpace(i) then
            Exit;
    end;
    Result := true;
end;

function TssnWorkSpaceMgr.SaveAll: Boolean;
var
    i : Integer;
begin
    Result := false;
    for i := 1 to SSN_MAX_WORKSPACE do
    begin
        if not m_WorkStatus[i].Opened then
            continue;
        if not m_WorkList[i].Save() then
            Exit;
    end;
    Result := true;
end;

function TssnWorkSpaceMgr.ActiveNextWorkSpace: Integer;
var
    i : Integer;
begin
    Result := GetActiveWorkSpaceIndex();

    if m_OpenedCount <= 1 then
        Exit;

    for i := Result + 1 to SSN_MAX_WORKSPACE do
    begin
        if not m_WorkStatus[i].Opened then
            continue;
        ActiveWorkSpace(i);
        Result := i;
        Exit;
    end;

    for i := 1 to Result - 1 do
    begin
        if not m_WorkStatus[i].Opened then
            continue;
        ActiveWorkSpace(i);
        Result := i;
        Exit;
    end;
end;

end.
