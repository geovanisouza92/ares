module Garage do

import System.IO;

  class Base do
    def Base # Construtor
    do
      # Gerar código automático
    end
    var ID: Integer; # invariants not nil and > 0
  end

  class RentalAgency > Base do
    var Address: String;
    var PhoneNo: String;
    var Manager: Pessoa;
  end
  
  class Person > Base do
    var Name: String; # invariants not nil
    var Address: String;
  end
  
  class CustomerRecord do
    var CustomerID: Integer ;
    var RentalHistory: Strings ;
  private
    def Initialize
    do
      # Inicializa Histórico
    end
  end
  
  class Customer > Base, Person do
    def Reserve
    do
    
    end
    
    def PicksUp
    do
    
    end
    
    def Pays
    do
    
    end
    
    def Returns
    do
    
    end

    var Phone: String ;
    var BirthDate: Date ;
    var LicenseNo: String ; # like \[0-9]+\ # Validado com regex
  end
  
  class Car > Base do
    var FleetNo: Integer ;
    var Model: String ;
    var RegNo: String ;
    var Condition: String ;
    var Status: String ;
    
    def Reserved?: Boolean
    do
    
    end
    
    def InService?: Boolean
    do
    
    end
  end
  
  class Employee > Person do
    var PhoneNo: String ;
    var DateHired: Date ;
  end
  
  class RentalAgent > Employee do
    var CommissionRate: Float ;
    var Tar;
    
    def Calculate
    do
    
    end
  end
  
  class Mechanic > Employee do
    var Skills: Strings ;
    var Qualifications: String ;
  private
    def Initialize
    do
      # Initialize Skills & Qualifications
    end
  end
  
  class ServiceLog > Base do
    var ServiceHistory: String ;
    var ProgressHistory: Strings ;
  private
    def Initialize
    do
      # Initialize ProgressHistory
    end
  end
  
end
