# = pago_controller.rb
#
# Defines al Pago related API tasks.
class API::PagoController < ApplicationController
	respond_to :json

	def pago_params
		params.require(:pago).permit(:id_cuenta_banco, :rut_cliente, :email, :detalle, :fecha_pago)
	end

	# Returns all Pagos.
	def index
		respond_with Pago.all
	end

	# Recieves a GET :id param, and returns a Pago if found.
	def show
		@pago = Pago.find_by :id_pago => params[:id]
		if @pago
			render :json => @pago
		else
			render :json => {}, status: :not_found
		end
	end

	# Creates a new Pago and returns it.
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
		render :json => {}, status: :method_not_allowed
	end

	def destroy
    # Should'nt be possible.
		render :json => {}, status: :method_not_allowed
	end
end
