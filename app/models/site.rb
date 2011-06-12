class Site < ActiveRecord::Base
  has_many :phone_numbers, :as=>:callable, :dependent => :destroy
  has_many :addresses, :as=>:addressable, :dependent => :destroy
  has_many :site_associations, :dependent => :destroy
  has_many :parties, :through=>:site_associations

  accepts_nested_attributes_for :phone_numbers, :allow_destroy => true, :reject_if => :all_blank
  accepts_nested_attributes_for :addresses, :allow_destroy => true, :reject_if => :all_blank
end
