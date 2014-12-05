# = empresa_controller.rb
#
# Defines all Company related API tasks.
class API::EmpresaController < ApplicationController
  before_action :authenticate_admin!, only: [:destroy]

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
    	if params[:rubros]
    		@company.rubros << params[:rubros]
    	end
    	if @company.save
    		render :json => @company, status: :ok
    	else
    		render :json => {:errors => @company.errors}, status: :unprocessable_entity
    	end
	end

	# Updates a company and returns a JSON object with the updated company.
	def update
    	@empresa = Empresa.find_by :id_empresa => params[:id]
    	# Rubro updating
    	if params[:rubros] 
    		@empresa.rubros << params[:rubros]
    	end
    	# If activating a company, send the activation email to the user.
    	if @empresa.activa != params[:empresa][:activa] && @empresa.company_user
    		UserMailer.activation_email(@empresa.company_user).deliver
    	end

    	if @empresa.update({
	      	nombre:        params[:empresa][:nombre],
	      	cuenta_banco:  params[:empresa][:cuenta_banco],
	      	rut_empresa:   params[:empresa][:rut_empresa],
	      	activa:        params[:empresa][:activa]
	    })
    		render :json => @empresa, :include => [:company_user], status: :ok
    	else
    		render :json => {}, status: :internal_server_error
    	end
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
