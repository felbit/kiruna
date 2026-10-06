require 'pg'
require_relative 'credentials_window'
require_relative 'main_window'

class App
  QUERY = <<~SQL
    SELECT datname FROM pg_database
    WHERE datallowconn AND pg_has_role(datdba, 'MEMBER')
    ORDER BY datname
  SQL

  def initialize
    @databases = []

    @main_window = MainWindow.new(
      databases: @databases,
      on_disconnect: method(:disconnect),
      on_close: -> { @conn&.close }
    )
  end

  def launch
    @main_window.show
  end

  private

  def connect(host:, user:, password:)
    @conn = PG.connect(host:, user:, password:, dbname: 'postgres')
    @databases.replace(@conn.exec(QUERY).map { [it['datname']] })
  rescue PG::Error => e
    @credentials_window.show_error(e.message)
  end

  def disconnect
    @conn.close
    @conn = nil
    @databases.clear
  end

  def quit
    @main_window.close
    ::LibUI.quit
  end
end