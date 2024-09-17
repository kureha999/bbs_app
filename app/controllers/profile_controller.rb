class ProfilesController < ApplicationController
  before_action :set_profile, only: [:edit, :update]

  # プロフィール編集画面
  def edit
  end

  # プロフィール更新処理
  def update
    if @profile.update(profile_params)
      redirect_to edit_profile_path(@profile), notice: "プロフィールが更新されました。"
    else
      render :edit
    end
  end

  private

  def set_profile
    @profile = current_user.profile  # ログインユーザーのプロフィールを取得
  end

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :avatar)  # 名前と画像を許可
  end
end
