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
		@empresa = Empresa.find_by :id_empresa => params[:id]
		@empresa.update(nombre: params[:empresa][:nombre], cuenta_banco: params[:empresa][:cuenta_banco],
			rut_empresa: params[:empresa][:rut_empresa], activa: params[:empresa][:activa])
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
end