require 'spec_helper'

describe DirectedGraph do
  let(:graph) { DirectedGraph['a' => ['b', 'c'], 'b' => ['a','d'], 'c' => [], 'd' => [] ] }

  describe 'vertices' do
    it 'returns a list of all vertices' do
      expect(graph.vertices).to match_array ['a','b','c','d']
    end
  end

  describe 'edges' do
    it' returns a list of all edges' do
      expect(graph.edges).to match_array [ ['a','b'], ['a','c'], ['b','a'], ['b','d'] ]
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
end
