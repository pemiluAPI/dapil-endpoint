class WilayahDapil < ActiveRecord::Base
  self.primary_key = 'id'
  belongs_to :dapil, foreign_key: :id_dapil
end
