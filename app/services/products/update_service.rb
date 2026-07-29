module Products
  class UpdateService
    def self.call(product, params)
      new(product, params).call
    end

    def initialize(product, params)
      @product = product
      @params = params.to_h.deep_symbolize_keys
    end

    def call
      category_ids = @params.delete(:category_ids)

      Product.transaction do
        @product.update!(@params)

        replace_categories(category_ids) unless category_ids.nil?

        @product
      end
    end

    private

    def replace_categories(category_ids)
      categories = Category.where(id: category_ids)

      if categories.size != category_ids.size
        @product.errors.add(
          :categories,
          "contain invalid category ids"
        )

        raise ActiveRecord::RecordInvalid.new(@product)
      end

      @product.product_categories.destroy_all

      categories.each do |category|
        @product.product_categories.create!(
          category: category
        )
      end
    end
  end
end