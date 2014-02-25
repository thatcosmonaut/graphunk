# Graphunk

Graphunk defines a simple and fully-tested Graph class in Ruby which you can use to perform graph operations.

## Defining a Graph

Graph inherits directly from Hash, so you can define a graph in the same way you would define a Hash:

```
Graph[
  'a' => ['b','c'],
  'b' => ['c', 'd', 'e'],
  'c' => ['d'],
  'd' => ['e'],
  'e' => []
]
```

Each key is a string representing a vertex, and the value is a list
of strings which represent neighbor vertices of the key.

Graph defines an undirected graph - support for directed graphs and related algorithms will be coming soon.
In this implementation, edges are not represented redundantly, meaning
that the edge a-b in the above case is defined by "b" being a member of "a's" list, but
"a" is not a member of "b's" list.

Graphs can also be built by individually adding edges and vertices.

```
graph = Graph.new
graph.add_vertex('a')
graph.add_vertex('b')
graph.add_edge('a','b')
```

The add_edge method will take care of ordering automatically.

## Testing

To run the test suite simply execute:

```
rspec
```

## Future Work

- More algorithms
- Make the Graph constructor more "safe"
- Support for directed graphs and flow networks
- Encapsulation within a gem

## Credits

All code (c) Evan Hemsley 2014

Special thanks to Mitchell Gerrard for inpiring this project.
