unit Uintro;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin;

type
  TForm2 = class(TForm)
    CheckBox1: TCheckBox;
    Button1: TButton;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    SpinEdit1: TSpinEdit;
    Label3: TLabel;
    SpinEdit2: TSpinEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form2: TForm2;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
 nballes:=spinedit1.value;
 rebond:=CheckBox1.Checked;
 typeattra:=ComboBox1.ItemIndex;
 perte:=spinedit2.value/100;
 form1.Show;
 form1.timer1.enabled:=true;
 form2.Hide;
end;

end.
