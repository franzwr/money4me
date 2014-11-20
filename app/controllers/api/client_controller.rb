class API::ClientController < ApplicationController
  before_action :authenticate_client!
  respond_to :json, :html
  skip_before_action :verify_authenticity_token

  def recover
    current_client.send_reset_password_instructions
    render json: {}
  end
end

