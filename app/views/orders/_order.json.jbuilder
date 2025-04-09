json.extract! order, :id, :line_items_id, :created_at, :updated_at
json.url order_url(order, format: :json)
json.array! order.line_items, partial: "line_items/line_item", as: :line_item
