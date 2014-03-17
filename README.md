# Graphunk

Graphunk defines simple and fully-tested graph classes in Ruby which you can use to perform graph-theoretical operations.

## Defining a Graph

### Unweighted Graphs

Graphs are internally represented as a hash, so you can define a graph similarly to how you would define a Hash:

```
Graphunk::UndirectedGraph.new({
  'a' => ['b','c'],
  'b' => ['c', 'd', 'e'],
  'c' => ['d'],
  'd' => ['e'],
  'e' => []
})
```

Each key is a string representing a vertex, and the value is a list
of strings which represent neighbor vertices of the key.

In an undirected graph, edges are not represented redundantly, meaning
that the edge a-b in the above case is defined by "b" being a member of "a's" list, but
"a" is not a member of "b's" list. The add_edge method takes care of ordering automatically.

In a directed graph, the order in an edge matters. A construction of a directed graph
might look like this:

```
Graphunk::DirectedGraph.new({
  'a' => ['b','c'],
  'b' => ['a'],
  'c' => ['d'],
  'd' => []
})
```

Graphs can also be built by individually adding edges and vertices.

```
graph = Graphunk::UndirectedGraph.new
graph.add_vertex('a')
graph.add_vertex('b')
graph.add_edge('a','b')
```

### Weighted Graphs

Weighted graphs have an additional property: each edge must specify a numerical weight.

To construct a weighted graph, you must pass in the vertex and edge information as well as the weights:

```
Graphunk::WeightedUndirectedGraph.new({
  'a' => ['b','c'],
  'b' => ['c', 'd', 'e'],
  'c' => ['d'],
  'd' => ['e'],
  'e' => []
},
{
  ['a','b'] => 2,
  ['a','c'] => 4,
  ['b','c'] => 1,
  ['b','d'] => 4,
  ['b','e'] => 7,
  ['c','d'] => 4,
  ['d','e'] => 3
})
```

You can also build them by adding vertices and edges.
```
  graph = Graphunk::WeightedUndirectedGraph.new
  graph.add_vertex('a')
  graph.add_vertex('b')
  graph.add_edge('a','b',3)
```
Now the edge 'a-b' will have a weight of 3.

WeightedDirectedGraph behaves similarly.

## Testing

To run the test suite simply execute:

```
rspec
```

## Future Work

- More algorithms
- Make the Graph constructor more "safe"
- Support for flow networks

## Credits

All code (c) Evan Hemsley 2014

Special thanks to Mitchell Gerrard for inspiring this project.
