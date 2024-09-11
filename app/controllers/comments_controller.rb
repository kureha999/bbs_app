class CommentsController < ApplicationController
  before_action :require_login, only: [ :create ]
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

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
