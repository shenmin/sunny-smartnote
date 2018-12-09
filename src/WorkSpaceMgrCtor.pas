////////////////////////////////////////////////////////////////////////////////
//
//
//  FileName    :   WorkSpaceMgrCtor.pas
//  Creator     :   Shen Min
//  Date        :   2002-4-2
//  Comment     :
//
//
////////////////////////////////////////////////////////////////////////////////

unit WorkSpaceMgrCtor;

interface

uses Controls,
     WorkSpaceMgr;

type
    TssnWorkSpaceMgrCtor = class
    public
        function CreateAWorkSpaceMgr(var WorkSpaceMgr : TssnWorkSpaceMgr; ParentCtrl : TWinControl) : Integer; virtual; abstract;
    end;

    TssnTabWorkSpaceMgrCtor = class(TssnWorkSpaceMgrCtor)
    public
        function CreateAWorkSpaceMgr(var WorkSpaceMgr : TssnWorkSpaceMgr; ParentCtrl : TWinControl) : Integer; override;
    end;

implementation

uses TabWorkSpaceMgr;

{ TssnTabWorkSpaceMgrCtor }

function TssnTabWorkSpaceMgrCtor.CreateAWorkSpaceMgr(var WorkSpaceMgr: TssnWorkSpaceMgr; ParentCtrl: TWinControl): Integer;
begin
    WorkSpaceMgr := TssnTabWorkSpaceMgr.Create(ParentCtrl);
    Result := Integer(WOrkSpaceMgr <> nil);
end;

end.
