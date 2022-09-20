class Document < ApplicationRecord

  belongs_to :project
  belongs_to :user

  validates :project_id, presence: true
  validates :user_id, presence: true
  validates :title, presence: true, length: {minimum: 2, maximum: 32}
  validates :description, length: {maximum: 140}
  validates :url, presence: true, format: { with: /\A(http|https)/, message: "は「http」、または「https」から入力してください。" }

end
