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
  public
     class property id: integer read Fid write Fid;
     class property EMAIL: string read FEMAIL write FEMAIL;
     class property password: string read Fpassword write Fpassword;
     class property name: string read Fname write Fname;
     class property lastName: string read FlastName write FlastName;
  end;

implementation

end.
