require 'graph'
class DirectedGraph < Graph
  def add_edge(first_vertex, second_vertex)
    if edge_exists?(first_vertex, second_vertex)
      raise ArgumentError, "This edge already exists"
    elsif vertex_exists?(first_vertex) && vertex_exists?(second_vertex)
      self[first_vertex] << second_vertex
    else
      raise ArgumentError, "One of the vertices referenced does not exist in the graph"
    end
  end

  def remove_edge(first_vertex, second_vertex)
    if edge_exists?(first_vertex, second_vertex)
      self[first_vertex].delete(second_vertex)
    else
      raise ArgumentError, "That edge does not exist in the graph"
    end
  end

  def neighbors_of_vertex(name)
    if vertex_exists?(name)
      self[name]
    else
      raise ArgumentError, "That vertex does not exist in the graph"
    end
  end

  def edge_exists?(first_vertex, second_vertex)
    edges.include?([first_vertex, second_vertex])
  end
end
