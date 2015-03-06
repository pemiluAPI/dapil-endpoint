class AdddedIdDapilToDapils < ActiveRecord::Migration
  def change
    add_column :dapils, :id_dapil, :string
  end
end
