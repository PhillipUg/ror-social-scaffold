class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: :User

  validates :user_id, uniqueness: {scope: :friend_id}

  def self.add_friend(user_id, friend_id, state)
  	user_friendship = self.create(user_id: user_id, friend_id: friend_id, state: state)
  	friend_friendship = self.create(user_id: friend_id, friend_id: user_id, state: state)
  	[user_friendship, friend_friendship]
  end
end
