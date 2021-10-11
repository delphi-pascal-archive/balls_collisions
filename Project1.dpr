program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  UVect in 'UVect.pas',
  Uintro in 'Uintro.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
