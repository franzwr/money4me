class API::PagoController < ApplicationController
	respond_to :json

	def pago_params
		params.require(:pago).permit(:id_cuenta_banco, :rut_cliente, :email, :detalle, :fecha_pago)
	end

	def index
		respond_with Pago.all
	end

	def show
		@pago = Pago.find_by :id_pago => params[:id]
		if @pago
			render :json => @pago
		else
			render :json => {}, status: :not_found
		end
	end

	def create
		@pago = Pago.new(pago_params)
    if @pago.save
      render :json => @pago, status: :ok
    else
      render :json => {}, status: :internal_server_error
    end
	end

	def update
    # Shouldn't be possible.
		render :json => {}, status: :internal_server_error
	end

	def destroy
    # Should'nt be possible.
		render :json => {}, status: :internal_server_error
	end
end
