class BotsController < ApplicationController
  def show
    bot_id = '6de4ced8-434b-4803-8b46-32a64b92eb8a'

    vk = VkontakteApi::Client.new(session[:token])
    @messages = vk.messages.get_dialogs(unread: 1, v: 5.37).items.map { |item| item.message.slice(:user_id, :body) }

    @messages.each do |message|
      if (chat_room = ChatRoom.find_by(user_id: message.user_id, bot_id: bot_id))
        bot = IiiApi::Bot.new(chat_room.chat_id)
      else
        bot = IiiApi::Bot.new(bot_id, "6de4ced8-private-room-#{message.user_id}")
        ChatRoom.create(user_id: message.user_id, bot_id: bot_id, chat_id: bot.chat_id)
      end

      message.answer = ActionView::Base.full_sanitizer.sanitize(bot.ask(message.body))
      message.response = vk.messages.send(user_id: message.user_id, message: message.answer, v: 5.37)
    end
  end
end
