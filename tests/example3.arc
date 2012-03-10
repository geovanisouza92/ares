# inline doc "Esta é a descrição ou texto de ajuda para este objeto. Todos os objetos
# podem ter este informativo embutido";
module Clientes do

  class Base do
    var _id: Integer ;
  end

  # interface IPessoa
  #   def TemBoaReputacao? : Boolean;
  # end

  class Pessoa > Base, IPessoa do
    def TemBoaReputacao? : Boolean do
        # Retorna verdadeiro somente se a pessoa for de boa fé...
        Result = ! Nome.IsEmpty?;
    end
    var Nome: String ;
  end

  class PessoaFisica > Pessoa do
    var CPF: String ;
  end

  class PessoaJuridica
      > Pessoa do
    var CNPJ: String ;
  end

# inline doc "Lista todos os clientes ativos no sistema";
  def ListarTodosOsClientes: Pessoa[]
  do
    Result = (from Cliente in DBO.Clientes
               where Cliente.TemBoaReputacao?);
  end

end