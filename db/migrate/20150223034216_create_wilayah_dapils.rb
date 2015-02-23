class CreateWilayahDapils < ActiveRecord::Migration
  def change
    create_table :wilayah_dapils do |t|
      t.string  :nama
      t.string  :id_dapil
    end
  end
end
