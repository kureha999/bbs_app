class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile  # プロフィールを同時に編集・作成できる

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :first_name, presence: true, length: { maximum: 10 }
  validates :last_name, presence: true, length: { maximum: 10 }
  validates :email, presence: true, uniqueness: true
end
