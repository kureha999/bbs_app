Rails.application.routes.draw do
  root "tops#index"  # トップページをログインしていないユーザー向けに表示

  # ログインしていないユーザー向けのトップページ
  get "tops", to: "tops#index"

  # 投稿とコメントのリソース
  resources :posts do
    resources :comments, only: %i[create destroy ]
  end

  # ユーザー関連のルーティング
  resources :users, only: %i[new create]

  # プロフィール関連のルーティング
  resources :profile, only: %i[edit update]

  # ログイン関連のルーティング
  get "login", to: "user_sessions#new"
  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy"
end
