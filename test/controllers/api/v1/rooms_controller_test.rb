require "controllers/api/v1/test"

class Api::V1::RoomsControllerTest < Api::Test
    def setup
      # See `test/controllers/api/test.rb` for common set up for API tests.
      super

      @location = create(:location, team: @team)
@room = build(:room, location: @location)
      @other_rooms = create_list(:room, 3)

      @another_room = create(:room, location: @location)

      # 🚅 super scaffolding will insert file-related logic above this line.
      @room.save
      @another_room.save
    end

    # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
    # data we were previously providing to users _will_ break the test suite.
    def assert_proper_object_serialization(room_data)
      # Fetch the room in question and prepare to compare it's attributes.
      room = Room.find(room_data["id"])

      assert_equal_or_nil room_data['name'], room.name
      assert_equal_or_nil room_data['level'], room.level
      assert_equal_or_nil room_data['code'], room.code
      # 🚅 super scaffolding will insert new fields above this line.

      assert_equal room_data["location_id"], room.location_id
    end

    test "index" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/locations/#{@location.id}/rooms", params: {access_token: access_token}
      assert_response :success

      # Make sure it's returning our resources.
      room_ids_returned = response.parsed_body.map { |room| room["id"] }
      assert_includes(room_ids_returned, @room.id)

      # But not returning other people's resources.
      assert_not_includes(room_ids_returned, @other_rooms[0].id)

      # And that the object structure is correct.
      assert_proper_object_serialization response.parsed_body.first
    end

    test "show" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/rooms/#{@room.id}", params: {access_token: access_token}
      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      get "/api/v1/rooms/#{@room.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "create" do
      # Use the serializer to generate a payload, but strip some attributes out.
      params = {access_token: access_token}
      room_data = JSON.parse(build(:room, location: nil).to_api_json)
      room_data.except!("id", "location_id", "created_at", "updated_at")
      params[:room] = room_data

      post "/api/v1/locations/#{@location.id}/rooms", params: params
      assert_response :success

      # # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      post "/api/v1/locations/#{@location.id}/rooms",
        params: params.merge({access_token: another_access_token})
      assert_response :not_found
    end

    test "update" do
      # Post an attribute update ensure nothing is seriously broken.
      put "/api/v1/rooms/#{@room.id}", params: {
        access_token: access_token,
        room: {
          name: 'Alternative String Value',
          level: 'Alternative String Value',
          code: 'Alternative String Value',
          # 🚅 super scaffolding will also insert new fields above this line.
        }
      }

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # But we have to manually assert the value was properly updated.
      @room.reload
      assert_equal @room.name, 'Alternative String Value'
      assert_equal @room.level, 'Alternative String Value'
      assert_equal @room.code, 'Alternative String Value'
      # 🚅 super scaffolding will additionally insert new fields above this line.

      # Also ensure we can't do that same action as another user.
      put "/api/v1/rooms/#{@room.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "destroy" do
      # Delete and ensure it actually went away.
      assert_difference("Room.count", -1) do
        delete "/api/v1/rooms/#{@room.id}", params: {access_token: access_token}
        assert_response :success
      end

      # Also ensure we can't do that same action as another user.
      delete "/api/v1/rooms/#{@another_room.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end
end
