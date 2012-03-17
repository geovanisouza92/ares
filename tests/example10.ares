module Sistema do

  class Endereco do
    var Tipo: Integer;
    var Endereco: String;
    var Bairro: String;
    var Cep: String;
    var Cidade: String;
    var Estado: String;
    
    def Endereco do
      # .ctor
    end
  end

  class Telefone do
    var Tipo: Integer;
    var CodigoDaCidade: Integer;
    var Numero: String; # Adicionar pattern
    
    def Telefone do
      # .ctor
    end
  end

  class Email do
    var Tipo: Integer;
    var Email: String; # Adicionar pattern
    
    def Email do
      # .ctor
    end
  end

   class Pessoa do
    var Nome: String; # invariants not nil
    
    def Pessoa do
      # .ctor
    end  
  end

  class PessoaFisica > Pessoa do
    var Sexo: Integer;
    var DataNascimento: Date;
    var CPF: String; # Adicionar pattern
    
    def PessoaFisica do
      # .ctor
    end
  end

  class PessoaJuridica > Pessoa do
    var CNPJ: String; # Adicionar pattern
    var NomeFantasia: String;
    
    def PessoaJuridica do
      # .ctor
    end
  end

  class Funcionario > PessoaFisica do
    var Matricula: Integer;
    var Cargo: String;
    var DataAdmissao: Date;
    
    def Funcionario do
      # .ctor
    end
  end

  class Cliente > PessoaFisica do
    var Tipo: Integer;
    
    def Cliente do
      # .ctor
    end
  end

  class Prato do
    var Nome: String;
    var Descricao: String;
    var Preco: Float;
    
    def Prato do
      # .ctor
    end
  end

  class ItemDoPedido do
    var Quantidade: Float;
    
    def ItemDoPedido do
      # .ctor
    end
  end

  class Pedido do
    var DataHora: DateTime;
    var FormaDePagamento: Integer;
    
    def Pedido do
      # .ctor
    end
  end

end
