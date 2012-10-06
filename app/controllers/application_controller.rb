class ApplicationController < ActionController::Base
  protect_from_forgery

  def not_found
  	raise ActionController::RoutingError.new('Not found')
  end

  def current_ability
  	@current_ability ||= Ability.new(current_account)
  end

end
