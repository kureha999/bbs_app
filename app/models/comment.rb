class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  # 自分の投稿にコメントできないようにするバリデーション
  validate :author_my_not
  # コメントは、空では、投稿できないようにする
  validates :content, presence: true
  private

  def author_my_not
    if post.user_id == user_id
      errors.add(:user_id, "自分の投稿にはコメントできません")
    end
  end
end
