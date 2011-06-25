class Address < ActiveRecord::Base
  belongs_to :addressable, :polymorphic=>true

  def merge( a )
    r = Address.new
    r = self
    r.country = self.country.nil? ? a.country : self.country
    r.state = self.state.nil? ? a.state : self.state
    r.city  = self.city.nil? ? a.city : self.city
    r.zip = self.zip.nil? ? a.zip : self.zip
    r.address1 = self.address1.nil? ? a.address1 : self.address1
    r.address2 = self.address2.nil? ? a.address2 : self.address2
    r
  end

  def compare( a )
    if self.country + a.country == a.country + self.country then
      if self.state + a.state == a.state + self.state then
        if self.city + a.city == a.city + self.city then
          if self.zip + a.zip == a.zip + self.zip then
            if self.address1 + a.address1 == a.address1 + self.address1
              if self.address2 + a.address2 == a.address2 + self.address2
                true
              else
puts "self.address2: " + self.address2 + ", a.address2: " + a.address2
                false
              end
            else
puts "self.address1: " + self.address1 + ", a.address1: " + a.address1
              false
            end
          else
puts "self.zip: " + self.zip + ", a.zip: " + a.zip
            false
          end 
        else
puts "self.city: " + self.city + ", a.city: " + a.city
          false
        end 
      else
puts "self.state: " + self.state + ", a.state: " + a.state
        false
      end
    else
puts "self.country: " + self.country + ", a.country: " + a.country
      false
    end
  end
end
