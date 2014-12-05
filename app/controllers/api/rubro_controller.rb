# = rubro_controller.rb
#
# Defines all Rubro related API tasks.
class API::RubroController < ApplicationController
  before_action :authenticate_admin!, only: [:create, :update, :destroy]
	respond_to :json

	def rubro_params
		params.require(:rubro).permit(:nombre)
	end

	# Returns all Rubros
	def index
		respond_with Rubro.all
	end

	# Returns the specified Rubro.
	def show
		@rubro = Rubro.find_by :id_rubro => params[:id]
		if @rubro
			render :json => @rubro
		else
			render :json => {}, status: :not_found
		end
	end

	# Modifies the specified Rubro and returns it.
	def update
		@rubro = Rubro.find_by :id_rubro => params[:id]
		if @rubro.update(nombre: params[:rubro][:nombre])
			render :json => @rubro
		else
			render :json => {}, status: :internal_server_error
		end
	end

	# Creates a new Rubro and returns it.
	def create
		@rubro = Rubro.new(rubro_params)
		if @rubro.save
			render :json => @rubro
		else
			render :json => {}, status: :internal_server_error
		end
	end

	# Destroys a Rubro.
	def destroy
		@rubro = Rubro.find_by :id_rubro => params[:id]
		if @rubro.destroy
			render :json => {}, status: :ok
		else
			render :json => {}, status: :internal_server_error
		end
	end
end
