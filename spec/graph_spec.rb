require 'spec_helper'

describe Graph do
  let(:graph) { Graph['a' => ['b', 'c'], 'b' => ['c'], 'c' => []]}

  describe 'vertices' do
    it 'returns a list of all vertices' do
      expect(graph.vertices).to match_array ['a','b','c']
    end
  end

  describe 'edges' do
    it 'returns a list of all edges' do
      expect(graph.edges).to match_array [ ['a','b'], ['a','c'], ['b','c'] ]
    end
  end

  describe 'add_vertex' do
    it 'adds a vertex to the graph' do
      graph.add_vertex('d')
      expect(graph.vertices).to match_array ['a', 'b', 'c', 'd']
    end

    it 'raises error if it already exists' do
      expect{graph.add_vertex('a')}.to raise_error ArgumentError
    end
  end

  describe 'add_edge' do
    it 'adds an edge to the graph' do
      graph.add_vertex('d')
      graph.add_edge('c', 'd')
      expect(graph.edges).to match_array [ ['a','b'], ['a','c'], ['b','c'], ['c', 'd'] ]
    end

    it 'raises error if one of the vertices does not exist' do
      expect{graph.add_edge('a','d')}.to raise_error ArgumentError
    end
  end

  describe 'remove_edge' do
    it 'removes an edge from the graph' do
      graph.remove_edge('b', 'c')
      expect(graph.edges).to match_array [ ['a','b'], ['a','c'] ]
    end

    it 'raises error if one of the vertices does not exist' do
      expect{graph.remove_edge('c', 'd')}.to raise_error ArgumentError
    end

    it 'raises error if the edge does not exist' do
      graph.remove_edge('b', 'c')
      expect{graph.remove_edge('b', 'c')}.to raise_error ArgumentError
    end
  end

  describe 'remove_vertex' do
    it 'removes a vertex from the graph' do
      graph.remove_vertex('b')
      expect(graph.vertices).to match_array ['a','c']
    end

    it 'removes edges containing the vertex from the graph' do
      graph.remove_vertex('b')
      expect(graph.edges).to eql [['a','c']]
    end

    it 'raises error does not exist in the graph' do
      expect{graph.remove_vertex('f')}.to raise_error ArgumentError
    end
  end

  describe 'edges_on_vertex' do
    it 'returns a list of all edges containing the input vertex' do
      expect(graph.edges_on_vertex('a')).to match_array [ ['a','b'], ['a','c'] ]
    end

    it 'raises an error if the input vertex does not exist' do
      expect{graph.edges_on_vertex('d')}.to raise_error ArgumentError
    end
  end

  describe 'neighbors_of_vertex' do
    it 'returns a list of all neighbor vertices of the input vertex' do
      expect(graph.neighbors_of_vertex('a')).to match_array ['b', 'c']
    end

    it 'raises an error if the input vertex does not exist' do
      expect{graph.neighbors_of_vertex('d')}.to raise_error ArgumentError
    end
  end

  describe 'edge_exists?' do
    it 'returns true if the edge exists in the graph' do
      expect(graph.edge_exists?('a','b')).to eq true
    end

    it 'returns false if the edge does not exist in the graph' do
      graph.remove_edge('b','c')
      expect(graph.edge_exists?('b','c')).to eq false
    end

    it 'returns false if one of the input vertices does not exist' do
      expect(graph.edge_exists?('b', 'd')).to eq false
    end
  end

  describe 'vertex_exists?' do
    it 'returns true if the vertex exists in the graph' do
      expect(graph.vertex_exists?('a')).to eq true
    end

    it 'returns false if the vertex does not exist in the graph' do
      expect(graph.vertex_exists?('f')).to eq false
    end
  end

  describe 'lexicographic_bfs' do
    let(:graph) { Graph['a' => ['b','c'], 'b' => ['c', 'd', 'e'], 'c' => ['d'], 'd' => ['e'], 'e' => []] }

    it 'returns a lexicographic ordering on the graph' do
      expect(graph.lexicographic_bfs).to eq ['a','b','c','d','e']
    end
  end

  describe 'chordal?' do
    let(:graph) { Graph['a' => ['b','c'], 'b' => ['c', 'd', 'e'], 'c' => ['d'], 'd' => ['e'], 'e' => []] }

    it 'returns true if the graph is a chordal graph' do
      expect(graph.chordal?).to eq true
    end

    it 'returns false if the graph is not a chordal graph' do
      graph.remove_edge('b','c')
      expect(graph.chordal?).to eq false
    end
  end

  describe 'clique?' do
    let(:graph) { Graph['a' => ['b','c'], 'b' => ['c', 'd', 'e'], 'c' => ['d'], 'd' => ['e'], 'e' => []] }

    it 'returns true if the input vertices are a clique' do
      expect(graph.clique?(['a','b','c'])).to eq true
    end

    it 'returns false if the input vertices are not a clique' do
      expect(graph.clique?(['b','c','e'])).to eq false
    end
  end

  describe 'complete?' do
    it 'returns true if the graph is a complete graph' do
      graph = Graph['a' => ['b','c','d'], 'b' => ['c','d'], 'c' => ['d'], 'd' => [] ]
      expect(graph.complete?).to eq true
    end

    it 'returns false if the graph is not a complete graph' do
      graph = Graph['a' => ['b','c'], 'b' => ['d'], 'c' => [], 'd' => [] ]
      expect(graph.complete?).to eq false
    end
  end

  describe 'bipartite?' do
    it 'returns true if the graph is a bipartite graph' do
      graph = Graph['a' => ['b','c'], 'b' => ['d'], 'c' => ['e'], 'd' => [], 'e' => [] ]
      expect(graph.bipartite?).to eq true
    end

    it 'returns false if the graph is not bipartite graph' do
      expect(graph.bipartite?).to eq false
    end
  end

  describe 'order_vertices' do
    it 'returns input as sorted array' do
      expect(graph.send(:order_vertices, 'b', 'a')).to eq ['a','b']
    end
  end
end
