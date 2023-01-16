class Account::AgreementsController < Account::ApplicationController
  account_load_and_authorize_resource :agreement, through: :team, through_association: :agreements

  # GET /account/teams/:team_id/agreements
  # GET /account/teams/:team_id/agreements.json
  def index
    delegate_json_to_api
  end

  # GET /account/agreements/:id
  # GET /account/agreements/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/agreements/new
  def new
  end

  # GET /account/agreements/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/agreements
  # POST /account/teams/:team_id/agreements.json
  def create
    respond_to do |format|
      if @agreement.save
        format.html { redirect_to [:account, @team, :agreements], notice: I18n.t("agreements.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @agreement] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @agreement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/agreements/:id
  # PATCH/PUT /account/agreements/:id.json
  def update
    respond_to do |format|
      if @agreement.update(agreement_params)
        format.html { redirect_to [:account, @agreement], notice: I18n.t("agreements.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @agreement] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @agreement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/agreements/:id
  # DELETE /account/agreements/:id.json
  def destroy
    @agreement.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :agreements], notice: I18n.t("agreements.notifications.destroyed") }
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
