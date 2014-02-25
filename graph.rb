require 'set'

# Undirected graph
# Vertices represented by strings
class Graph < Hash
  def vertices
    keys
  end

  def edges
    [].tap do |edge_constructor|
      vertices.each do |vertex|
        self[vertex].each do |neighbor|
          edge_constructor << [vertex, neighbor]
        end
      end
    end
  end

  def add_vertex(name)
    unless vertex_exists?(name)
      self[name] = []
    else
      raise ArgumentError, "Vertex already exists"
    end
  end

  def add_edge(first_vertex, second_vertex)
    if edge_exists?(first_vertex, second_vertex)
      raise ArgumentError, "This edge already exists"
    elsif vertex_exists?(first_vertex) && vertex_exists?(second_vertex)
      ordered_vertices = order_vertices(first_vertex, second_vertex)
      self[ordered_vertices.first] << ordered_vertices.last
    else
      raise ArgumentError, "One of the vertices referenced does not exist in the graph"
    end
  end

  def remove_vertex(name)
    if vertex_exists?(name)
      self.each_pair do |key, value|
        self[key].delete(name) if value.include?(name)
      end
      self.delete(name)
    else
      raise ArgumentError, "That vertex does not exist in the graph"
    end
  end

  def remove_edge(first_vertex, second_vertex)
    if edge_exists?(first_vertex, second_vertex)
      ordered_vertices = order_vertices(first_vertex, second_vertex)
      self[ordered_vertices.first].delete(ordered_vertices.last)
    else
      raise ArgumentError, "That edge does not exist in the graph"
    end
  end

  def edges_on_vertex(name)
    if vertex_exists?(name)
      edges.select { |edge| edge.include?(name) }
    else
      raise ArgumentError, "That vertex does not exist in the graph"
    end
  end

  def neighbors_of_vertex(name)
    if vertex_exists?(name)
      edges.select { |edge| edge.include? name }.map do |edge|
        if edge.first == name
          edge.last
        else
          edge.first
        end
      end
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

  def lexicographic_bfs
    sets = [vertices]
    output_vertices = []

    until sets.empty?
      v = sets.first.delete_at(0)
      sets.delete_at(0) if sets.first.empty?
      output_vertices << v
      replaced = []
      neighbors_of_vertex(v).each do |neighbor|
        s = sets.select{ |set| set.include?(neighbor) }.first
        if s
          if replaced.include?(s)
            t = sets[sets.find_index(s)-1]
          else
            t = []
            sets.insert(sets.find_index(s), t)
            replaced << s
          end
          s.delete(neighbor)
          t << neighbor
          sets.delete(s) if s.empty?
        end
      end
    end

    output_vertices
  end

  def clique?(vertex_list)
    clique = true
    vertex_list.each do |vertex|
      unless (neighbors_of_vertex(vertex) & vertex_list).to_set == (vertex_list - [vertex]).to_set
        clique = false
        break
      end
    end
    clique
  end

  def chordal?
    chordal = true
    (lexicographic_ordering = lexicographic_bfs.reverse).each_with_index do |v, i|
      successors_of_v = lexicographic_ordering[i, lexicographic_ordering.size]
      unless clique?([v] | (neighbors_of_vertex(v) & successors_of_v))
        chordal = false
        break
      end
    end
    chordal
  end
  alias_method :triangulated?, :chordal?

  private

  def order_vertices(first_vertex, second_vertex)
    [first_vertex, second_vertex].sort
  end
end
