class Account::TeamsController < Account::ApplicationController
  include Account::Teams::ControllerBase
  before_action :set_orders, only: [:show]

  private

  def permitted_fields
    []
  end

  def permitted_arrays
    {}
  end

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
    strong_params
  end

  def set_orders
    @all_orders = Order.where(agreement: current_team.agreements)
  end
end
