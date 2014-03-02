class WeightedUndirectedGraph < WeightedGraph

  def add_edge(v, u, w)
    if edge_exists?(v, u)
      raise ArgumentError, "This edge already exists"
    elsif vertex_exists?(v) && vertex_exists?(u)
      ordered_vertices = order_vertices(v, u)
      self[ordered_vertices.first] << ordered_vertices.last
      weights[ordered_vertices] = w
    else
      raise ArgumentError, "One of the vertices referenced does not exist in the graph"
    end
  end

  def remove_edge(v, u)
    if edge_exists?(v, u)
      ordered_vertices = order_vertices(v, u)
      self[ordered_vertices.first].delete(ordered_vertices.last)
      remove_weight(v, u)
    else
      raise ArgumentError, "That edge does not exist in the graph"
    end
  end

  def adjust_weight(v, u, w)
    if edge_exists?(v, u)
      weights[[v,u]] = w
    else
      raise ArgumentError, "That edge does not exist in the graph"
    end
  end

  private

  def remove_weight(v, u)
    weights.delete(order_vertices(v, u))
  end
end
