module Neo4j
  # A node in the graph with properties and relationships to other entities.
  # Along with relationships, nodes are the core building blocks of the Neo4j data representation model.
  # Node has three major groups of operations: operations that deal with relationships, operations that deal with properties and operations that traverse the node space.
  # The property operations give access to the key-value property pairs.
  # Property keys are always strings. Valid property value types are the primitives (<tt>String</tt>, <tt>Fixnum</tt>, <tt>Float</tt>, <tt>Boolean</tt>), and arrays of those primitives.
  #
  # The Neo4j::Node#new method does not return a new Ruby instance (!). Instead it will call the Neo4j Java API which will return a
  # *org.neo4j.kernel.impl.core.NodeProxy* object. This java object includes the same mixin as this class. The #class method on the java object
  # returns Neo4j::Node in order to make it feel like an ordinary Ruby object.
  #
  # @example Create a node with one property (see {Neo4j::Core::Node::ClassMethods})
  #   Neo4j::Node.new(:name => 'andreas')
  #
  # @example Create a relationship (see {Neo4j::Core::Traversal})
  #   Neo4j::Node.new.outgoing(:friends) << Neo4j::Node.new
  #
  # @example Finding relationships (see {Neo4j::Core::Rels})
  #   node.rels(:outgoing, :friends)
  #
  # @example Lucene index (see {Neo4j::Core::Index})
  #   Neo4j::Node.trigger_on(:typex => 'MyTypeX')
  #   Neo4j::Node.index(:name)
  #   a = Neo4j::Node.new(:name => 'andreas', :typex => 'MyTypeX')
  #   # finish_tx
  #   Neo4j::Node.find(:name => 'andreas').first.should == a
  #
  class Node
    extend Neo4j::Core::Node::ClassMethods
    extend Neo4j::Core::Wrapper::ClassMethods
    extend Neo4j::Core::Index::ClassMethods

    include Neo4j::Core::Property
    include Neo4j::Core::Rels
    include Neo4j::Core::Traversal
    include Neo4j::Core::Node
    include Neo4j::Core::Wrapper
    include Neo4j::Core::Property::Java # for documentation purpose only
    include Neo4j::Core::Index

    node_indexer do
      index_names :exact => 'default_node_index_exact', :fulltext => 'default_node_index_fulltext'
    end

    class << self


      # This method is used to extend a Java Neo4j class so that it includes the same mixins as this class.
      def extend_java_class(java_clazz)
        java_clazz.class_eval do
          include Neo4j::Core::Property
          include Neo4j::Core::Rels
          include Neo4j::Core::Traversal
          include Neo4j::Core::Node
          include Neo4j::Core::Wrapper
          include Neo4j::Core::Index
        end
      end
    end
  end

  Neo4j::Node.extend_java_class(Java::OrgNeo4jKernelImplCore::NodeProxy)

end
