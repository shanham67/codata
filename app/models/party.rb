class Party < ActiveRecord::Base

has_many :names, :class_name => "PartyName", :dependent => :destroy
has_many :phone_numbers, :as => :callable, :dependent => :destroy
has_many :email_addresses, :as => :emailable, :dependent => :destroy
has_many :addresses, :as => :addressable, :dependent => :destroy
has_many :private_id_definitions
has_many :relationships
has_many :external_identifiers #these are how this party is identified by another party (e.g. SSN, customer_id)
has_many :site_associations, :dependent => :destroy
has_many :sites, :through=>:site_associations, :dependent => :destroy
has_many :associations
has_many :associates, :through=>:associations
has_many :comments, :as => :commentable

accepts_nested_attributes_for :names, :allow_destroy => true, :reject_if => :all_blank
accepts_nested_attributes_for :phone_numbers, :allow_destroy => true, :reject_if => :all_blank
accepts_nested_attributes_for :email_addresses, :allow_destroy => true, :reject_if => :all_blank
accepts_nested_attributes_for :addresses, :allow_destroy => true, :reject_if => :all_blank
accepts_nested_attributes_for :comments, :allow_destroy => true, :reject_if => :all_blank
accepts_nested_attributes_for :sites, :allow_destroy => true, :reject_if => :all_blank

before_create :set_dates_to_nil

def employees
  eid = Role.find_by_name("Employer").id
  self.relationships.find_all_by_role_id(eid).collect{ |r| r.counterpart.party }
end

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
