# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::OrdersController < Api::V1::ApplicationController
    account_load_and_authorize_resource :order, through: :agreement, through_association: :orders

    # GET /api/v1/agreements/:agreement_id/orders
    def index
    end

    # GET /api/v1/orders/:id
    def show
    end

    # POST /api/v1/agreements/:agreement_id/orders
    def create
      if @order.save
        render :show, status: :created, location: [:api, :v1, @order]
      else
        render json: @order.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/orders/:id
    def update
      if @order.update(order_params)
        render :show
      else
        render json: @order.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/orders/:id
    def destroy
      @order.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def order_params
        strong_params = params.require(:order).permit(
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
  class Api::V1::OrdersController
  end
end
