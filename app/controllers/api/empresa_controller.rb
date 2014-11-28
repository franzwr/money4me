class API::EmpresaController < ApplicationController
  before_action :authenticate_admin!, only: [:update, :destroy]
  before_action :authenticate_empresa!, only: [:clientes_morosos, :clientes_con_cuentas_acumuladas, :clientes_preventivos]

	respond_to :html, :json

	def empresa_params
		params.permit(:empresa => [:nombre, :cuenta_banco, :rut_empresa, :activa], :company_user => [:email, :rut, :password, :password_confirmation])
	end

	def index
		respond_with Empresa.all
	end

	def show
		@empresa = Empresa.find_by :id_empresa => params[:id]
		if @empresa
			render :json => {empresa: @empresa}
		else
			render :json => {}, status: :not_found
		end
	end

  # TODO Devise
	def create
    p empresa_params
    p empresa_params[:empresa]
		@empresa = Empresa.new(empresa_params[:empresa])
		@empresa.activa = false
		if @empresa.save
      @company_user = CompanyUser.new(empresa_params[:company_user])
      @company_user.id_empresa = @empresa.id_empresa

      # ignore password params
      @company_user.password = Devise.friendly_token

      if @company_user.save
        redirect_to :back, notice: "Formulario enviado con éxito." 

        # respond_to do |format|
        #   format.html { redirect_to :back, notice: "Formulario enviado con éxito." }
        #   format.json { render :json => {empresa: @empresa, company_user: @company_user} }
        # end
      else
        respond_to do |format|
          format.html { redirect_to :back, alert: "Ha ocurrido un error." }
          format.json { render :json => {}, :status => :internal_server_error }
        end
      end
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
