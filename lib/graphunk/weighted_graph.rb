#this class should not be invoked directly
class WeightedGraph < Graph

  attr_reader :weights

  def initialize(hash = {}, weights = {})
    @representation = hash
    @weights = weights
  end
end
