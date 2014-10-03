class API::EmpresaController < ApplicationController
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
    if !admin_signed_in and !params[:empresa][:activa].nil?
			render :json => {}, :status => :internal_server_error
    else
      @empresa = Empresa.find_by :id_empresa => params[:id]
      @empresa.update({
        nombre:        params[:empresa][:nombre],
        cuenta_banco:  params[:empresa][:cuenta_banco],
        rut_empresa:   params[:empresa][:rut_empresa],
        activa:        params[:empresa][:activa],
        rubros:        JSON.parse(params[:empresa][:rubro_ids]),
      }.reject {|k,v| v.nil?} )
      render :json => @empresa
    end
	end

	def destroy
		@empresa = Empresa.find_by :id_empresa => params[:id]
		if @empresa.destroy
			render :json => {}, :status => :ok
		else
			render :json => {}, status: :internal_server_error
		end
	end

end
