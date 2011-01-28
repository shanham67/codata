class Party < ActiveRecord::Base

has_many :names, :class_name => "PartyName", :dependent => :destroy
has_many :phone_numbers, :as => :callable
has_many :email_addresses, :as => :emailable
has_many :private_id_definitions
has_many :first_party_roles, :class_name => "PartyRelationship", :foreign_key => :first_party_id
has_many :second_party_roles, :class_name => "PartyRelationship", :foreign_key => :second_party_id

accepts_nested_attributes_for :names, :allow_destroy => true, :reject_if => :all_blank
accepts_nested_attributes_for :phone_numbers, :allow_destroy => true, :reject_if => :all_blank
accepts_nested_attributes_for :email_addresses, :allow_destroy => true, :reject_if => :all_blank

before_create :set_dates_to_nil

def primary_name
  self.names.first
end

def display_name
  if self.primary_name.nil?
    "No names associated"
  else
    "Party::" + self.primary_name.surname + " " + self.primary_name.rest_of_name
  end
end

def set_dates_to_nil
  self.begin_date = nil
  self.end_date = nil
  self.superceded_date = nil
end

# from
# http://code.alexreisner.com/articles/single-table-inheritance-in-rails.html
#
# without this the update didn't work correctly
# even if the childs resources were routed to :parties in routes.rb
#
def self.inherited(child)
  child.instance_eval do
    def model_name
      Party.model_name
    end
  end
  super
end


end
