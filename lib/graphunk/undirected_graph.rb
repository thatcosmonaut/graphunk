module Graphunk
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

    def degree(vertex)
      neighbors_of_vertex(vertex).count
    end

    def adjacent_edges?(first_edge, second_edge)
      adjacent_edges(first_edge).include? second_edge
    end

    def adjacent_edges(v, u)
      if edge_exists?(v, u)
        edges.select { |edge| edge.include?(v) || edge.include?(u) } - [[v,u]]
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
        successors_of_v = lexicographic_ordering[i..-1]
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

    def comparability?
      assign_orientation
    end

    def transitive_orientation
      assign_orientation(true)
    end

    private

    def assign_orientation(return_graph = false)
      transitive_orientation = Graphunk::DirectedGraph.new
      transitive_orientation.add_vertices(*vertices)

      unconsidered_edges = edges

      transitive = true

      until unconsidered_edges.empty?
        considered_edge = unconsidered_edges.first
        unconsidered_edges.delete(considered_edge)

        transitive_orientation.add_edge(considered_edge.first, considered_edge.last)

        explore = lambda do |edge|
          edge_set = false
          adjacent_edges(edge.first, edge.last).each do |adjacent_edge|
            next if unconsidered_edges.include? adjacent_edge

            shared_vertex = adjacent_edge.select { |vertex| edge.include? vertex }.first
            unshared_edge_vertex = edge.reject { |vertex| adjacent_edge.include? vertex }.first
            unshared_adjacent_edge_vertex = adjacent_edge.reject { |vertex| edge.include? vertex }.first

            unless edge_exists?(unshared_edge_vertex, unshared_adjacent_edge_vertex)
              if transitive_orientation.edge_exists?(shared_vertex, unshared_adjacent_edge_vertex)
                transitive = false if transitive_orientation.edge_exists?(unshared_edge_vertex, shared_vertex)
                transitive_orientation.add_edge(shared_vertex, unshared_edge_vertex) unless transitive_orientation.edge_exists?(shared_vertex, unshared_edge_vertex)
                unconsidered_edges.delete(order_vertices(shared_vertex, unshared_edge_vertex))
                edge_set = true
              else
                transitive = false if transitive_orientation.edge_exists?(shared_vertex, unshared_edge_vertex)
                transitive_orientation.add_edge(unshared_edge_vertex, shared_vertex) unless transitive_orientation.edge_exists?(unshared_edge_vertex, shared_vertex)
                unconsidered_edges.delete(order_vertices(shared_vertex, unshared_edge_vertex))
                edge_set = true
              end

            end
          end

          adjacent_edges(edge.first, edge.last).each { |neighbor| explore.call neighbor if unconsidered_edges.include? neighbor } if edge_set
        end

        adjacent_edges(considered_edge.first, considered_edge.last).each { |neighbor_edge| explore.call neighbor_edge }
      end

      if transitive && return_graph
        transitive_orientation
      else
        transitive
      end
    end

  end
end
