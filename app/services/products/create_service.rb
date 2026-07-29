module Products
  class CreateService
    def self.call(params)
      new(params).call
    end

    def initialize(params)
      @params = params.to_h.deep_symbolize_keys
    end

    def call
      category_ids = @params.delete(:category_ids)

      Product.transaction do
        product = Product.create!(@params)

        attach_categories(product, category_ids)

        product
      end
    end

    private

    def attach_categories(product, category_ids)
      return if category_ids.blank?

      categories = Category.where(id: category_ids)

     if categories.size != category_ids.size
  product.errors.add(
    :categories,
    "contain invalid category ids"
  )

  raise ActiveRecord::RecordInvalid.new(product)
end

      categories.each do |category|
        product.product_categories.create!(
          category: category
        )
      end
    end
  end
end