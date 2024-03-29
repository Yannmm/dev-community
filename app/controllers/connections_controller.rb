class ConnectionsController < ApplicationController
  
  def index 
    @requested_connections = Connection.includes(:requested).where(user_id: current_user.id)
    @received_connections = Connection.includes(:received).where(connected_user_id: current_user.id)
  end

  def create
    @connection = current_user.connections.new(connection_params)
    @connector = User.find(connection_params[:connected_user_id])

    if @connection.save
      render_turbo_stream(:replace, 'user-connection-status', 'connections/create',
      locals: { connector: @connector })
    end
  end

  def update 
    @connection = Connection.find(params[:id])
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
    render_turbo_stream(:replace, "connection-status-#{@connection.id}", "connections/update", locals: { connection: @connection })
  end

  private

  def connection_params
    params.require(:connection).permit(:connected_user_id, :status, :user_id)
  end
end
