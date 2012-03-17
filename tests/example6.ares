module Banco do

  class Cliente do
  private
    def SetCliente(Value: String)
    do
      if Value.Pattern(/[0-9]{3}\.{0-9]{3}\.[0-9]{3}\-[0-9]{2}/).Match? then
        FCPF = Value;
      else
        raise "CPF Inválido!";
      end
    end
  public
    var CPF: String ;
    var Nome: String ; # invariants not nil
    var Telefone: String ;
    def MostrarCPF: Integer
    do
      # Código
    end
    def VerSaldo(Conta: Integer)
    do
      # Código
    end
  end
  
   class Conta do
    var Agencia: Integer ;
    var NumeroConta: String ;
    def Depositar(Valor: Float)
    do
      # Código
    end
    def Saldo(Conta: Integer): Float
    do
      # Código
    end
  end
  
  class ContaPoupanca > Conta do
    var DiaDeposito: Integer ;
    def VerLucro: Float
    do
      # Código
    end
  end
  
end
