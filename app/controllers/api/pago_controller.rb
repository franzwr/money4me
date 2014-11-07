class API::PagoController < ApplicationController
	respond_to :json

	def pago_params
		params.require(:pago).permit(:cuenta_banco, :rut_cliente, :email, :detalle, :fecha_pago, :cuenta_ids, :id_propio_empresas)
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
    if user_signed_in?
      params[:pago][:rut_cliente] ||= user.rut
      params[:pago][:email]       ||= user.email
    end

		@pago = Pago.new(pago_params)
    # Bill to pay IDs are found using id_propio_empresa
    @pago.cuentas = Cuenta.where("id_propio_empresa IN (?)",
                                 JSON.parse(params[:pago][:id_propio_empresas]))
    @pago.fecha_pago = Date.today

    # TODO Mailer

    # 1. Check if account exists
    cuenta_origen = params[:pago][:cuenta_banco].to_i
    cuenta_banco_response = `curl -w %{http_code} http://204.87.169.110/accounts/#{cuenta_origen}`

    if cuenta_banco_response.end_with? "200"
      # 2. Check if balance is enough
      cuenta_banco = JSON.parse query_result[0..-4]
      sum_monto    = @pago.cuentas.sum(:monto)

      if cuenta_banco[:fondo] > sum_monto
        # 3. Don't allow for paying a receipt more than once
        if @pago.cuentas.any? {|cuenta| cuenta.pagos.count > 0}
          render :json => {}, status: :internal_server_error

        elsif @pago.save
          # 4. Transfer the money
          @pago.cuentas.each do |cuenta|
            transferencia_fondos = `curl -w %{http_code} http://204.87.169.110/transfer/#{cuenta_origen}/#{cuenta.empresa.cuenta_banco}/#{cuenta.monto}`

            unless transferencia_fondos.end_with? "200"
              # TODO Panic!!
            end
          end

          # 5. done!
          render :json => @pago
        else
          render :json => {}, status: :internal_server_error
        end
      else
        render :json => {}, status: :internal_server_error
      end
    else
      render :json => {}, status: :internal_server_error
    end
	end

	def update
    # Shouldn't be possible.
		render :json => {}, status: :internal_server_error
	end

	def destroy
    # Should'nt be possible.
		render :json => {}, status: :internal_server_error
	end
end
