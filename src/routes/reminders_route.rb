get '/reminders' do
  content_type :json

  begin 
    reminders = DB.execute <<~SQL
      SELECT
        reminders.*,
        contacts.name AS contact_name,
        contacts.number AS contact_number
      FROM reminders
      INNER JOIN contacts ON contacts.id = reminders.contact_id
      ORDER BY reminders.scheduled_at ASC
    SQL

    reminders.to_json
  rescue StandardError => e
    status 500
    {
      error: "Falha ao buscar lembretes",
      details: e.message
  }.to_json
  end
end

post '/reminders' do
  content_type :json

  begin
    data = JSON.parse(request.body.read)

    DB.execute(
      "INSERT INTO reminders (contact_id, title, scheduled_at, description, status) VALUES (?, ?, ?, ?)",
      [data['contact_id'], data['title'], data['scheduled_at']]
    )

    {
      message: 'Reminder created' 
    }.to_json 
  rescue StandardError => e
    status 500 
    {
      error: "Não foi possivel criar lembrete",
      details: e.message
    }
  end
end