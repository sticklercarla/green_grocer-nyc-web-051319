require "pry"

def consolidate_cart(cart)
  cart.each_with_object({}) do |item, hash|
    item.each do |category, info|
      if hash[category]
        info[:count] +=1
      else
        info[:count] = 1
        hash[category] = info 
      end
    end
  end
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    name = coupon[:item]
    if cart[name] && cart[name][:count] >= coupon[:num]
      if cart["#{name} W/COUPON"]
        cart["#{name} W/COUPON"][:count] += 1
      else
        cart["#{name} W/COUPON"] = {:count => 1, :price => coupon[:cost]}
        cart["#{name} W/COUPON"][:clearance] = cart[name][:clearance]
      end
      cart[name][:count] -= coupon[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, item_hash|
    if item_hash[:clearance]
      new_price = item_hash[:price] * 0.80
      item_hash[:price] = new_price.round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  new_cart = consolidate_cart(cart)
  cart_w_coupons = apply_coupons(new_cart, coupons)
  clearance_cart = apply_clearance(cart_w_coupons)
  cart_total = 0
  clearance_cart.each do |item, item_hash|
    cart_total += item_hash[:price] * item_hash[:count]
  end
  if cart_total >= 100
    total_with_discount = cart_total * 0.90
    total_with_discount
  else
    cart_total
  end
end

