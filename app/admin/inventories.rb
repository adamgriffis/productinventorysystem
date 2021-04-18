ActiveAdmin.register Inventory do

  index do
    selectable_column
    id_column
    column :product
    column :quanitty
    column :sku
    column :color
    column :size
    column :price_cents
    column :sale_price_cents
    column :cost_cents
    column :weight
    column :length
    column :height
    column :width
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
      inv = Inventory.where(id: row['id']).first

      inv ||= Inventory.new id: row['id']

      inv.quantity = row['quantity']
      inv.color = row['color']
      inv.size = row['size']
      inv.weight = row['weight']
      inv.price_cents = row['price_cents']
      inv.sale_price_cents = row['sale_price_cents']
      inv.length = row['length']
      inv.width = row['width']
      inv.height = row['height']
      inv.note = row['note']
      inv.product = Product.find(row['product_id'])
      inv.user = inv.product.user
      
      inv.save!
    end

    redirect_to :action => :index, :notice => "CSV imported successfully!"
  end
  
end
