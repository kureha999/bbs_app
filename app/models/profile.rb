class Profile < ApplicationRecord
  belongs_to :user

  has_one_attached :avatar  # ActiveStorageを使用して画像をアップロードする
  delegate :first_name, :last_name, to: :user  # Userモデルのfirst_nameとlast_nameを参照できるようにする
end
