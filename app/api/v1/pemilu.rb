module DapilHelpers
  def build_wilayah_dapil(wilayah_dapil)
    wilayah = Array.new

    wilayah_dapil.map {|dapil|
      wilayah << {
        id: dapil.id,
        nama: dapil.nama
      }
    }

    return wilayah
  end
end

module Pemilu
  class APIv1 < Grape::API
    version 'v1', using: :accept_version_header
    prefix 'api'
    format :json

    resource :dapil do
      helpers DapilHelpers

      desc "Return all dapil"
      get do
        list_dapil = Array.new

       # Prepare conditions based on params
        valid_params = {
          provinsi: 'id_provinsi'
        }

        conditions = Hash.new
        valid_params.each_pair do |key, value|
          conditions[value.to_sym] = params[key.to_sym] unless params[key.to_sym].blank?
        end

        # Set default limit
        limit = (params[:limit].to_i == 0 || params[:limit].empty?) ? 35 : params[:limit]

        Dapil.includes(:province, :wilayah_dapils)
          .where(conditions)
          .limit(limit)
          .offset(params[:offset])
          .each do |dapil|
            list_dapil << {
              id: dapil.id,
              nama: dapil.nama,
              province: {
                id: dapil.province.id,
                nama: dapil.province.nama
              },
              jumlah_kursi: dapil.jumlah_kursi,
              wilayah: build_wilayah_dapil(dapil.wilayah_dapils)
            }
          end

        {
          results: {
            count: list_dapil.count,
            total: Dapil.where(conditions).count,
            dapil: list_dapil
          }
        }
      end

      desc "Return a Dapil"
      params do
        requires :id, type: String, desc: "Dapil ID."
      end
      route_param :id do
        get do
            dapil = Dapil.find_by(id: params[:id])

            {
              results: {
                count: 1,
                total: 1,
                dapil: [{
                  id: dapil.id,
                  nama: dapil.nama,
                  provinsi: {
                    id: dapil.province.id,
                    nama: dapil.province.nama
                  },
                  jumlah_kursi: dapil.jumlah_kursi,
                  wilayah: build_wilayah_dapil(dapil.wilayah_dapils)
                }]
              }
            }
        end
      end
    end

    resource :provinsi do
      desc "Return all provinces"
      get do
        provinces = Array.new

       # Prepare conditions based on params
        valid_params = {
          nama: 'nama_lengkap'
        }

        conditions = Hash.new
        valid_params.each_pair do |key, value|
          conditions[value.to_sym] = params[key.to_sym] unless params[key.to_sym].blank?
        end

        # Set default limit
        limit = (params[:limit].to_i == 0 || params[:limit].empty?) ? 33 : params[:limit]

        Province.where(conditions)
          .limit(limit)
          .offset(params[:offset])
          .each do |province|
            provinces << {
              id: province.id,
              nama: province.nama,
              nama_lengkap: province.nama_lengkap,
              nama_inggris: province.nama_inggris,
              jumlah_kursi: province.jumlah_kursi,
              jumlah_penduduk: province.jumlah_penduduk,
              pro_id: province.pro_id
            }
          end

        {
          results: {
            count: provinces.count,
            total: Province.where(conditions).count,
            provinsi: provinces
          }
        }
      end
    end
  end
end