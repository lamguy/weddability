class Page < ActiveRecord::Base
  belongs_to :account
  attr_accessible :content, :name, :title, :slug, :account
end
