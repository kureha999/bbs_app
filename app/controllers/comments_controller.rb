class CommentsController < ApplicationController
  before_action :require_login, only: [:create, :destroy]  # destroyにもログインチェックを追加
  before_action :set_comment, only: [:destroy]  # コメントを取得するためのメソッド

  # コメント作成
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @post, notice: "コメントが投稿されました。"
    else
      redirect_to @post, alert: "コメントの投稿に失敗しました。"
    end
  end

  # コメント削除
  def destroy
    @comment.destroy
    redirect_to @comment.post, notice: "コメントが削除されました。"
  end

  private

  # コメントを特定するためのメソッド
  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end

