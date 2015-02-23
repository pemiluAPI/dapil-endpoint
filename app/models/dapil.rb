class Dapil < ActiveRecord::Base
  self.primary_key = 'id'
  belongs_to :province, -> { select('id, nama') }, foreign_key: :id_provinsi
  has_many :wilayah_dapils, -> { select('id, id_dapil, nama') }, foreign_key: :id_dapil
end
