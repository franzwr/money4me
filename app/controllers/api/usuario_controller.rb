class API::UsuarioController < ApplicationController
  before_filter :authenticate_usuario!
	respond_to :json

  def deudas
    respond_with current_usuario.cuentas.impagas
  end

  def cercanas_a_vencer
    respond_with current_usuario.cuentas.cercanas_a_vencer
  end

  def historial_de_pagos
    respond_with current_usuario.cuentas.pagadas
  end
end
