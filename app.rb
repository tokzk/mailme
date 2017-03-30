require 'active_support'
require 'active_support/core_ext'
require 'pony'
require 'sinatra'

Pony.options = {
  via: :smtp,
  charset: 'UTF-8',
  via_options: {
    address: 'smtp.gmail.com',
    port: '587',
    domain: 'gmail.com',
    user_name: ENV['USER_NAME'],
    password: ENV['USER_PASSWORD'],
    authentication: :plain
  }
}

configure do
  set :replyto, ENV['MAIL_REPLY_TO']
  set :mail_from, ENV['MAIL_FROM']
  set :subject, 'Inquiry from site.'
  set :template_path, 'views/message.html.erb'
  set :reserved, ['_subject',
                  '_replyto',
                  'cc[]',
                  'bcc[]',
                  '_after',
                  '_honey',
                  'file',
                  '_confirmation']
end

helpers do
  # rubocop:disable Metrics/AbcSize
  def deliver(details)
    replyto = details[:_replyto] || settings.replyto
    subject = details[:_subject] || settings.subject
    data = details.except(*settings.reserved)

    body = ERB.new(File.read(settings.template_path)).result(binding)

    Pony.mail(
      to: replyto,
      from: settings.mail_from,
      subject: subject,
      html_body: body
    )
  end
end

get '/' do
  'Hello, World'
end

post '/send' do
  deliver(params)

  after_sending_url = params[:_after]
  redirect to(after_sending_url) if after_sending_url
end
