class MembersController < ApplicationController
  before_action :authenticate_user!, only: %i[edit_description update_description edit_details update_details]

  def show
    @user = User.find(params[:id])
    @connections = Connection.where("user_id = ? OR connected_user_id = ?", params[:id], params[:id]).where(status: 'accepted')
  end

  def edit_description; end

  def update_description
    respond_to do |format|
      if current_user.update(about: params[:user][:about])
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('member-description', partial: 'members/member_description', locals: { user: current_user })
        end
      end
    end
  end

  def edit_details; end

  def update_details
    respond_to do |format|
      if current_user.update(details_params)
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('member-details', partial: 'members/member_details',locals: { user: current_user })
        end
      end
    end
  end

  def connections 
    @requested_connections = Connection.includes(:requested).where(user_id: params[:id], status: 'accepted')
    @received_connections = Connection.includes(:received).where(connected_user_id: params[:id], status: 'accepted')

    @total_connections = @requested_connections.count + @received_connections.count
  end

  private

  def details_params
    params.require(:user).permit(:first_name, :last_name, :city, :state, :country, :pincode, :profile_title, :street_address)
  end
end
