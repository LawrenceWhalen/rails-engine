class MerchantRev
  attr_reader :id, :revenue

  def initialize(attributes)
    @id = attributes[:id]
    @revenue = attributes[:revenue]
  end
end