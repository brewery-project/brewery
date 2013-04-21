def find_or_create_role(identifier, params)
  unique_id = { authorizale_type: nil, authorizale_id: nil }.merge(identifier)
  r = Brewery::AuthCore::Role.where(identifier).first

  if r.nil?
    r = Brewery::AuthCore::Role.new(identifier)
  end
  r.update_attributes!(params)

  r
end

superadmin = find_or_create_role({ name: :superadmin }, { hidden: false })
admin_user = find_or_create_role({ name: :admin_user }, { hidden: false })