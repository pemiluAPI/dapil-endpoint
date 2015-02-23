class Province < ActiveRecord::Base
  self.primary_key = 'id'
  has_many :dapils, foreign_key: :id_provinsi
end
