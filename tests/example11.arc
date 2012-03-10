module Fibonacci do

  def fib(num: Integer): Integer
  do
    if 0 == num then
      Result = 0;
    elif 1 == num then
      Result = 1;
    else
      Result = fib(num - 1) + fib(num - 2);
    end
  end

end

# Fibonacci até 50...
WriteLn(fib(50));
