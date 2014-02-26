class User < ActiveRecord::Base
	has_one :profile, dependent: :destroy
	has_many :tweets, dependent: :destroy
end

class Profile < ActiveRecord::Base
	belongs_to :user
end

class Tweet < ActiveRecord::Base
	belongs_to :user
	validates :content, length: { maximum: 140 }
end