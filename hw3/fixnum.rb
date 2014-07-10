require 'benchmark'
=begin
В ruby мы имеем открытые классы. Это значит, что мы можем их расширять своими методами.

Задача: расширить класс Fixnum методом factorial, который будет возвращать факториал
заданного числа.

Примеры:
3.factorial #=> 6
0.factorial #=> 1
-5.factorial #=> nil
=end

class Fixnum
  #TODO создать метод factorial для подсчета факториала заданного числа. 
  #внутри метода заданное число будет доступно в self
  def factorial
  #brute force
    result = 1
    case
    when self < 0
      return nil
    when self == 0
      return 1
    when self > 1  
      (1..self).each {|i| result *= i}
      return result
    end
  end
  def factorial2
  #recursion
    result = 1
    return nil if self < 0
    self < 1 ? 1 : self * (self - 1).factorial
  end
end

#Check who is faster
Benchmark.bm do |x|
  x.report { 1_000.factorial }
  x.report { 1_000.factorial2 }
end