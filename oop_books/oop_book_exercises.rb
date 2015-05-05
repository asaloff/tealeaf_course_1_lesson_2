# # The Object Model
# 1. create an object

# class Candy
# end

# candy_corn = Candy.new

# 2. A module is like a method that you can use in multiple classes
# You can write it once and not have to repeat it in every class like so:

# module EatMe
# end

# class Candy
#   include EatMe
# end

# candy_corn = Candy.new




# Classes and Objects + Inheritance

class Vehicle
  attr_accessor :color, :current_speed, :year, :model

  @@number_of_vehicles = 0

  def self.number_of_vehicles
    puts "Vehicle superclass currently has #{@@number_of_vehicles} vehicles"
  end

  def initialize(year, color, model)
    self.year = year
    self.color = color
    self.model = model
    @current_speed = 0
    @@number_of_vehicles += 1
  end

  def to_s
    "A #{self.color} #{self.year} #{self.model}"
  end

  def self.calculate_gas_mileage(gallons, miles, type_of_vehicle)
    puts "#{type_of_vehicle} gets #{miles / gallons} miles per gallon"
  end

  def speed_up(number)
    @current_speed += number
    puts "You push the gas and speed up to #{number} MPH!"
  end

  def brake(number)
    @current_speed -= number
    puts "You step on the brake and decelerate to #{number} MPH"
  end

  def shut_engine
    @current_speed = 0
    puts "Ready for the garage"
  end

  def spray_paint(color)
    self.color = color
  end

  def age
    puts "Your #{self.model} is #{calculate_age} years old"
  end

  private
  
  def calculate_age
    Time.now.year - self.year.to_i
  end
end

module Towable
  def can_tow?(pounds)
    pounds < 2000 ? true : false
  end
end

module Multi_Passenger
  def number_of_passengers
    puts "This car can fit 5 passengers"
  end
end

class MyCar < Vehicle
  include Multi_Passenger

  NUMBER_OF_DOORS = 4
end

class MyTruck < Vehicle
  include Towable

  NUMBER_OF_DOORS = 2
end

golf = MyCar.new('2011', 'White', 'Volkswagon')
suburban = MyTruck.new('2005', 'Gold', 'Chevy')


class Student
  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def better_grade_than?(student)
    grade > student.grade ? true : false
  end

  protected

  def grade
    @grade
  end
end
aaron = Student.new('Aaron', 100)
guy = Student.new('Guy', 64)

puts "Aaron Rocks!" if aaron.better_grade_than?(guy)






















