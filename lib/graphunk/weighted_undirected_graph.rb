class WeightedUndirectedGraph < WeightedGraph

  def add_edge(v, u, w)
    if edge_exists?(v, u)
      raise ArgumentError, "This edge already exists"
    elsif vertex_exists?(v) && vertex_exists?(u)
      ordered_vertices = order_vertices(v, u)
      @representation[ordered_vertices.first] << ordered_vertices.last
      @weights[ordered_vertices] = w
    else
      raise ArgumentError, "One of the vertices referenced does not exist in the graph"
    end
  end

  def remove_edge(v, u)
    if edge_exists?(v, u)
      ordered_vertices = order_vertices(v, u)
      @representation[ordered_vertices.first].delete(ordered_vertices.last)
      remove_weight(v, u)
    else
      raise ArgumentError, "That edge does not exist in the graph"
    end
  end

  def edge_weight(v, u)
    if edge_exists?(v,u)
      @weights[order_vertices(v,u)]
    else
      raise ArgumentError, "That edge does not exist in the graph"
    end
  end

  def adjust_weight(v, u, w)
    if edge_exists?(v, u)
      @weights[order_vertices(v,u)] = w
    else
      raise ArgumentError, "That edge does not exist in the graph"
    end
  end

  # Prim's Algorithm
  def minimum_spanning_tree
    forest = WeightedUndirectedGraph.new
    forest.add_vertex(vertices.first)
    until forest.vertices.sort == vertices.sort
      minimum_edge = edges_to_examine(forest.vertices).min_by { |edge| weights[edge] }
      vertex_to_add = forest.vertices.include?(minimum_edge.first) ? minimum_edge.last : minimum_edge.first
      forest.add_vertex(vertex_to_add)
      forest.add_edge(minimum_edge.first, minimum_edge.last, weights[minimum_edge])
    end
    forest
  end

  private

  def edges_to_examine(vertices)
    [].tap do |examinable|
      edges.each do |edge|
        examinable << edge if (edge & vertices).count == 1
      end
    end
  end

  def remove_weight(v, u)
    @weights.delete(order_vertices(v, u))
  end
end
