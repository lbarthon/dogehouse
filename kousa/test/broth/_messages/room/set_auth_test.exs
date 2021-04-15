defmodule BrothTest.Message.Room.SetAuth do
  use ExUnit.Case, async: true

  @moduletag :message

  alias Broth.Message.Room.SetAuth

  setup do
    {:ok, uuid: UUID.uuid4()}
  end

  describe "when you send an set mod message" do
    test "it validates", %{uuid: uuid} do
      assert {:ok,
              %{
                payload: %SetAuth{id: ^uuid, level: :mod}
              }} =
               BrothTest.Support.Message.validate(%{
                 "operator" => "room:set_auth",
                 "payload" => %{"id" => uuid, "level" => "mod"}
               })

      assert {:ok,
              %{
                payload: %SetAuth{id: ^uuid, level: :owner}
              }} =
               BrothTest.Support.Message.validate(%{
                 "operator" => "room:set_auth",
                 "payload" => %{"id" => uuid, "level" => "owner"}
               })

      assert {:ok,
              %{
                payload: %SetAuth{id: ^uuid, level: :user}
              }} =
               BrothTest.Support.Message.validate(%{
                 "operator" => "room:set_auth",
                 "payload" => %{"id" => uuid, "level" => "user"}
               })

      # short form also allowed
      assert {:ok,
              %{
                payload: %SetAuth{id: ^uuid, level: :mod}
              }} =
               BrothTest.Support.Message.validate(%{
                 "op" => "room:set_auth",
                 "p" => %{"id" => uuid, "level" => "mod"}
               })
    end

    test "omitting the id is not allowed" do
      assert {:error, %{errors: [id: {"can't be blank", _}]}} =
               BrothTest.Support.Message.validate(%{
                 "operator" => "room:set_auth",
                 "payload" => %{"level" => "mod"}
               })
    end

    test "omitting level is not allowed", %{uuid: uuid} do
      assert {:error, %{errors: [level: {"can't be blank", _}]}} =
               BrothTest.Support.Message.validate(%{
                 "operator" => "room:set_auth",
                 "payload" => %{"id" => uuid}
               })
    end

    test "level must be the correct form", %{uuid: uuid} do
      assert {:error, %{errors: [level: {"is invalid", _}]}} =
               BrothTest.Support.Message.validate(%{
                 "operator" => "room:set_auth",
                 "payload" => %{"id" => uuid, "level" => "admin"}
               })
    end
  end
end
