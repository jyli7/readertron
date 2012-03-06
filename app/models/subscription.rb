class Subscription < ActiveRecord::Base
  module OPML
    class Outline
      include HappyMapper
        tag 'outline'
        attribute :title, String
        attribute :text, String
        attribute :type, String
        attribute :xmlUrl, String
        attribute :htmlUrl, String
        has_many :outlines, Outline
    end
  end
  
  
end
