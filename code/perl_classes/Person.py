#!/usr/bin/python3

class Person:
  """
  
  This is python class Person. A Person can be described with a number of
  characteristics including: height, weight, age and gender.
  There are many other characterisitcs that can describe a person, but these
  are fundamentals. 
  
  """

  def __init__(self):
    self.age = 20
    self.gender     = "Male"
    self.height     = 160         # in inches
    self.weight     = 180         # in lbs

  def get_gender(self):
    return self.gender

  def set_gender(self, gender):
    self.gender = gender
    return self.gender

  def get_height(self):
    return self.height

  def set_height(self, height):
    self.height = height
    return self.height

  def get_weight(self):
    return self.weight

  def set_weight(self, weight):
    self.weight = weight
    return self.weight

  def get_age(self):
    return self.age

  def set_age(self, age):
    self.age = age
    return self.age


adam = Person();

print(adam.get_age())
print(adam.set_age(25))
print(adam.get_height())
print(adam.set_height(165))
print(adam.get_weight())
print(adam.set_weight(155))
print(adam.get_gender())
print(adam.set_gender("Female"))
