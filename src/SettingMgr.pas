////////////////////////////////////////////////////////////////////////////////
//
//
//  FileName    :   SettingMgr.pas
//  Creator     :   Shen Min
//  Date        :   2002-4-29
//  Comment     :
//
//
////////////////////////////////////////////////////////////////////////////////

unit SettingMgr;

interface

uses Graphics, IniFiles;

type
    TssnSettingMgr = class
    private
        m_SaveWhenSet : Boolean;

    protected
        m_SettingName : String;
        m_Font : TFont;

        procedure LoadSettings(); virtual;
        procedure SaveSettings(); virtual;

    public
        procedure SetDefaultFont(Font : TFont);
        function GetDefaultFont() : TFont;

        constructor Create(SettingName : String; SaveWhenSet : Boolean);
        destructor Destroy(); override;
    end;

implementation

uses ssnPublic;

{ TssnSettingMgr }

constructor TssnSettingMgr.Create(SettingName: String; SaveWhenSet : Boolean);
begin
    m_SettingName := SettingName;
    m_SaveWhenSet := SaveWhenSet;

    m_Font := TFont.Create();;

    LoadSettings();
end;

destructor TssnSettingMgr.Destroy;
begin
    SaveSettings();

    m_Font.Free();
end;

function TssnSettingMgr.GetDefaultFont: TFont;
begin
    Result := m_Font;
end;

procedure TssnSettingMgr.LoadSettings;
var
    IniFile : TIniFile;
begin
    IniFile := TIniFile.Create(GetExePath() + m_SettingName + '.ini');

    // Font
    m_Font.Name := IniFile.ReadString('Editor', 'FontName', 'Comic Sans MS');
    m_Font.Size := IniFile.ReadInteger('Editor', 'FontSize', 10);
    m_Font.Color := IniFile.ReadInteger('Editor', 'FontColor', clBlack);

    IniFile.Free();
end;

procedure TssnSettingMgr.SaveSettings;
var
    IniFile : TIniFile;
begin
    IniFile := TIniFile.Create(GetExePath() + m_SettingName + '.ini');

    // Font
    IniFile.WriteString('Editor', 'FontName', m_Font.Name);
    IniFile.WriteInteger('Editor', 'FontSize', m_Font.Size);
    IniFile.WriteInteger('Editor', 'FontColor', m_Font.Color);

    IniFile.Free();
end;

procedure TssnSettingMgr.SetDefaultFont(Font: TFont);
begin
    m_Font.Assign(Font);
    if m_SaveWhenSet then
        SaveSettings();
end;

end.
