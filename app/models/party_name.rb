class PartyName < ActiveRecord::Base
  belongs_to :party

  def self.search( search )
    if search
#      find(:all, :conditions => ['rest_of_name LIKE ?', "%#{search}%"])
       where('surname LIKE ? OR rest_of_name LIKE ?', "%#{search}%", "%#{search}%")
    else
#      find(:all)
       scoped
    end
  end

end
