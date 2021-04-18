ActiveAdmin.register Product do

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :style
    column :brand
    column :type
    column :shipping_price_cents
    column :user
    column :note
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
      product = Product.where(id: row['id']).first

      product ||= Product.new id: row['id']

      product.name = row['product_name']
      product.description = row['description']
      product.style = row['style']
      product.brand = row['brand']
      product.type = row['product_type']
      product.created_at = Time.find_zone('UTC').parse(row['created_at'])
      product.updated_at = Time.find_zone('UTC').parse(row['updated_at'])
      product.url = row['url']
      product.shipping_price_cents = row['shipping_price']
      product.note = row['note']
      product.user = User.find(row['admin_id'])
      
      product.save
    end

    redirect_to :action => :index, :notice => "CSV imported successfully!"
  end
  
end
