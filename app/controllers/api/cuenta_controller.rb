class API::CuentaController < ApplicationController
  before_action :authenticate_empresa!, only: [:create, :destroy]

	respond_to :json

	def cuenta_params
		params.require(:cuenta).permit(:id_empresa, :id_propio_empresa, :monto, :fecha_registro, :fecha_limite,
			:rut_cliente)
	end

	def index
    	if params[:id_propio_empresa]
			@cuenta = Cuenta.find_by :id_propio_empresa => params[:id_propio_empresa]
		else
			@cuenta = Cuenta.all
		end
		if @cuenta
			render :json => @cuenta
		else
			render :json => {}, status: :not_found
		end
	end

	def show
		@cuenta = Cuenta.find_by :id_cuenta => params[:id]
		if @cuenta
			render :json => @cuenta
		else
			render :json => {}, status: :not_found
		end
	end

	def create
		@cuenta = Cuenta.new(cuenta_params)
    	@cuenta.id_empresa = current_empresa.id
    	@cuenta.fecha_registro = Date.today
		if @cuenta.save
			render :json => @cuenta
		else
			render :json => {}, status: :internal_server_error
		end
	end

	def update
    # Not necessary
    render :json => {}, status: :internal_server_error

		# @cuenta = Cuenta.find_by :id_cuenta => params[:id]
		# if @cuenta.update(
    #     id_propio_empresa: params[:cuenta][:id_propio_empresa],
    #     monto:             params[:cuenta][:monto],
    #     fecha_registro:    params[:cuenta][:fecha_registro],
    #     fecha_limite:      params[:cuenta][:fecha_limite],
    #     rut_cliente:       params[:cuenta][:rut_cliente])
		# 	render :json => @cuenta
		# else
		# 	render :json => {}, status: :internal_server_error
		# end
	end

	def destroy
		@cuenta = Cuenta.find_by(id_cuenta:  params[:id],
                             id_empresa: current_empresa.id)

		if @cuenta.destroy
			render :json => {}
		else
			render :json => {}, status: :internal_server_error
		end
	end
end
