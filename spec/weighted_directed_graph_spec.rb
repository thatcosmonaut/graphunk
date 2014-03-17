require 'spec_helper'

describe WeightedDirectedGraph do
  let(:graph) do
    WeightedDirectedGraph.new(
      {'a' => ['b','c','e'], 'b' => ['c', 'd'], 'c' => ['d'], 'd' => ['a'], 'e' => [] },
      {['a','b'] => 3, ['a','c'] => 6, ['a','e'] => 6, ['b','c'] => 2, ['b','d'] => 7, ['c','d'] => 3, ['d','a'] => 4}
    )
  end

  describe 'add_edge' do
    context 'vertices exist and edge does not exist' do
      before do
        graph.add_edge('b', 'e', 3)
      end

      it 'defines the edge' do
        expect(graph.edges).to include ['b','e']
      end

      it 'defines the weight' do
        expect(graph.weights).to include ['b','e'] => 3
      end
    end

    context 'one of the vertices does not exist' do
      it 'raises an ArgumentError' do
        expect{graph.add_edge('a','z',3)}.to raise_error ArgumentError
      end
    end

    context 'the edge already exists' do
      it 'raises an ArgumentError' do
        expect{graph.add_edge('a','b',3)}.to raise_error ArgumentError
      end
    end
  end

  describe 'remove_edge' do
    context 'the edge exists' do
      before do
        graph.remove_edge('a','b')
      end

      it 'removes edge' do
        expect(graph.edges).to_not include ['a','b']
      end

      it 'removes weight' do
        expect(graph.weights).to_not include ['a','b'] => 3
      end
    end

    context 'the edge does not exist' do
      it 'raises an ArgumentError' do
        expect{graph.remove_edge('y','z')}.to raise_error ArgumentError
      end
    end
  end

  describe 'edge_weight' do
    context 'the edge exists' do
      it 'returns the weight of the given edge' do
        expect(graph.edge_weight('a','b')).to eql 3
      end
    end

    context 'edge does not exist' do
      it 'raises an ArgumentError' do
        expect{graph.edge_weight('a','z')}.to raise_error ArgumentError
      end
    end
  end

  describe 'adjust_weight' do
    context 'the edge exists' do
      it 'adjusts the value of the weight' do
        graph.adjust_weight('a','b', 1)
        expect(graph.weights).to include ['a','b'] => 1
      end
    end

    context 'the edge does not exist' do
      it 'raises an ArgumentError' do
        expect{graph.adjust_weight('y','z',2)}.to raise_error ArgumentError
      end
    end
  end

  describe 'shortest_path_distance' do
    context 'start and end vertex exist' do
      it 'returns the shortest path distance' do
        expect(graph.shortest_path_distance('a','d')).to eql 8
      end
    end

    context 'start vertex does not exist' do
      it 'raises an ArgumentError' do
        expect{graph.shortest_path_distance('z','a')}.to raise_error ArgumentError
      end
    end

    context 'end vertex does not exist' do
      it 'raises an ArgumentError' do
        expect{graph.shortest_path_distance('a','z')}.to raise_error ArgumentError
      end
    end
  end

  describe 'shortest_path' do
    context 'start and end vertex exist' do
      it 'returns the shortest path' do
        expect(graph.shortest_path('a','d')).to eql ['a','b','c','d']
      end
    end

    context 'start vertex does not exist' do
      it 'raises an ArgumentError' do
        expect{graph.shortest_path('z','d')}.to raise_error ArgumentError
      end
    end

    context 'end vertex does not exist' do
      it 'raises an ArgumentError' do
        expect{graph.shortest_path('a','z')}.to raise_error ArgumentError
      end
    end
  end
end
