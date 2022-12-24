require "controllers/api/v1/test"

class Api::V1::ReservationsControllerTest < Api::Test
    def setup
      # See `test/controllers/api/test.rb` for common set up for API tests.
      super

      @location = create(:location, team: @team)
@reservation = build(:reservation, location: @location)
      @other_reservations = create_list(:reservation, 3)

      @another_reservation = create(:reservation, location: @location)

      # 🚅 super scaffolding will insert file-related logic above this line.
      @reservation.save
      @another_reservation.save
    end

    # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
    # data we were previously providing to users _will_ break the test suite.
    def assert_proper_object_serialization(reservation_data)
      # Fetch the reservation in question and prepare to compare it's attributes.
      reservation = Reservation.find(reservation_data["id"])

      assert_equal_or_nil reservation_data['booking_id'], reservation.booking_id
      assert_equal_or_nil reservation_data['room_id'], reservation.room_id
      assert_equal_or_nil Date.parse(reservation_data['date']), reservation.date
      assert_equal_or_nil reservation_data['status'], reservation.status
      # 🚅 super scaffolding will insert new fields above this line.

      assert_equal reservation_data["location_id"], reservation.location_id
    end

    test "index" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/locations/#{@location.id}/reservations", params: {access_token: access_token}
      assert_response :success

      # Make sure it's returning our resources.
      reservation_ids_returned = response.parsed_body.map { |reservation| reservation["id"] }
      assert_includes(reservation_ids_returned, @reservation.id)

      # But not returning other people's resources.
      assert_not_includes(reservation_ids_returned, @other_reservations[0].id)

      # And that the object structure is correct.
      assert_proper_object_serialization response.parsed_body.first
    end

    test "show" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/reservations/#{@reservation.id}", params: {access_token: access_token}
      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      get "/api/v1/reservations/#{@reservation.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "create" do
      # Use the serializer to generate a payload, but strip some attributes out.
      params = {access_token: access_token}
      reservation_data = JSON.parse(build(:reservation, location: nil).to_api_json)
      reservation_data.except!("id", "location_id", "created_at", "updated_at")
      params[:reservation] = reservation_data

      post "/api/v1/locations/#{@location.id}/reservations", params: params
      assert_response :success

      # # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      post "/api/v1/locations/#{@location.id}/reservations",
        params: params.merge({access_token: another_access_token})
      assert_response :not_found
    end

    test "update" do
      # Post an attribute update ensure nothing is seriously broken.
      put "/api/v1/reservations/#{@reservation.id}", params: {
        access_token: access_token,
        reservation: {
          # 🚅 super scaffolding will also insert new fields above this line.
        }
      }

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # But we have to manually assert the value was properly updated.
      @reservation.reload
      # 🚅 super scaffolding will additionally insert new fields above this line.

      # Also ensure we can't do that same action as another user.
      put "/api/v1/reservations/#{@reservation.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "destroy" do
      # Delete and ensure it actually went away.
      assert_difference("Reservation.count", -1) do
        delete "/api/v1/reservations/#{@reservation.id}", params: {access_token: access_token}
        assert_response :success
      end

      # Also ensure we can't do that same action as another user.
      delete "/api/v1/reservations/#{@another_reservation.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end
end
