describe 'The HelloWorld App' do
  it 'says hello' do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('Hello, World')
  end

  it 'send email' do
    params = { email: 'test@example.com', message: 'message', _replyto: 'owner@example.com', _subject: 'subject' }
    post '/send', params

    current_email = last_email_sent
    expect(current_email).to deliver_to 'owner@example.com'
    expect(current_email).to have_body_text(/message/i)
    expect(current_email).to have_subject(/subject/i)
  end

  it 'redirect after sending' do
    params = { email: 'test@example.com',
               message: 'message',
               _replyto: 'owner@example.com',
               _subject: 'subject',
               _after: 'http://example.com/thanks' }
    post '/send', params

    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.url).to eq 'http://example.com/thanks'
  end
end
