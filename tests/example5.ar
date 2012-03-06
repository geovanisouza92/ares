module XNA do

   class Entidade do
    var X: Float ;
    var Y: Float ;
  end

   class Nave > Entidade do
    var Estado: EstadoNave ;
    var Velocidade: Float ;
    var Direcao: DirecaoNave ;
  end
  
  class Escudo > Entidade do
    var X: Float ;
    var Y: Float ;
  end
  
  class JogoInvasores do
    var Estado: EstadoJogo ;
  end
  
  class CelulaEscudo do
    var Energia: Integer ;
    var Tipo: TipoDeCelula ;
  end
  
  class Tiro do
    var X: Float ;
    var Y: Float ;
    var Velocidade: Float ;
  end
  
  class NaveInvasor > Nave do
  
  end
  
  class NaveBonus > Nave do
    var Contador: Integer ;
  end
  
  class NaveJogador > Nave do
    var Vidas: Integer ;
    var Pontos: Integer ;
    var PodeAtirar?: Boolean ;
  end
  
  class ControladorDeNaves do
    var InverterDirecao?: Boolean ;
    var QuantidadeDeNaves: Integer ;
    var TempoParaAtirar: Float ;
  end
  
  # enum EstadoNave
  #   # Estados da nave
  # end
  
  # enum DirecaoNave
  #   # Direções da nave
  # end
  
  # enum EstadoJogo
  #   # Estados do jogo
  # end
  
  # enum TipoDeCelula
  #   # Tipos de células
  # end
  
end
