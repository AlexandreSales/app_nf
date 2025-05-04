unit common.consts;

{$define test}

interface

const
  {$if defined(test)}
    baseURL = 'http://192.168.0.77:3000';
  {$endif}

  {$if defined(production)}
    baseURL = 'https://minhaapi.com.br';
  {$endif}

implementation

end.
