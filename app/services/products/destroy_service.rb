module Products
  class DestroyService
    def self.call(product)
      new(product).call
    end

    def initialize(product)
      @product = product
    end

    def call
      @product.destroy!
    end
  end
end