# this class should not be invoked directly
class Graph
  def initialize(hash = {})
    @representation = hash
  end

  def vertices
    @representation.keys
  end

  def edges
    [].tap do |edge_constructor|
      vertices.each do |vertex|
        @representation[vertex].each do |neighbor|
          edge_constructor << [vertex, neighbor]
        end
      end
    end
  end

  def add_vertex(name)
    unless vertex_exists?(name)
      @representation[name] = []
    else
      raise ArgumentError, "Vertex already exists"
    end
  end

  def remove_vertex(name)
    if vertex_exists?(name)
      edges.each do |edge|
        remove_edge(edge.first, edge.last) if edge.include?(name)
      end
      @representation.delete(name)
    else
      raise ArgumentError, "That vertex does not exist in the graph"
    end
  end

  def neighbors_of_vertex(name)
    if vertex_exists?(name)
      edges.select { |edge| edge.include? name }.map do |edge|
        edge.first == name ? edge.last : edge.first
      end
    else
      raise ArgumentError, "That vertex does not exist in the graph"
    end
  end

  def edges_on_vertex(name)
    if vertex_exists?(name)
      edges.select { |edge| edge.include?(name) }
    else
      raise ArgumentError, "That vertex does not exist in the graph"
    end
  end

  def edge_exists?(first_vertex, second_vertex)
    edges.include?(order_vertices(first_vertex, second_vertex))
  end

  def vertex_exists?(name)
    vertices.include?(name)
  end

  private

  def order_vertices(v, u)
    [v, u].sort
  end
end
