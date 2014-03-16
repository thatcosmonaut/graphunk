require 'set'

class UndirectedGraph < Graph
  def add_edge(first_vertex, second_vertex)
    if edge_exists?(first_vertex, second_vertex)
      raise ArgumentError, "This edge already exists"
    elsif vertex_exists?(first_vertex) && vertex_exists?(second_vertex)
      ordered_vertices = order_vertices(first_vertex, second_vertex)
      @representation[ordered_vertices.first] << ordered_vertices.last
    else
      raise ArgumentError, "One of the vertices referenced does not exist in the graph"
    end
  end

  def remove_edge(first_vertex, second_vertex)
    if edge_exists?(first_vertex, second_vertex)
      ordered_vertices = order_vertices(first_vertex, second_vertex)
      @representation[ordered_vertices.first].delete(ordered_vertices.last)
    else
      raise ArgumentError, "That edge does not exist in the graph"
    end
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
      unless (neighbors_of_vertex(vertex) & vertex_list).sort == (vertex_list - [vertex]).sort
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

  def complete?
    n = vertices.count
    edges.count == (n * (n-1) / 2)
  end

  def bipartite?
    colors = Hash.new
    d = Hash.new
    partition = Hash.new
    vertices.each do |vertex|
      colors[vertex] = "white"
      d[vertex] = Float::INFINITY
      partition[vertex] = 0
    end

    start = vertices.first
    colors[start] = "gray"
    partition[start] = 1
    d[start] = 0

    stack = []
    stack.push(start)

    until stack.empty?
      vertex = stack.pop
      neighbors_of_vertex(vertex).each do |neighbor|
        if partition[neighbor] == partition[vertex]
          return false
        else
          if colors[neighbor] == "white"
            colors[neighbor] == "gray"
            d[neighbor] = d[vertex] + 1
            partition[neighbor] = 3 - partition[vertex]
            stack.push(neighbor)
          end
        end
      end
      stack.pop
      colors[vertex] = "black"
    end

    true
  end
end
