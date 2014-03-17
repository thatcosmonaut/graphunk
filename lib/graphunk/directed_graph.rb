module Graphunk
  class DirectedGraph < Graph
    def add_edge(first_vertex, second_vertex)
      if edge_exists?(first_vertex, second_vertex)
        raise ArgumentError, "This edge already exists"
      elsif vertex_exists?(first_vertex) && vertex_exists?(second_vertex)
        @representation[first_vertex] << second_vertex
      else
        raise ArgumentError, "One of the vertices referenced does not exist in the graph"
      end
    end

    def remove_edge(first_vertex, second_vertex)
      if edge_exists?(first_vertex, second_vertex)
        @representation[first_vertex].delete(second_vertex)
      else
        raise ArgumentError, "That edge does not exist in the graph"
      end
    end

    def neighbors_of_vertex(name)
      if vertex_exists?(name)
        @representation[name]
      else
        raise ArgumentError, "That vertex does not exist in the graph"
      end
    end

    def edge_exists?(first_vertex, second_vertex)
      edges.include?([first_vertex, second_vertex])
    end

    def transpose
      graph = DirectedGraph.new
      vertices.each do |vertex|
        graph.add_vertex(vertex)
      end
      edges.each do |edge|
        graph.add_edge(edge.last, edge.first)
      end
      graph
    end

    def transpose!
      reversed_edges = []
      edges.each do |edge|
        remove_edge(edge.first, edge.last)
        reversed_edges << [edge.last, edge.first]
      end
      reversed_edges.each do |edge|
        add_edge(edge.first, edge.last)
      end
    end

    def reachable_by_two_path(start)
      if vertex_exists?(start)
        reached_vertices = @representation[start]
        reached_vertices.each do |vertex|
          reached_vertices += @representation[vertex]
        end
        reached_vertices.uniq
      else
        raise ArgumentError, "That vertex does not exist in the graph"
      end
    end

    def square
      graph = self.clone

      vertices.each do |vertex|
        (reachable_by_two_path(vertex) - [vertex]).each do |reachable|
          graph.add_edge(vertex, reachable) unless edge_exists?(vertex, reachable)
        end
      end

      graph
    end

    def dfs
      discovered = []
      time = 0
      output = {}
      vertices.each { |vertex| output[vertex] = {} }

      dfs_helper = lambda do |u| #only u can do u, so do it!
        discovered << u
        time += 1
        output[u][:start] = time

        neighbors_of_vertex(u).each do |neighbor|
          dfs_helper.call neighbor unless discovered.include?(neighbor)
        end

        time += 1
        output[u][:finish] = time
      end

      vertices.each do |vertex|
        dfs_helper.call vertex unless discovered.include?(vertex)
      end

      output
    end

    def topological_sort
      dfs.sort_by { |vertex, times| times[:finish] }.map(&:first).reverse
    end
  end
end
