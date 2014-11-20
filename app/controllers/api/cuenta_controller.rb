# = cuenta_controller.rb
#
# Controller class for all Bills (Cuentas) related actions.
class API::CuentaController < ApplicationController

	# Only Companies (empresas) can create and destroy bills (cuentas)
  	before_action :authenticate_company_user!, only: [:create, :destroy]

  	# Responds to and with JSON.
	respond_to :json

	# Permited params to bill creation.
	def cuenta_params
		params.require(:cuenta).permit(:id_empresa, :id_propio_empresa, :monto, :fecha_registro, :fecha_limite,
			:rut_cliente)
	end

	# Main action. Shows all bills, with all meaningfull relationships. If a folio is provided, 
	# acts as the show action with the folio number as filter.
	def index
    	if params[:id_propio_empresa]
			@cuenta = Cuenta.find_by :id_propio_empresa => params[:id_propio_empresa]
		else
			@cuenta = Cuenta.all
		end
		if @cuenta
			render :json => @cuenta, :include => [:empresa, :pago]
		else
			render :json => {}, status: :not_found
		end
	end

	# Returns a JSON object with the requested bill. REST action, works only
	# with bill IDs. For other filters, use the index action.
	def show
		@cuenta = Cuenta.find_by :id_cuenta => params[:id]
		if @cuenta
			render :json => @cuenta, :include => [:empresa, :pago]
		else
			render :json => {}, status: :not_found
		end
	end

	# Creates a bill.
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
	end

	# Destroys a bill. This actions can't be performed if the bill has a payment associated.
	def destroy
		@cuenta = Cuenta.find_by(id_cuenta:  params[:id],
                             id_empresa: current_empresa.id)
    if @cuenta.pago.nil? && @cuenta.destroy
			render :json => {}
		else
			render :json => {}, status: :internal_server_error
		end
	end
end
