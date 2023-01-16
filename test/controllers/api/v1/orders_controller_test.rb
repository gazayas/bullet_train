require "controllers/api/v1/test"

class Api::V1::OrdersControllerTest < Api::Test
    def setup
      # See `test/controllers/api/test.rb` for common set up for API tests.
      super

      @agreement = create(:agreement, team: @team)
@order = build(:order, agreement: @agreement)
      @other_orders = create_list(:order, 3)

      @another_order = create(:order, agreement: @agreement)

      # 🚅 super scaffolding will insert file-related logic above this line.
      @order.save
      @another_order.save
    end

    # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
    # data we were previously providing to users _will_ break the test suite.
    def assert_proper_object_serialization(order_data)
      # Fetch the order in question and prepare to compare it's attributes.
      order = Order.find(order_data["id"])

      assert_equal_or_nil order_data['title'], order.title
      # 🚅 super scaffolding will insert new fields above this line.

      assert_equal order_data["agreement_id"], order.agreement_id
    end

    test "index" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/agreements/#{@agreement.id}/orders", params: {access_token: access_token}
      assert_response :success

      # Make sure it's returning our resources.
      order_ids_returned = response.parsed_body.map { |order| order["id"] }
      assert_includes(order_ids_returned, @order.id)

      # But not returning other people's resources.
      assert_not_includes(order_ids_returned, @other_orders[0].id)

      # And that the object structure is correct.
      assert_proper_object_serialization response.parsed_body.first
    end

    test "show" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/orders/#{@order.id}", params: {access_token: access_token}
      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      get "/api/v1/orders/#{@order.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "create" do
      # Use the serializer to generate a payload, but strip some attributes out.
      params = {access_token: access_token}
      order_data = JSON.parse(build(:order, agreement: nil).to_api_json.to_json)
      order_data.except!("id", "agreement_id", "created_at", "updated_at")
      params[:order] = order_data

      post "/api/v1/agreements/#{@agreement.id}/orders", params: params
      assert_response :success

      # # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      post "/api/v1/agreements/#{@agreement.id}/orders",
        params: params.merge({access_token: another_access_token})
      assert_response :not_found
    end

    test "update" do
      # Post an attribute update ensure nothing is seriously broken.
      put "/api/v1/orders/#{@order.id}", params: {
        access_token: access_token,
        order: {
          title: 'Alternative String Value',
          # 🚅 super scaffolding will also insert new fields above this line.
        }
      }

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # But we have to manually assert the value was properly updated.
      @order.reload
      assert_equal @order.title, 'Alternative String Value'
      # 🚅 super scaffolding will additionally insert new fields above this line.

      # Also ensure we can't do that same action as another user.
      put "/api/v1/orders/#{@order.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "destroy" do
      # Delete and ensure it actually went away.
      assert_difference("Order.count", -1) do
        delete "/api/v1/orders/#{@order.id}", params: {access_token: access_token}
        assert_response :success
      end

      # Also ensure we can't do that same action as another user.
      delete "/api/v1/orders/#{@another_order.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end
end
