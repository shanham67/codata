class Organization < Party
  def display_name
    if self.primary_name.nil?
      "No Name associated"
    else
      "Org::"+self.primary_name.surname
    end 
  end

end
