require_relative '../services/evolution_go_service'

def get_pending_reminders
  DB.execute <<~SQL
    SELECT
      reminders.*,
      contacts.name AS contact_name,
      contacts.number AS contact_number
    FROM reminders
    INNER JOIN contacts ON contacts.id = reminders.contact_id
    WHERE reminders.status = 'pending'
      AND reminders.scheduled_at <= datetime('now')
    ORDER BY reminders.scheduled_at ASC;
  SQL
end

def dispatch_pending_reminders
  api = EvolutionGoApi.new
  get_pending_reminders.each do |r|
    resultado = api.send_text(r['contact_number'], r['description'])

    novo_status = resultado['error'] ? 'failed' : 'sent'
    DB.execute(
      "UPDATE reminders SET status = ?, updated_at = datetime('now') WHERE id = ?",
      [novo_status, r['id']]
    )
  end
end