class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    @q = User.ransack(params[:q])
    @users = @q.result.limit(16).order(:created_at)
  end
end
