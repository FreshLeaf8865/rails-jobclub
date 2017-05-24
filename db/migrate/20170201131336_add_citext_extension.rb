class AddCitextExtension < ActiveRecord::Migration[5.0]
  def up
    #ActiveRecord::Base.connection.execute("CREATE EXTENSION IF NOT EXISTS citext;")
  end

  def down
    #ActiveRecord::Base.connection.execute("DROP EXTENSION citext;")
  end
end
