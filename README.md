# Graphunk

Graphunk defines simple and fully-tested graph classes in Ruby which you can use to perform graph-theoretical operations.

## Defining a Graph

There are two kinds of graphs supported by this system, directed graphs and undirected graphs.

Graphs inherit from Hash, so you can define a graph in the same way you would define a Hash:

```
UndirectedGraph[
  'a' => ['b','c'],
  'b' => ['c', 'd', 'e'],
  'c' => ['d'],
  'd' => ['e'],
  'e' => []
]
```

Each key is a string representing a vertex, and the value is a list
of strings which represent neighbor vertices of the key.

In an undirected graph, edges are not represented redundantly, meaning
that the edge a-b in the above case is defined by "b" being a member of "a's" list, but
"a" is not a member of "b's" list. The add_edge method takes care of ordering automatically.

In a directed graph, the order in an edge matters. A construction of a directed graph
might look like this:

```
DirectedGraph[
  'a' => ['b','c'],
  'b' => ['a'],
  'c' => ['d'],
  'd' => []
]
```

Graphs can also be built by individually adding edges and vertices.

```
graph = UndirectedGraph.new
graph.add_vertex('a')
graph.add_vertex('b')
graph.add_edge('a','b')
```

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

Special thanks to Mitchell Gerrard for inpiring this project.
