module Classes do

   class Persistente do
    # Atributos
    var ObjectId: Integer ;
    var Iter: RandomAccessFile ;

    # Métodos abstratos
     def AtualizarDados;
     def Gravar;
     def Ler;
    
    # Métodos
    def Persistente
    do
      # Constructor
    end
    
    def GetObjectId: Integer
    do
      # Do ;
    end
    
    def GetObject: Object
    do
      # Do something
    end
    
    def Armazenar
    do
      # Salvar em disco
    end
    
    def Apagar
    do
      # Apagar do disco
    end
    
    def StartObjectId: Integer
    do
      # Inicializa a propriedade "ObjectId"
    end
  end
  
  class Agencia > Persistente do
    # Atributos
    var CodAgencia: String ;
    var NomeAgencia: String ;
    
    # Métodos
    def Agencia
    do
      # .ctor
    end
    
    def AtualiarDados
    do
      # Implementação
    end
    
    def Gravar
    do
      # Implementação
    end
    
    def Ler
    do
      # Implementação
    end
  end
  
  class ContaCorrente > Persistente do
    var Cod: String;
    var Saldo: Integer;
    var AplicPrefix: ObjectId[];
    var Historico: ObjectId[];
    var Agencia: ObjectId;
    
    def Depositar(Quantia: Float)
    do
      
    end
    
    def Debitar(Quantia: Float)
    do
    
    end
    
    def Transferir(Quantia: Float, ParaConta: ContaCorrente)
    do
    
    end
    
    def ObterSaldo: Float
    do
    
    end
    
    def AplicarPrefix
    do
    
    end
    
    def ContaCorrente
    do
    
    end
    
    def TirarExtrato: Strings # = Array<String>
    do
    
    end
    
    def RetirarAplicPrefix
    do
    
    end
    
    def Localizar
    do
    
    end
    
    def Gravar
    do
    
    end
    
    def Ler
    do
    
    end
  end

  class Historico > Persistente do
    var Date: Date;
    var Operacao: ObjectId[];
    var Valor: Float;
    
    def Criar
    do
    
    end
    
    def Destruir
    do
    
    end
  end
  
  class Operacao > Persistente do
    var CodOperacao: String;
    var DescricaoOperacao: String;
    
    def Operacao
    do
    
    end
    
    def AtualizarDados
    do
    
    end
    
    def Gravar
    do
    
    end
    
    def Ler
    do
    
    end
  end
  
  class Dependente > Persistente do
    var Nome: String; # invariants not nil
    var CPF: String;
    var Parentesco: String;
    var Poupancas: ObjectId[];
    
    def Dependente
    do
    
    end
    
    def Localizar
    do
    
    end
    
    def AbrirPoupanca
    do
    
    end
    
    def FecharPoupanca
    do
    
    end
    
    def AtualizarDados
    do
    
    end
    
    def Gravar
    do
    
    end
    
    def Ler
    do
    
    end
  end
  
  class Poupanca > ContaCorrente do
    var DataVencimento: Date;
    
    def Poupanca
    do
    
    end
  end
  
  class AplicacaoPreFixada > Persistente do
    var Valor: Float;
    var DataVencimento: Date;
    var Taxa: Float;
    
    def AplicacaoPreFixada
    do
    
    end
    
    def Gravar
    do
    
    end
    
    def Ler
    do
    
    end
  end
  
  class Cliente > Persistente do
    var Nome: String; # invariants not nil
    var CPF: String;
    var Rua: String;
    var Fone: String;
    var Bairro: String;
    var Cidade: String;
    var CEP: String;
    var Estado: String;
    var Dependentes: ObjectId[];
    var ContasCorrente: ObjectId[];
    var Poupancas: ObjectId[];
    
    def Cliente
    do
    
    end
    
    def Gravar
    do
    
    end
    
    def Ler
    do
    
    end
    
    def Localizar
    do
    
    end
    
    def AbrirContaCorrente
    do
    
    end
    
    def RemoverContaCorrente
    do
    
    end
    
    def AdicDependente
    do
    
    end
    
    def ExcluirDependente
    do
    
    end
    
    def AbrirPoupanca
    do
    
    end
    
    def FecharPoupanca
    do
    
    end
    
    def AtualizarDados
    do
    
    end
  end
  
end