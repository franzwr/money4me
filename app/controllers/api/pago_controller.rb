class API::PagoController < ApplicationController
	respond_to :json

	def pago_params
		params.require(:pago).permit(:cuenta_banco, :rut_cliente, :email, :detalle, :fecha_pago)
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
			render :json => @pago
		else
			render :json => {}, status: :internal_server_error
		end
	end

	def update
		@pago = Pago.find_by :id_pago => params[:id]
		if @pago.update(cuenta_banco: params[:pago][:cuenta_banco], rut_cliente: params[:pago][:rut_cliente],
			email: params[:pago][:email], detalle: params[:pago][:detalle], fecha_pago: params[:pago][:fecha_pago])
			render :json => @pago
		else
			render :json => {}, status: :internal_server_error
		end
	end

	def destroy
		@pago = Pago.find_by :id_pago => params[:id]
		if @pago.destroy
			render :json => {}
		else
			render :json => {}, status: :internal_server_error
		end
	end
end