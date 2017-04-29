require 'minitest/autorun' # loads all the files from the minitest gem
require "minitest/reporters"
Minitest::Reporters.use!

require_relative 'car' # specifies file from current file's directory to be tested


# -------------------------------------------------

# Assertion style syntax

class CarTest < MiniTest::Test # inherits from minitest
  def test_wheels # instnace method that startes with test_ tells minitest it's a test
    car = Car.new # need an object to test
    assert_equal(4, car.wheels) # test to see if the object has 4 wheels
  end

  def test_bad_wheels
    skip("bad wheels") # skip keyword to skip this test, reports as S
    car = Car.new
    assert_equal(3, car.wheels)
  end
end

# ------------------------------------------------------

# assert_equal(expected_value, actual_value) (inherited instance method from minitest)
#  - ()

# ------------------------------------------------------

