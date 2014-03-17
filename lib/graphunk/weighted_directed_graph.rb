module Graphunk
  class WeightedDirectedGraph < WeightedGraph

    def add_edge(v, u, w)
      if edge_exists?(v, u)
        raise ArgumentError, "This edge already exists"
      elsif vertex_exists?(v) && vertex_exists?(u)
        @representation[v] << u
        @weights[[v,u]] = w
      else
        raise ArgumentError, "One of the vertices referenced does not exist in the graph"
      end
    end

    def remove_edge(v, u)
      if edge_exists?(v, u)
        @representation[v].delete(u)
        @weights.delete([v,u])
      else
        raise ArgumentError, "That edge does not exist in the graph"
      end
    end

    def edge_weight(v, u)
      if edge_exists?(v,u)
        @weights[[v,u]]
      else
        raise ArgumentError, "That edge does not exist in the graph"
      end
    end

    def adjust_weight(v, u, w)
      if edge_exists?(v, u)
        @weights[[v,u]] = w
      else
        raise ArgumentError, "That edge does not exist in the graph"
      end
    end

    def neighbors_of_vertex(v)
      if vertex_exists?(v)
        @representation[v]
      else
        raise ArgumentError, "That vertex does not exist in the graph"
      end
    end

    def shortest_path_distance(v, u)
      if vertex_exists?(u)
        single_source_shortest_path_distances(v)[u]
      else
        raise ArgumentError, "A specified vertex does not exist in the graph"
      end
    end

    def shortest_path(v, u)
      if vertex_exists?(u)
        [].tap do |s|
          previous = single_source_shortest_path_previous(v)
          while previous[u]
            s.insert(0, u)
            u = previous[u]
          end
          s.insert(0, v)
        end
      else
        raise ArgumentError, "A specified vertex does not exist in the graph"
      end
    end

    private

    # Dijsktra's Algorithm
    def single_source_shortest_path(source)
      raise ArgumentError, "A specified vertex does not exist in the graph" unless vertex_exists?(source)

      distance = {}
      previous = {}
      vertices.each do |vertex|
        distance[vertex] = Float::INFINITY
        previous[vertex] = nil
      end

      distance[source] = 0
      q = vertices

      until q.empty?
        u = q.delete(q.min_by { |vertex| distance[vertex] })
        break if distance[u] == Float::INFINITY

        neighbors_of_vertex(u).each do |v|
          alt = distance[u] + edge_weight(u, v)
          if alt < distance[v]
            distance[v] = alt
            previous[v] = u
          end
        end
      end

      {distance: distance, previous: previous}
    end

    def single_source_shortest_path_distances(source)
      single_source_shortest_path(source)[:distance]
    end

    def single_source_shortest_path_previous(source)
      single_source_shortest_path(source)[:previous]
    end

    def edge_exists?(v, u)
      edges.include?([v,u])
    end

  end
end
