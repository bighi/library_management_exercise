class Api::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render json: { token: request.env['warden-jwt_auth.token'], user: resource }, status: :ok
  end

  def respond_to_on_destroy
    head :no_content
  end
end