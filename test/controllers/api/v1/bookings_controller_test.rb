require "controllers/api/v1/test"

class Api::V1::BookingsControllerTest < Api::Test
    def setup
      # See `test/controllers/api/test.rb` for common set up for API tests.
      super

      @location = create(:location, team: @team)
@booking = build(:booking, location: @location)
      @other_bookings = create_list(:booking, 3)

      @another_booking = create(:booking, location: @location)

      # 🚅 super scaffolding will insert file-related logic above this line.
      @booking.save
      @another_booking.save
    end

    # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
    # data we were previously providing to users _will_ break the test suite.
    def assert_proper_object_serialization(booking_data)
      # Fetch the booking in question and prepare to compare it's attributes.
      booking = Booking.find(booking_data["id"])

      assert_equal_or_nil booking_data['person_id'], booking.person_id
      assert_equal_or_nil booking_data['lodging_id'], booking.lodging_id
      assert_equal_or_nil Date.parse(booking_data['from_date']), booking.from_date
      assert_equal_or_nil Date.parse(booking_data['to_date']), booking.to_date
      assert_equal_or_nil booking_data['status'], booking.status
      assert_equal_or_nil booking_data['adults'], booking.adults
      assert_equal_or_nil booking_data['children'], booking.children
      assert_equal_or_nil booking_data['checkin_time'], booking.checkin_time
      assert_equal_or_nil booking_data['selected_tier'], booking.selected_tier
      assert_equal_or_nil booking_data['payment_status'], booking.payment_status
      assert_equal_or_nil booking_data['payment_method'], booking.payment_method
      assert_equal_or_nil booking_data['bedsheets'], booking.bedsheets
      assert_equal_or_nil booking_data['towels'], booking.towels
      assert_equal_or_nil booking_data['shown_price_cents'], booking.shown_price_cents
      assert_equal_or_nil booking_data['price_cents'], booking.price_cents
      assert_equal_or_nil booking_data['invoice_status'], booking.invoice_status
      assert_equal_or_nil booking_data['contract_status'], booking.contract_status
      assert_equal_or_nil booking_data['options'], booking.options
      assert_equal_or_nil booking_data['comments'], booking.comments
      # 🚅 super scaffolding will insert new fields above this line.

      assert_equal booking_data["location_id"], booking.location_id
    end

    test "index" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/locations/#{@location.id}/bookings", params: {access_token: access_token}
      assert_response :success

      # Make sure it's returning our resources.
      booking_ids_returned = response.parsed_body.map { |booking| booking["id"] }
      assert_includes(booking_ids_returned, @booking.id)

      # But not returning other people's resources.
      assert_not_includes(booking_ids_returned, @other_bookings[0].id)

      # And that the object structure is correct.
      assert_proper_object_serialization response.parsed_body.first
    end

    test "show" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/bookings/#{@booking.id}", params: {access_token: access_token}
      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      get "/api/v1/bookings/#{@booking.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "create" do
      # Use the serializer to generate a payload, but strip some attributes out.
      params = {access_token: access_token}
      booking_data = JSON.parse(build(:booking, location: nil).to_api_json)
      booking_data.except!("id", "location_id", "created_at", "updated_at")
      params[:booking] = booking_data

      post "/api/v1/locations/#{@location.id}/bookings", params: params
      assert_response :success

      # # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      post "/api/v1/locations/#{@location.id}/bookings",
        params: params.merge({access_token: another_access_token})
      assert_response :not_found
    end

    test "update" do
      # Post an attribute update ensure nothing is seriously broken.
      put "/api/v1/bookings/#{@booking.id}", params: {
        access_token: access_token,
        booking: {
          adults: 'Alternative String Value',
          children: 'Alternative String Value',
          checkin_time: 'Alternative String Value',
          shown_price_cents: 'Alternative String Value',
          comments: 'Alternative String Value',
          # 🚅 super scaffolding will also insert new fields above this line.
        }
      }

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # But we have to manually assert the value was properly updated.
      @booking.reload
      assert_equal @booking.adults, 'Alternative String Value'
      assert_equal @booking.children, 'Alternative String Value'
      assert_equal @booking.checkin_time, 'Alternative String Value'
      assert_equal @booking.shown_price_cents, 'Alternative String Value'
      assert_equal @booking.price_cents, 'Alternative String Value'
      assert_equal @booking.comments, 'Alternative String Value'
      # 🚅 super scaffolding will additionally insert new fields above this line.

      # Also ensure we can't do that same action as another user.
      put "/api/v1/bookings/#{@booking.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "destroy" do
      # Delete and ensure it actually went away.
      assert_difference("Booking.count", -1) do
        delete "/api/v1/bookings/#{@booking.id}", params: {access_token: access_token}
        assert_response :success
      end

      # Also ensure we can't do that same action as another user.
      delete "/api/v1/bookings/#{@another_booking.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end
end
