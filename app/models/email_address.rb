class EmailAddress < ActiveRecord::Base
  belongs_to :emailable, :polymorphic=>true
end
