class API::EmpresaController < ApplicationController
  before_action :authenticate_admin!, only: [:update, :destroy]
  before_action :authenticate_empresa!, only: [:clientes_morosos, :clientes_con_cuentas_acumuladas, :clientes_preventivos]

	respond_to :json

	def empresa_params
		params.require(:empresa).permit(:nombre, :cuenta_banco, :rut_empresa, :activa)
	end

	def index
		respond_with Empresa.all
	end

	def show
		@empresa = Empresa.find_by :id_empresa => params[:id]
		if @empresa
			render :json => @empresa
		else
			render :json => {}, status: :not_found
		end
	end

  # TODO Devise
	def create
		@empresa = Empresa.new(empresa_params)
		@empresa.activa = false
		if @empresa.save
			render :json => @empresa
		else
			render :json => {}, :status => :internal_server_error
		end
	end

	def update
    @empresa = Empresa.find_by :id_empresa => params[:id]
    @empresa.update({
      nombre:        params[:empresa][:nombre],
      cuenta_banco:  params[:empresa][:cuenta_banco],
      rut_empresa:   params[:empresa][:rut_empresa],
      activa:        params[:empresa][:activa],
      rubro_ids:     JSON.parse(params[:empresa][:rubro_ids]),
    }.reject {|k,v| v.nil?} )
    render :json => @empresa
	end

	def destroy
		@empresa = Empresa.find_by :id_empresa => params[:id]
		if @empresa.destroy
			render :json => {}, :status => :ok
		else
			render :json => {}, status: :internal_server_error
		end
	end

  # ---
  def clientes_morosos
    rut_impagos = current_empresa.cuentas.impagas.select(:rut_cliente)

    render json: {
      rut_clientes_impagos: rut_impagos,
      clientes_impagos:     Usuario.where(rut_cliente: rut_impagos),
    }
  end

  def clientes_con_cuentas_acumuladas
    rut_acumulados = current_empresa.cuentas.pagadas.joins(:pagos).where("pagos.fecha_pago > cuentas.fecha_limite").select(:rut_cliente)

    render json: {
      rut_clientes_acumulados: rut_acumulados,
      clientes_acumulados:     Usuario.where(rut_cliente: rut_acumulados),
    }
  end

  def clientes_preventivos
    rut_preventivos = current_empresa.cuentas.pagadas.joins(:pagos).where("pagos.fecha_pago < cuentas.fecha_limite").select(:rut_cliente)

    render json: {
      rut_clientes_preventivos: rut_preventivos,
      clientes_preventivos:     Usuario.where(rut_cliente: rut_preventivos),
    }
  end
end
