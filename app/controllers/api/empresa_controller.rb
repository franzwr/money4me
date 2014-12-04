# = empresa_controller.rb
#
# Defines all Company related API tasks.
class API::EmpresaController < ApplicationController
  before_action :authenticate_admin!, only: [:destroy]
  before_action :authenticate_company_user!, only: [:update]

	respond_to :json

	# Required and permitted HTTP params.
	def empresa_params
		params.require(:empresa).permit(:nombre, :cuenta_banco, :rut_empresa, :activa)
	end

	# Returns a JSON hash with all companies.
	def index
		respond_with Empresa.all
	end

	# Returns a JSON hash with the specified company.
	def show
		@empresa = Empresa.find_by :id_empresa => params[:id]
		if @empresa
			render :json => {empresa: @empresa}
		else
			render :json => {}, status: :not_found
		end
	end

  # Creates a company and returns a JSON object with the new company.
	def create
    	@company = Empresa.new(empresa_params)
    	if @company.save
    		render :json => @company, status: :ok
    	else
    		render :json => {:errors => @company.errors}, status: :unprocessable_entity
    	end
	end

	# Updates a company and returns a JSON object with the updated company.
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

	# Eliminates a company and returns an empty JSON object.
	def destroy
		@empresa = Empresa.find_by :id_empresa => params[:id]
		if @empresa.destroy
			render :json => {}, :status => :ok
		else
			render :json => {}, status: :internal_server_error
		end
	end
end
