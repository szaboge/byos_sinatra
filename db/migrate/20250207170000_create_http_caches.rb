class CreateHttpCaches < ActiveRecord::Migration[8.0] # Adjust version if needed
  def change
    create_table :http_caches, force: true do |t|
      t.string :url, null: false, index: { unique: true }
      t.text :response_body
      t.datetime :expires_at
      t.timestamps
    end
  end
end