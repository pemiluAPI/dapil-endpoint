class CreateDapils < ActiveRecord::Migration
  def change
    create_table :dapils do |t|
      t.string  :nama
      t.string  :jumlah_kursi
      t.string  :id_provinsi
    end
  end
end
