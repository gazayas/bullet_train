class Account::OrdersController < Account::ApplicationController
  account_load_and_authorize_resource :order, through: :agreement, through_association: :orders

  # GET /account/agreements/:agreement_id/orders
  # GET /account/agreements/:agreement_id/orders.json
  def index
    delegate_json_to_api
  end

  # GET /account/orders/:id
  # GET /account/orders/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/agreements/:agreement_id/orders/new
  def new
  end

  # GET /account/orders/:id/edit
  def edit
  end

  # POST /account/agreements/:agreement_id/orders
  # POST /account/agreements/:agreement_id/orders.json
  def create
    respond_to do |format|
      if @order.save
        format.html { redirect_to [:account, @agreement, :orders], notice: I18n.t("orders.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @order] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/orders/:id
  # PATCH/PUT /account/orders/:id.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to [:account, @order], notice: I18n.t("orders.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @order] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/orders/:id
  # DELETE /account/orders/:id.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @agreement, :orders], notice: I18n.t("orders.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
