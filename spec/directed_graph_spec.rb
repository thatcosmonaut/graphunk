require 'spec_helper'

describe Graphunk::DirectedGraph do
  let(:graph) { Graphunk::DirectedGraph.new({'a' => ['b', 'c'], 'b' => ['a','d'], 'c' => [], 'd' => [] }) }

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
    context 'vertex does not exist' do
      it 'adds a vertex to the graph' do
        graph.add_vertex('e')
        expect(graph.vertices).to match_array ['a','b','c','d','e']
      end
    end

    context 'vertex already exists' do
      it 'raises an ArgumentError' do
        expect{graph.add_vertex('a')}.to raise_error ArgumentError
      end
    end
  end

  describe 'add_vertices' do
    context 'vertices do not exist' do
      it 'adds the vertices to the graph' do
        graph.add_vertices('g','h','i')
        expect(graph.vertices).to match_array ['a','b','c','d','g','h','i']
      end
    end

    context 'one of the vertices exists in the graph' do
      it 'raises an ArgumentError' do
        expect{graph.add_vertices('g','h','a')}.to raise_error ArgumentError
      end
    end
  end

  describe 'add_edge' do
    context 'edge does not exist' do
      it 'adds an edge to the graph' do
        graph.add_edge('c', 'a')
        expect(graph.edges).to match_array [ ['a','b'], ['a','c'], ['b','a'], ['b','d'], ['c','a'] ]
      end
    end

    context 'edge already exists' do
      it 'raises an ArgumentError' do
        expect{graph.add_edge('a','b')}.to raise_error ArgumentError
      end
    end
  end

  describe 'remove_edge' do
    context 'edge exists' do
      it 'removes an edge from the graph' do
        graph.remove_edge('a','b')
        expect(graph.edges).to match_array [ ['a','c'], ['b','a'], ['b','d'] ]
      end
    end

    context 'edge does not exist' do
      it 'raises an ArgumentError' do
        expect{graph.remove_edge('a','d')}.to raise_error ArgumentError
      end
    end
  end

  describe 'remove_vertex' do
    context 'vertex exists' do
      before do
        graph.remove_vertex('b')
      end

      it 'removes a vertex from the graph' do
        expect(graph.vertices).to match_array ['a','c','d']
      end

      it 'removes edges containing the vertex from the graph' do
        expect(graph.edges).to match_array [ ['a','c'] ]
      end
    end

    context 'vertex does not exist' do
      it 'raises an ArgumentError' do
        expect{graph.remove_edge('d','e')}.to raise_error ArgumentError
      end
    end
  end

  describe 'edges_on_vertex' do
    context 'vertex exists' do
      it 'returns a list of all edges containing the input vertex' do
        expect(graph.edges_on_vertex('a')).to match_array [ ['a','b'], ['a','c'], ['b', 'a'] ]
      end
    end

    context 'vertex does not exist' do
      it 'raises an ArgumentError' do
        expect{graph.edges_on_vertex('z')}.to raise_error ArgumentError
      end
    end
  end

  describe 'neighbors_of_vertex' do
    context 'vertex exists' do
      it 'returns a list containing the neighbors of the given vertex' do
        expect(graph.neighbors_of_vertex('a')).to match_array ['b','c']
      end
    end

    context 'vertex does not exist' do
      it 'raises an ArgumentError' do
        expect{graph.neighbors_of_vertex('e')}.to raise_error ArgumentError
      end
    end
  end

  describe 'edge_exists?' do
    context 'edge exists' do
      it 'returns true' do
        expect(graph.edge_exists?('a','b')).to eql true
      end
    end

    context 'edge does not exist' do
      it 'returns false' do
        expect(graph.edge_exists?('a','d')).to eql false
      end
    end
  end

  describe 'vertex_exists?' do
    context 'vertex exists' do
      it 'returns true' do
        expect(graph.vertex_exists?('a')).to eql true
      end
    end

    context 'vertex does not exist' do
      it 'returns false' do
        expect(graph.vertex_exists?('t')).to eql false
      end
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
    context 'vertex exists' do
      it 'returns a list of all vertices reachable from the input vertex with a 2-path' do
        graph.add_vertex('e')
        expect(graph.reachable_by_two_path('a')).to match_array ['a','b','c','d']
      end
    end

    context 'vertex does not exist' do
      it 'raises an ArgumentError' do
        expect{graph.reachable_by_two_path('z')}.to raise_error ArgumentError
      end
    end
  end

  describe 'square' do
    it 'returns a graph which is the square of the graph' do
      expect(graph.square.edges).to match_array [ ['a','b'], ['a','c'], ['b','a'], ['b','c'], ['b','d'], ['a','d'] ]
    end
  end

  describe 'dfs' do
    it 'returns a hash containing depth-first start and finish times for each vertex' do
      graph = Graphunk::DirectedGraph.new({'a' => ['b', 'c'], 'b' => ['d'], 'c' => [], 'd' => [] })
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
        graph = Graphunk::DirectedGraph.new({ 'a' => ['b','c','d'], 'b' => ['f', 'g'], 'c' => ['g'], 'd' => [], 'e' => ['t'], 'f' => [], 'g' => [], 't' => ['m'], 'm' => [] })
        expect(graph.topological_sort).to eq [ 'e', 't', 'm', 'a', 'd', 'c', 'b', 'g', 'f' ]
      end
    end
  end

  describe 'transitive?' do
    context 'the orientation is transitive' do
      let(:graph) { Graphunk::DirectedGraph.new({'a' => ['b','g'], 'b' => [], 'c' => ['d'], 'd' => [], 'e' => ['d'], 'f' => ['d','e','g'], 'g' => []}) }

      it 'returns true' do
        expect(graph.transitive?).to eql true
      end
    end

    context 'the orientation is not transitive' do
      let(:graph) { Graphunk::DirectedGraph.new({'a' => ['b'], 'b' => ['c'], 'c' => ['d'], 'd' => ['e'], 'e' => ['f'], 'f' => ['g'], 'g' => ['a']}) }

      it 'returns false' do
        expect(graph.transitive?).to eql false
      end
    end
  end
end
