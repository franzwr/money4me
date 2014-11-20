class API::ClientController < ApplicationController
  before_action :authenticate_client!
  respond_to :json, :html
  skip_before_action :verify_authenticity_token

  def recover
    current_client.send_reset_password_instructions
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { redirect_to :back }
    end
  end
end

