class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    layout :layout_by_resource

    # before_action :configure_permitted_parameters, if: :devise_controller?

    private
    # def create_work_group
    #     puts "ENTROU!!!!! DEVISE!!!!"
    # end

    # def configure_permitted_parameters
    #     devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    #     raise
    # end

    def layout_by_resource
        if devise_controller? && resource_name == :user
            "app_devise"
        else
            "application"
        end
    end
end
