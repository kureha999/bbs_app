class PostsController < ApplicationController
  before_action :require_login, only: [ :new, :create, :edit, :update, :destroy ]
  before_action :set_post, only: [ :show, :edit, :update, :destroy ]
  # 投稿一覧
  def index
    @profile = current_user.profile
    @posts = Post.all
  end
  # 投稿詳細
  def show
  end
  # 新しい投稿
  def new
    @post = Post.new
  end
  # 投稿作成
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, notice: "投稿が作成されました。"
    else
      render :new
    end
  end
  # 投稿編集
  def edit
  end
  # 投稿更新
  def update
    if @post.update(post_params)
      redirect_to @post, notice: "投稿が更新されました。"
    else
      render :edit
    end
  end
  # 投稿削除
  def destroy
    @post.destroy
    redirect_to posts_path, notice: "投稿が削除されました。"
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end
end
