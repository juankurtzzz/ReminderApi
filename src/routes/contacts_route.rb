get '/contacts' do
  content_type :json

  begin
    contacts = DB.execute <<~SQL
      SELECT * FROM contacts;
    SQL

    contacts.to_json
  rescue StandardError => e
    status 500
    {
      error: "Falha ao buscar contatos",
      details: e.message
    }.to_json
  end
end

post '/contacts' do
  begin
    content_type :json

    data = JSON.parse(request.body.read)

    DB.execute(
      "INSERT INTO contacts (name, number) VALUES (?, ?)",
      [data['name'], data['number']]
    )

    {
      message: 'Contact created'
    }.to_json

  rescue StandardError => e
    status 500
    {
      error: "Não foi possivel criar contato",
      details: e.message
  }.to_json
  end
end