require 'spec_helper'

describe DirectedGraph do
  let(:graph) { DirectedGraph['a' => ['b', 'c'], 'b' => ['a','d'], 'c' => [], 'd' => [] ] }

  describe 'vertices' do
    it 'returns a list of all vertices' do
      expect(graph.vertices).to match_array ['a','b','c','d']
    end
  end

  describe 'edges' do
    it 'returns a list of all edges' do
      expect(graph.edges).to match_array [ ['a','b'], ['a','c'], ['b','a'], ['b','d'] ]
    end
  end

  describe 'add_vertex' do
    it 'adds a vertex to the graph' do
      graph.add_vertex('e')
      expect(graph.vertices).to match_array ['a','b','c','d','e']
    end

    it 'raises error if the vertex already exists' do
      expect{graph.add_vertex('a')}.to raise_error ArgumentError
    end
  end

  describe 'add_edge' do
    it 'adds an edge to the graph' do
      graph.add_edge('c', 'a')
      expect(graph.edges).to match_array [ ['a','b'], ['a','c'], ['b','a'], ['b','d'], ['c','a'] ]
    end

    it 'raises error if edge already exists' do
      expect{graph.add_edge('a','b')}.to raise_error ArgumentError
    end
  end

  describe 'remove_edge' do
    it 'removes an edge from the graph' do
      graph.remove_edge('a','b')
      expect(graph.edges).to match_array [ ['a','c'], ['b','a'], ['b','d'] ]
    end

    it 'raises error if edge does not exist' do
      expect{graph.remove_edge('a','d')}.to raise_error ArgumentError
    end
  end

  describe 'remove_vertex' do
    it 'removes a vertex from the graph' do
      graph.remove_vertex('b')
      expect(graph.vertices).to match_array ['a','c','d']
    end

    it 'remoevs edges containing the vertex from the graph' do
      graph.remove_vertex('b')
      expect(graph.edges).to match_array [ ['a','c'] ]
    end

    it 'raises error if the edge does not exist' do
      expect{graph.remove_edge('d','e')}.to raise_error ArgumentError
    end
  end

  describe 'edges_on_vertex' do
    it 'returns a list of all edges containing the input vertex' do
      expect(graph.edges_on_vertex('a')).to match_array [ ['a','b'], ['a','c'], ['b', 'a'] ]
    end

    it 'raises an error if the input vertex does not exist' do
      expect{graph.edges_on_vertex('z')}.to raise_error ArgumentError
    end
  end

  describe 'neighbors_of_vertex' do
    it 'returns a list containing the neighbors of the given vertex' do
      expect(graph.neighbors_of_vertex('a')).to match_array ['b','c']
    end

    it 'raises an error the the given vertex does not exist' do
      expect{graph.neighbors_of_vertex('e')}.to raise_error ArgumentError
    end
  end

  describe 'edge_exists?' do
    it 'returns true if the edge exists' do
      expect(graph.edge_exists?('a','b')).to eql true
    end

    it 'returns false if the edge does not exist' do
      expect(graph.edge_exists?('a','d')).to eql false
    end
  end

  describe 'vertex_exists?' do
    it 'returns true if the vertex exists' do
      expect(graph.vertex_exists?('a')).to eql true
    end

    it 'returns false if the vertex does not exist' do
      expect(graph.vertex_exists?('t')).to eql false
    end
  end

  describe 'transpose' do
    it 'returns a graph which is the transpose of the current graph' do
      expect(graph.transpose.edges).to match_array [ ['a','b'], ['b', 'a'], ['c','a'], ['d', 'b'] ]
    end
  end

  describe 'tranpose!' do
    it 'tranposes the graph in-place' do
      graph.transpose!
      expect(graph.edges).to match_array [ ['a','b'], ['b', 'a'], ['c','a'], ['d', 'b'] ]
    end
  end

  describe 'reachable_by_two_path' do
    it 'returns a list of all vertices reachable from the input vertex with a 2-path' do
      graph.add_vertex('e')
      expect(graph.reachable_by_two_path('a')).to match_array ['a','b','c','d']
    end

    it 'raises an error if the input vertex does not exist' do
      expect{graph.reachable_by_two_path('z')}.to raise_error ArgumentError
    end
  end

  describe 'square' do
    it 'returns a graph which is the square of the graph' do
      expect(graph.square.edges).to match_array [ ['a','b'], ['a','c'], ['b','a'], ['b','c'], ['b','d'], ['a','d'] ]
    end
  end

  describe 'dfs' do
    it 'returns a hash containing depth-first start and finish times for each vertex' do
      graph = DirectedGraph['a' => ['b', 'c'], 'b' => ['d'], 'c' => [], 'd' => [] ]
      result = { 'a' => { start: 1, finish: 8 }, 'b' => { start: 2, finish: 5 }, 'c' => { start: 6, finish: 7 }, 'd' => { start: 3, finish: 4 } }
      expect(graph.dfs).to eql result
    end
  end

  describe 'topological sort' do
    context 'connected graph' do
      it 'returns a valid topological ordering on the graph' do
        expect(graph.topological_sort).to eq [ 'a','c','b','d' ]
      end
    end

    context 'unconnected graph' do
      it 'returns a valid topological ordering on the graph' do
        graph = DirectedGraph[ 'a' => ['b','c','d'], 'b' => ['f', 'g'], 'c' => ['g'], 'd' => [], 'e' => ['t'], 'f' => [], 'g' => [], 't' => ['m'], 'm' => [] ]
        expect(graph.topological_sort).to eq [ 'e', 't', 'm', 'a', 'd', 'c', 'b', 'g', 'f' ]
      end
    end
  end
end
