#this class should not be invoked directly
class WeightedGraph < Graph

  attr_accessor :weights

  def initialize
    super
    @weights = {}
  end
end
