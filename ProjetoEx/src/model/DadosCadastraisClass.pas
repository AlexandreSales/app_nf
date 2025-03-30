unit DadosCadastraisClass;

interface

uses
  System.SysUtils, System.Classes;

type
  TDadosCadastrais = class
  private
    FCNPJ: string;
    FRazaoSocial: string;
    FNomeFantasia: string;
    FInscricaoMunicipal: string;
    FCEP: string;
    FRua: string;
    FNumero: string;
    FBairro: string;
    FCidade: string;
    FEstado: string;
    FEmail: string;
    FTelefone: string;
    FFoto: string; // <- Campo adicionado
  public
    property CNPJ: string read FCNPJ write FCNPJ;
    property RazaoSocial: string read FRazaoSocial write FRazaoSocial;
    property NomeFantasia: string read FNomeFantasia write FNomeFantasia;
    property InscricaoMunicipal: string read FInscricaoMunicipal write FInscricaoMunicipal;
    property CEP: string read FCEP write FCEP;
    property Rua: string read FRua write FRua;
    property Numero: string read FNumero write FNumero;
    property Bairro: string read FBairro write FBairro;
    property Cidade: string read FCidade write FCidade;
    property Estado: string read FEstado write FEstado;
    property Email: string read FEmail write FEmail;
    property Telefone: string read FTelefone write FTelefone;
    property Foto: string read FFoto write FFoto; // <- Nova propriedade

    constructor Create; overload;
    constructor Create(const ACNPJ, ARazaoSocial, ANomeFantasia, AInscricaoMunicipal, ACEP, ARua, ANumero, ABairro, ACidade, AEstado, AEmail, ATelefone, AFoto: string); overload;
  end;

implementation

{ TDadosCadastrais }

constructor TDadosCadastrais.Create;
begin
  inherited Create;
end;

constructor TDadosCadastrais.Create(const ACNPJ, ARazaoSocial, ANomeFantasia, AInscricaoMunicipal, ACEP, ARua, ANumero, ABairro, ACidade, AEstado, AEmail, ATelefone, AFoto: string);
begin
  inherited Create;
  FCNPJ := ACNPJ;
  FRazaoSocial := ARazaoSocial;
  FNomeFantasia := ANomeFantasia;
  FInscricaoMunicipal := AInscricaoMunicipal;
  FCEP := ACEP;
  FRua := ARua;
  FNumero := ANumero;
  FBairro := ABairro;
  FCidade := ACidade;
  FEstado := AEstado;
  FEmail := AEmail;
  FTelefone := ATelefone;
  FFoto := AFoto; // <- Atribui a foto
end;

end.

