unit usuarioClass;

interface

type
  TSession = class
  private
    class var Fid: integer;
    class var FEMAIL: string;
    class var Fpassword: string;
    class var Fname: string;
    class var FlastName: string;
    class var Frequires2FA: Boolean;
  public
     class property id: integer read Fid write Fid;
     class property EMAIL: string read FEMAIL write FEMAIL;
     class property password: string read Fpassword write Fpassword;
     class property name: string read Fname write Fname;
     class property lastName: string read FlastName write FlastName;
     class property requires2FA: Boolean read Frequires2FA write Frequires2FA;
  end;

implementation

end.

