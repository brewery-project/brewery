Rails.application.config.to_prepare do
	Brewery::Admin::DashboardController.register_module(Brewery::Admin::AuthCore::UsersController::AdminModule, 0)
end