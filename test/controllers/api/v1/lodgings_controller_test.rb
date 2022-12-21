require "controllers/api/v1/test"

class Api::V1::LodgingsControllerTest < Api::Test
    def setup
      # See `test/controllers/api/test.rb` for common set up for API tests.
      super

      @location = create(:location, team: @team)
@lodging = build(:lodging, location: @location)
      @other_lodgings = create_list(:lodging, 3)

      @another_lodging = create(:lodging, location: @location)

      # 🚅 super scaffolding will insert file-related logic above this line.
      @lodging.save
      @another_lodging.save
    end

    # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
    # data we were previously providing to users _will_ break the test suite.
    def assert_proper_object_serialization(lodging_data)
      # Fetch the lodging in question and prepare to compare it's attributes.
      lodging = Lodging.find(lodging_data["id"])

      assert_equal_or_nil lodging_data['name'], lodging.name
      assert_equal_or_nil lodging_data['summary'], lodging.summary
      assert_equal_or_nil lodging_data['price_night_cents'], lodging.price_night_cents
      assert_equal_or_nil lodging_data['price_weekend_cents'], lodging.price_weekend_cents
      assert_equal_or_nil lodging_data['party_hall_availability'], lodging.party_hall_availability
      # 🚅 super scaffolding will insert new fields above this line.

      assert_equal lodging_data["location_id"], lodging.location_id
    end

    test "index" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/locations/#{@location.id}/lodgings", params: {access_token: access_token}
      assert_response :success

      # Make sure it's returning our resources.
      lodging_ids_returned = response.parsed_body.map { |lodging| lodging["id"] }
      assert_includes(lodging_ids_returned, @lodging.id)

      # But not returning other people's resources.
      assert_not_includes(lodging_ids_returned, @other_lodgings[0].id)

      # And that the object structure is correct.
      assert_proper_object_serialization response.parsed_body.first
    end

    test "show" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/lodgings/#{@lodging.id}", params: {access_token: access_token}
      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      get "/api/v1/lodgings/#{@lodging.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "create" do
      # Use the serializer to generate a payload, but strip some attributes out.
      params = {access_token: access_token}
      lodging_data = JSON.parse(build(:lodging, location: nil).to_api_json)
      lodging_data.except!("id", "location_id", "created_at", "updated_at")
      params[:lodging] = lodging_data

      post "/api/v1/locations/#{@location.id}/lodgings", params: params
      assert_response :success

      # # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      post "/api/v1/locations/#{@location.id}/lodgings",
        params: params.merge({access_token: another_access_token})
      assert_response :not_found
    end

    test "update" do
      # Post an attribute update ensure nothing is seriously broken.
      put "/api/v1/lodgings/#{@lodging.id}", params: {
        access_token: access_token,
        lodging: {
          name: 'Alternative String Value',
          summary: 'Alternative String Value',
          price_night_cents: 'Alternative String Value',
          price_weekend_cents: 'Alternative String Value',
          # 🚅 super scaffolding will also insert new fields above this line.
        }
      }

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # But we have to manually assert the value was properly updated.
      @lodging.reload
      assert_equal @lodging.name, 'Alternative String Value'
      assert_equal @lodging.summary, 'Alternative String Value'
      assert_equal @lodging.price_night_cents, 'Alternative String Value'
      assert_equal @lodging.price_weekend_cents, 'Alternative String Value'
      # 🚅 super scaffolding will additionally insert new fields above this line.

      # Also ensure we can't do that same action as another user.
      put "/api/v1/lodgings/#{@lodging.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "destroy" do
      # Delete and ensure it actually went away.
      assert_difference("Lodging.count", -1) do
        delete "/api/v1/lodgings/#{@lodging.id}", params: {access_token: access_token}
        assert_response :success
      end

      # Also ensure we can't do that same action as another user.
      delete "/api/v1/lodgings/#{@another_lodging.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end
end
