module Another do
# inline doc "
  # Description of this module...
  # 
  # Accessible by Another.__Description
# ";
  class Banco do
    var Nome: String ;
    var Endereco: String ;
    
    def AtualizarContas
    do
    
    end
    
    def GetNome: String
    do
    
    end
    
    def GetEndereco: String
    do
    
    end
  end

  class GerenciadorDeContas do
    def Adicionar
    do
    
    end
    
    def Remover
    do
    
    end
    
    def AtualizarContas
    do
    
    end
  end

  class GerenciadorDeTransacoes do
    var VetorDeTransacoesEmExecucao: Transacao[];
    var VetorDeTransacoesEsperando: Transacao[];
    
    def EfetuarTransacao
    do
    
    end
    
    def GetEstatisticas
    do
    
    end
    
    def GetStatus
    do
    
    end
  end

  class Transacao do
    def ProcessarTransacao(Valor: Float)
    do
    
    end
    
    def GetValor
    do
    
    end
  end

  class Calendario do
    var DiasUteis: Date[];
    
    def EhDiaUtil?: Boolean
    do
    
    end
  end

  class GerenciadorDeClientes do
    def Adicionar
    do
    
    end
    
    def Remover
    do
    
    end
  end

  class Cliente do
    var Nome: String;
    var Endereco: String;
    
    def Sacar(DaConta: Conta)
    do
    
    end
    
    def Transferir(ParaConta: Conta)
    do
    
    end
    
    def GetNome: String
    do
    
    end
    
    def SetNome(Value: String)
    do
    
    end
    
    def GetEndereco: String
    do
    
    end
    
    def SetEndereco(Value: String)
    do
    
    end
  end

 class Conta do
    var Saldo: Float;
     def Atualizar;
  end
  
  class Poupanca > Conta do
  
  end
  
  class ContaCorrente > Conta do
  
  end

end