require 'spec_helper'

describe WeightedUndirectedGraph do
  let(:graph) do
    graph = WeightedUndirectedGraph['a' => ['b', 'c'], 'b' => ['c', 'd'], 'c' => [], 'd' => [] ]
    graph.weights = { ['a','b'] => 2, ['a','c'] => 4, ['b','c'] => 8, ['b','d'] => 5 }
    graph
  end

  describe 'remove_vertex' do
    context 'the vertex exists' do
      before do
        graph.remove_vertex('c')
      end

      it 'removes edges' do
        expect(graph.edges).to match_array [ ['a','b'], ['b','d'] ]
      end

      it 'removes vertices' do
        expect(graph.vertices).to match_array ['a','b','d']
      end

      it 'removes weights' do
        expect(graph.weights).to_not include [['a','c'], ['b','c']]
      end
    end

    context 'the vertex does not exist' do
      it 'raises an ArgumentError' do
        expect{graph.remove_vertex('f')}.to raise_error ArgumentError
      end
    end
  end

  describe 'remove_edge' do
    context 'the edge exists' do
      before do
        graph.remove_edge('a','b')
      end

      it 'removes edge' do
        expect(graph.edges).to match_array [ ['a','c'], ['b','c'], ['b','d'] ]
      end

      it 'removes weight' do
        expect(graph.weights).to_not include ['a','b']
      end
    end

    context 'the edge does not exist' do
      it 'raises an ArgumentError' do
        expect{graph.remove_edge('f','z')}.to raise_error ArgumentError
      end
    end
  end

  describe 'add_edge' do
    context 'vertices exist and edge does not exist' do
      before do
        graph.add_edge('a','d',6)
      end

      it 'defines the weight' do
        expect(graph.weights).to include ['a','d'] => 6
      end

      it 'defines the edge' do
        expect(graph.edges).to include ['a','d']
      end
    end

    context 'one of the vertices does not exist' do
      it 'raises an ArgumentError' do
        expect{graph.add_edge('a','e',4)}.to raise_error ArgumentError
      end
    end

    context 'the edge already exists' do
      it 'raises an ArgumentError' do
        expect{graph.add_edge('a','b', 4)}.to raise_error ArgumentError
      end
    end
  end

  describe 'adjust_weight' do
    context 'the edge exists' do
      it 'adjusts the value in the weight hash' do
        graph.adjust_weight('a','b', 1)
        expect(graph.weights).to include ['a','b'] => 1
      end
    end

    context 'the edge does not exist' do
      it 'raises an ArgumentError' do
        expect{graph.adjust_weight('a','f',3)}.to raise_error ArgumentError
      end
    end
  end
end
