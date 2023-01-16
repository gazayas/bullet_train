# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::AgreementsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :agreement, through: :team, through_association: :agreements

    # GET /api/v1/teams/:team_id/agreements
    def index
    end

    # GET /api/v1/agreements/:id
    def show
    end

    # POST /api/v1/teams/:team_id/agreements
    def create
      if @agreement.save
        render :show, status: :created, location: [:api, :v1, @agreement]
      else
        render json: @agreement.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/agreements/:id
    def update
      if @agreement.update(agreement_params)
        render :show
      else
        render json: @agreement.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/agreements/:id
    def destroy
      @agreement.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def agreement_params
        strong_params = params.require(:agreement).permit(
          *permitted_fields,
          :title,
          # 🚅 super scaffolding will insert new fields above this line.
          *permitted_arrays,
          # 🚅 super scaffolding will insert new arrays above this line.
        )

        process_params(strong_params)

        strong_params
      end
    end

    include StrongParameters
  end
else
  class Api::V1::AgreementsController
  end
end
