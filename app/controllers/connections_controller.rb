class ConnectionsController < ApplicationController
  before_action :authenticate_user!

  def index 
    @requested_connections = Connection.includes(:requested).where(user_id: current_user.id)
    @received_connections = Connection.includes(:received).where(connected_user_id: current_user.id)
  end

  def create
    @connection = current_user.connections.new(connection_params)
    @connector = User.find(connection_params[:connected_user_id])

    respond_to do |format|
      if @connection.save
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('user-connection-status', partial: 'connections/create',
                                                                              locals: { connector: @connector })
        end
      end
    end
  end

  def update 
    @connection = Connection.find(params[:id])
    respond_to do |format|
      ActiveRecord::Base.transaction do 
        if @connection.update(status: params[:connection][:status]) 
          if @connection.status == 'accepted' 
            receiver = @connection.received
            requester = @connection.requested
            receiver.connected_user_ids << requester.id
            requester.connected_user_ids << receiver.id
            receiver.save 
            requester.save
          end
        end
      end
      format.turbo_stream { render turbo_stream: turbo_stream.replace("connection-status-#{@connection.id}", partial: "connections/update", locals: { connection: @connection }) }
    end
  end

  private

  def connection_params
    params.require(:connection).permit(:connected_user_id, :status, :user_id)
  end
end
