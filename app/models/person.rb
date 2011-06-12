class Person < Party 

  def birth_date
    self.begin_date
  end

  def birth_date=(val)
    self.begin_date = val
  end
  
  def death_date
    self.end_date
  end

  def death_date=(val)
    self.end_date = val
  end 

  def display_name
    if self.primary_name.nil?
      "No name associated"
    else
      "Person::" + self.primary_name.rest_of_name.to_s + " " + self.primary_name.surname.to_s
    end
  end
end
