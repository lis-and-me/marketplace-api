module Ai
  class CustomerContextService
    def self.call
      new.call
    end

    def call
      {
        generated_at: Time.current,
        products: products,
        categories: categories,
        brands: brands
      }
    end

    private

    def products
      Product
        .where(active: true)
        .includes(:brand, :categories)
        .limit(100)
        .map do |product|
          {
            id: product.id,
            name: product.name,
            description: product.description,
            price: product.price,
            stock: product.stock,
            average_rating: product.average_rating,
            reviews_count: product.reviews_count,
            brand: product.brand&.name,
            categories: product.categories.pluck(:name)
          }
        end
    end

    def categories
      Category.order(:name).pluck(:name)
    end

    def brands
      Brand.order(:name).pluck(:name)
    end
  end
end