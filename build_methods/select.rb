require 'pry'

def select(array)
  counter = 0
  selected = []

  while counter < array.length
    if yield(array[counter])
      selected << array[counter]
    end
    counter += 1
  end

  selected
end

array = [1, 2, 3, 4, 5]
p select(array) { |num| num.odd? }      # => [1, 3, 5]
p select(array) { |num| puts num }      # => [], because "puts num" returns nil and evaluates to false
p select(array) { |num| num + 1 }       # => [1, 2, 3, 4, 5], because "num + 1" evaluates to true