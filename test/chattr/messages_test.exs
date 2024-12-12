defmodule Chattr.MessagesTest do
  use Chattr.DataCase

  alias Chattr.Messages

  describe "messages" do
    alias Chattr.Messages.Message

    import Chattr.MessagesFixtures

    @invalid_attrs %{sent_time: nil}

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert Messages.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Messages.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      valid_attrs = %{sent_time: ~U[2024-11-07 02:54:00Z]}

      assert {:ok, %Message{} = message} = Messages.create_message(valid_attrs)
      assert message.sent_time == ~U[2024-11-07 02:54:00Z]
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messages.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      update_attrs = %{sent_time: ~U[2024-11-08 02:54:00Z]}

      assert {:ok, %Message{} = message} = Messages.update_message(message, update_attrs)
      assert message.sent_time == ~U[2024-11-08 02:54:00Z]
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Messages.update_message(message, @invalid_attrs)
      assert message == Messages.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Messages.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Messages.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Messages.change_message(message)
    end
  end

  describe "messages" do
    alias Chattr.Messages.Message

    import Chattr.MessagesFixtures

    @invalid_attrs %{sent_time: nil, content: nil}

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert Messages.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Messages.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      valid_attrs = %{sent_time: ~U[2024-11-07 03:00:00Z], content: "some content"}

      assert {:ok, %Message{} = message} = Messages.create_message(valid_attrs)
      assert message.sent_time == ~U[2024-11-07 03:00:00Z]
      assert message.content == "some content"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messages.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      update_attrs = %{sent_time: ~U[2024-11-08 03:00:00Z], content: "some updated content"}

      assert {:ok, %Message{} = message} = Messages.update_message(message, update_attrs)
      assert message.sent_time == ~U[2024-11-08 03:00:00Z]
      assert message.content == "some updated content"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Messages.update_message(message, @invalid_attrs)
      assert message == Messages.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Messages.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Messages.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Messages.change_message(message)
    end
  end
end
