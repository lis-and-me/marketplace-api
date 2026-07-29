puts "🌱 Iniciando seeds..."

ActiveRecord::Base.transaction do
  #
  # ADMIN
  #
  admin = User.find_or_initialize_by(email: "admin@test.com")

  admin.assign_attributes(
    name: "Administrador",
    last_name: "Sistema",
    password: "Password123",
    phone: "5551234567",
    role: :admin,
    status: :active
  )

  admin.save!

  Cart.find_or_create_by!(user: admin)

  puts "✅ Administrador listo"

  #
  # BRANDS
  #
[
  {
    name: "Nike",
    description: "Marca deportiva estadounidense."
  },
  {
    name: "Adidas",
    description: "Marca deportiva alemana."
  },
  {
    name: "Puma",
    description: "Marca deportiva internacional."
  }
].each do |brand|
  Brand.find_or_create_by!(name: brand[:name]) do |b|
    b.description = brand[:description]
    b.active = true
  end
end

  puts "✅ Marcas creadas"

  #
  # CATEGORIES
  #
[
  {
    name: "Calzado",
    description: "Zapatos deportivos y casuales."
  },
  {
    name: "Ropa",
    description: "Playeras, pantalones y sudaderas."
  },
  {
    name: "Accesorios",
    description: "Mochilas, gorras y artículos deportivos."
  }
].each do |category|
  Category.find_or_create_by!(name: category[:name]) do |c|
    c.description = category[:description]
    c.active = true
  end
end

  puts "✅ Categorías creadas"
end

puts "🎉 Seeds ejecutadas correctamente."