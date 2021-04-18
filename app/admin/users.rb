ActiveAdmin.register User do

  index do
    selectable_column
    id_column
    column :email
    column :shop_domain
    column :shop_name
    column :card_brand
    column :last_4
    column :trial_starts_at
    column :trial_ends_at
    column :enabled
    column :superadmin
    column :billing_plan
    actions
  end

  action_item :only => :index do
    link_to 'Upload CSV', :action => 'upload_csv'
  end

  collection_action :upload_csv do
    render "admin/csv/upload_csv"
  end

  collection_action :import_csv, :method => :post do
    csv_data = params[:dump][:file]
    csv_file = csv_data.read

    CSV.parse(csv_file, headers: true) do |row|
      user = User.where(id: row['id']).first

      user ||= User.new id: row['id']

      user.name = row['name']
      user.email = row['email']
      user.password = row['password_plain']
      user.password_confirmation = row['password_plain']
      user.shop_name = row['shop_name']
      user.superadmin = row['superadmin']
      user.enabled = row['is_enabled']
      user.last_4 = row['card_last_four']
      user.card_brand = row['card_brand']
      user.created_at = Time.find_zone('UTC').parse(row['created_at'])
      user.updated_at = Time.find_zone('UTC').parse(row['updated_at'])
      user.trial_starts_at = Time.find_zone('UTC').parse(row['trial_starts_at'])
      user.trial_ends_at = Time.find_zone('UTC').parse(row['trial_ends_at'])
      user.shop_domain = row['shop_domain']
      user.billing_plan = row['billing_plan']

      user.save
    end

    redirect_to :action => :index, :notice => "CSV imported successfully!"
  end
  
end
