class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.date :deal_date
      t.string :category
      t.string :round
      t.integer :amount
      t.integer :pre_valuation
      t.string :source_url
      t.references :company
      # TODO: add foreign key constraints

      t.timestamps
    end
    add_index :deals, :company_id
  end
end