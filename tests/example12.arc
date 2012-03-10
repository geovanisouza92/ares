module Fatorial do

  def fat(num: Integer): Integer
  do
    if 0 == num then
      Result = 1;
    else
      Result = num * fat(num - 1);
    end
  end

end

# Fatorial de 6 = 720
assert(720 == fat(6));
