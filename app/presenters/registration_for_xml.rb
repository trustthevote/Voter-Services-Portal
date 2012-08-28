class RegistrationForXML

  extend Forwardable

  def_delegators  :@r, :full_name, :first_name, :middle_name, :last_name, :suffix,
                  :er_street_number, :er_street_name, :er_street_type, :er_city,
                  :er_zip5, :er_zip4, :er_state,
                  :ssn, :created_at, :email, :phone, :dob, :gender,
                  :ca_type, :ca_po_box, :ca_city,
                  :vvr_street_number, :vvr_street_name, :vvr_street_type, :vvr_apt,
                  :vvr_town, :vvr_state, :vvr_state, :vvr_rural,
                  :mau_type, :mau_address, :mau_address_2, :mau_city, :mau_city_2,
                  :mau_state, :mau_postal_code, :mau_country,
                  :apo_address, :apo_address_2, :apo_1, :apo_2, :apo_zip5,
                  :has_existing_reg,
                  :er_street_number, :er_street_name, :er_street_type, :er_apt,
                  :er_city, :er_state, :er_zip5, :er_zip4, :er_is_rural, :er_rural,
                  :rights_restored_in, :rights_restored_on,
                  :ab_reason,
                  :residential?

  def initialize(r)
    @r = r
  end

  def has_existing_reg?
    @r.has_existing_reg == '1'
  end

  def previous_registration_thoroughfare
    return nil unless has_existing_reg?

    [ @r.er_street_number, @r.er_street_name, @r.er_street_type ].reject(&:blank?).join(' ')
  end

  def be_official?
    @r.be_official == '1'
  end

  def rights_revoked?
    @r.rights_revoked == '1'
  end

  def overseas?
    @r.uocava?
  end

  def military?
    false
  end

  def absentee_request?
    @r.requesting_absentee == '1'
  end

  def acp_request?
    @r.is_confidential_address == '1'
  end

  def felony?
    @r.rights_revoked_reason == 'felony'
  end

  def mental?
    @r.rights_revoked_reason == 'mental'
  end

  def ca_zip
    zip(@r.ca_zip5, @r.ca_zip4)
  end

  def vvr_is_rural?
    @r.vvr_is_rural == '1'
  end

  def vvr_thoroughfare
    rjoin([ @r.vvr_street_number, @r.vvr_street_name, @r.vvr_street_type ], ' ')
  end

  def er_is_rural?
    @r.er_is_rural == '1'
  end

  def er_thoroughfare
    rjoin([ @r.er_street_number, @r.er_street_name, @r.er_street_type ], ' ')
  end

  def vvr_zip
    zip(@r.vvr_zip5, @r.vvr_zip4)
  end

  def ma_is_same?
    @r.ma_is_same == '1'
  end

  def rights_restored?
    @r.rights_restored == '1'
  end

  def ab_info
    'TBD'
  end

  private

  def zip(z5, z4)
    rjoin([ z5, z4 ])
  end

  def rjoin(items, sep = '')
    items.reject(&:blank?).join(sep)
  end

end