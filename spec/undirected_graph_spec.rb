require 'spec_helper'

describe UndirectedGraph do
  let(:graph) { UndirectedGraph.new({'a' => ['b', 'c'], 'b' => ['c'], 'c' => [] }) }

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
    context 'vertex does not exist' do
      it 'adds a vertex to the graph' do
        graph.add_vertex('d')
        expect(graph.vertices).to match_array ['a', 'b', 'c', 'd']
      end
    end

    context 'vertex exists' do
      it 'raises an ArgumentError' do
        expect{graph.add_vertex('a')}.to raise_error ArgumentError
      end
    end
  end

  describe 'add_vertices' do
    context 'vertices do not exist' do
      it 'adds the vertices to the graph' do
        graph.add_vertices('g','h','i')
        expect(graph.vertices).to match_array ['a','b','c','g','h','i']
      end
    end

    context 'one of the vertices exists in the graph' do
      it 'raises an ArgumentError' do
        expect{graph.add_vertices('g','h','a')}.to raise_error ArgumentError
      end
    end
  end

  describe 'add_edge' do
    context 'vertices exist' do
      it 'adds an edge to the graph' do
        graph.add_vertex('d')
        graph.add_edge('c', 'd')
        expect(graph.edges).to match_array [ ['a','b'], ['a','c'], ['b','c'], ['c', 'd'] ]
      end
    end

    context 'one of the vertices does not exist' do
      it 'raises an ArgumentError' do
        expect{graph.add_edge('a','d')}.to raise_error ArgumentError
      end
    end
  end

  describe 'remove_edge' do
    context 'edge exists' do
      it 'removes an edge from the graph' do
        graph.remove_edge('b', 'c')
        expect(graph.edges).to match_array [ ['a','b'], ['a','c'] ]
      end
    end

    context 'one of the vertices does not exist' do
      it 'raises an ArgumentError' do
        expect{graph.remove_edge('c', 'd')}.to raise_error ArgumentError
      end
    end

    context 'edge does not exist' do
      it 'raises an ArgumentError' do
        graph.remove_edge('b', 'c')
        expect{graph.remove_edge('b', 'c')}.to raise_error ArgumentError
      end
    end
  end

  describe 'remove_vertex' do
    context 'vertex exists' do

      before do
        graph.remove_vertex('b')
      end

      it 'removes a vertex from the graph' do
        expect(graph.vertices).to match_array ['a','c']
      end

      it 'removes edges containing the vertex from the graph' do
        expect(graph.edges).to eql [['a','c']]
      end
    end

    context 'vertex does not exist' do
      it 'raises an ArgumentError' do
        expect{graph.remove_vertex('f')}.to raise_error ArgumentError
      end
    end
  end

  describe 'edges_on_vertex' do
    context 'vertex exists' do
      it 'returns a list of all edges containing the input vertex' do
        expect(graph.edges_on_vertex('a')).to match_array [ ['a','b'], ['a','c'] ]
      end
    end

    context 'vertex does not exist' do
      it 'raises an ArgumentError' do
        expect{graph.edges_on_vertex('d')}.to raise_error ArgumentError
      end
    end
  end

  describe 'neighbors_of_vertex' do
    context 'vertex exists' do
      it 'returns a list of all neighbor vertices of the input vertex' do
        expect(graph.neighbors_of_vertex('a')).to match_array ['b', 'c']
      end
    end

    context 'vertex does not exist' do
      it 'raises an error if the input vertex does not exist' do
        expect{graph.neighbors_of_vertex('d')}.to raise_error ArgumentError
      end
    end
  end

  describe 'edge_exists?' do
    context 'edge exists' do
      it 'returns true' do
        expect(graph.edge_exists?('a','b')).to eq true
      end
    end

    context 'edge does not exist' do
      it 'returns false' do
        graph.remove_edge('b','c')
        expect(graph.edge_exists?('b','c')).to eq false
      end
    end

    context 'an input vertex does not exist' do
      it 'returns false' do
        expect(graph.edge_exists?('b', 'd')).to eq false
      end
    end
  end

  describe 'vertex_exists?' do
    context 'vertex exists' do
      it 'returns true' do
        expect(graph.vertex_exists?('a')).to eq true
      end
    end

    context 'vertex does not exist' do
      it 'returns false' do
        expect(graph.vertex_exists?('f')).to eq false
      end
    end
  end

  describe 'lexicographic_bfs' do
    let(:graph) { UndirectedGraph.new({'a' => ['b','c'], 'b' => ['c', 'd', 'e'], 'c' => ['d'], 'd' => ['e'], 'e' => []}) }

    it 'returns a lexicographic ordering on the graph' do
      expect(graph.lexicographic_bfs).to eq ['a','b','c','d','e']
    end
  end

  describe 'chordal?' do
    let(:graph) { UndirectedGraph.new({'a' => ['b','c'], 'b' => ['c', 'd', 'e'], 'c' => ['d'], 'd' => ['e'], 'e' => []}) }

    context 'graph is chordal' do
      it 'returns true' do
        expect(graph.chordal?).to eq true
      end
    end

    context 'graph is not chordal' do
      it 'returns false' do
        graph.remove_edge('b','c')
        expect(graph.chordal?).to eq false
      end
    end
  end

  describe 'clique?' do
    let(:graph) { UndirectedGraph.new({'a' => ['b','c'], 'b' => ['c', 'd', 'e'], 'c' => ['d'], 'd' => ['e'], 'e' => [] }) }

    context 'input vertices are a clique' do
      it 'returns true' do
        expect(graph.clique?(['a','b','c'])).to eq true
      end
    end

    context 'input vertices are not a clique' do
      it 'returns false' do
        expect(graph.clique?(['b','c','e'])).to eq false
      end
    end
  end

  describe 'complete?' do
    context 'graph is complete' do
      it 'returns true' do
        graph = UndirectedGraph.new({'a' => ['b','c','d'], 'b' => ['c','d'], 'c' => ['d'], 'd' => [] })
        expect(graph.complete?).to eq true
      end
    end

    context 'graph is not complete' do
      it 'returns false' do
        graph = UndirectedGraph.new({'a' => ['b','c'], 'b' => ['d'], 'c' => [], 'd' => [] })
        expect(graph.complete?).to eq false
      end
    end
  end

  describe 'bipartite?' do
    context 'graph is bipartite' do
      it 'returns true' do
        graph = UndirectedGraph.new({'a' => ['b','c'], 'b' => ['d'], 'c' => ['e'], 'd' => [], 'e' => [] })
        expect(graph.bipartite?).to eq true
      end
    end

    context 'graph is not bipartite' do
      it 'returns false' do
        expect(graph.bipartite?).to eq false
      end
    end
  end

  describe 'order_vertices' do
    it 'returns input as sorted array' do
      expect(graph.send(:order_vertices, 'b', 'a')).to eq ['a','b']
    end
  end
end
