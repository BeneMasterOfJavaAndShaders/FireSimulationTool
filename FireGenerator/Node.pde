//class Node {
//  ArrayList<Node> children;
//  Node parent;
//  String name;

//  public Node(String name) {
//    this.name = name;
//    this.children = new ArrayList<Node>();
//  }

//  public final void add_child(Node node) {
//    this.children.add(node);
//    node.set_parent(this);
//  }

//  public final void set_parent(Node parent) {
//    this.parent = parent;
//  }

//  public final Node get_by_name(String child_name) {
//    for (Node child : this.children)
//      if (child.name().equals(child_name))
//        return child;
//    return null;
//  }

//  public final ArrayList<Node> get_by_type(String child_type) {
//    ArrayList<Node> nodes = new ArrayList<Node>();
//    for (Node child : this.children)
//      if (child.type().equals(child_type))
//        nodes.add(child);
//    return nodes;
//  }

//  public final ArrayList<Node> get_by_condition(NodeCondition condition) {
//    ArrayList<Node> nodes = new ArrayList<Node>();
//    for (Node child : this.children)
//      if (condition.test(child))
//        nodes.add(child);
//    return nodes;
//  }

//  public final boolean has_children() {
//    return this.children.size() != 0;
//  }

//  public final String name() {
//    return this.name;
//  }

//  public final void update(float dt) {
//    for (Node child : this.children)
//      child.update(dt);
//    this._update(dt);
//  }

//  public final void show() {
//    for (Node child : this.children)
//      child.show();
//    this._show();
//  }

//  //-------------- Override --------------
//  public String type() {
//    return "Node";
//  }

//  public void _update(float dt) {
//  }

//  public void _show() {
//  }
//}

//public abstract interface NodeCondition {
//  public abstract boolean test(Node target);
//}
