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

end
