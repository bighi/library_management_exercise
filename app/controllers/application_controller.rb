class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError do |exception|
    respond_to do |format|
      format.html do
        redirect_to(request.referrer || root_path, alert: "You are not authorized to perform this action.")
      end
      format.json do
        render json: { error: "You are not authorized to perform this action." }, status: :forbidden
      end
    end
  end
end
