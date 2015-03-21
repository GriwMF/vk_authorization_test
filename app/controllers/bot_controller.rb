class BotController < ApplicationController
  def index
    key = "some very-very long string without any non-latin characters due to different string representations inside of variable programming languages"

    @message = params[:message]
    session[:history] = [] unless session[:history]
    $chat_id ||= init['result']['cuid']
    if @message
      session[:history] << @message
      # TODO: add preprocessing of message
      whattosend = '["' + $chat_id + '","' + @message + '"]'
      hashed = Base64.encode64(xor_decrypt(Base64.encode64(whattosend), key))

      response = Faraday.post('http://iii.ru/api/2.0/json/Chat.request') { |req| req.body = hashed }

      answer = JSON.parse(Base64.decode64(xor_decrypt(Base64.decode64(response.body), key)))
      p answer
      session[:history] << answer['result']['text']['value']

      # TODO: remove tags from answer
      # TODO: auto name and gender for bot?
      # ActionView::Base.full_sanitizer.sanitize(s)
    end
  end

  private

  def xor_decrypt(string, key)
    key = key.unpack('C*')
    string.each_byte.with_index.map { |byte, index| byte ^ key[index % key.size] }.pack('C*')
  end

  def init
    botid = 'aaa83440-d322-47a8-8ba8-0ecbe0be1d1c'
    vkid = 'test'
    key = "some very-very long string without any non-latin characters due to different string representations inside of variable programming languages"
    getuid = Faraday.get("http://iii.ru/api/2.0/json/Chat.init/#{botid}/#{vkid}").body

    JSON.parse(Base64.decode64(xor_decrypt(Base64.decode64(getuid), key)))
  end
end