class Model < ActiveRecord::Base 
  
  attr_accessible :name, :age, :slug
  
  slug :name
  
end