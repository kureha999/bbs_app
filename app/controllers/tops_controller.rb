class TopsController < ApplicationController
  # ログインが不要なページに対して require_login をスキップ
  skip_before_action :require_login, only: [ :index ]

  def index
    # ログインしている場合は投稿一覧にリダイレクト
    if logged_in?
      redirect_to posts_path
    end
  end
end
