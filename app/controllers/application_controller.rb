class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :require_login

private

def require_login
  unless logged_in?
    redirect_to login_path, alert: "ログインしてください"
  end
end

def not_authenticated
  redirect_to login_path, alert: "ログインが必要です"
end
end
