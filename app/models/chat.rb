class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :room
# 　チャットの文字数140字まで
  validates :message, presence: true, length: { maximum:140 }
end
