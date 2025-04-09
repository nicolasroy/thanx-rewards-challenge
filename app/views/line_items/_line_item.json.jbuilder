json.extract! line_item, :id, :itemizable_type, :itemizable_id, :created_at, :updated_at

if line_item.itemizable_type == "Reward"
  json.itemizable do
    json.partial! "rewards/reward", reward: line_item.itemizable
  end
end
