import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;



/**
 * A class that creates a set using a combination of a BST and an ArrayList
 * @author Nicholas Gincley
 *
 * @param <Item> a data type that is comparable
 */
public class mySet<Item extends Comparable<Item>> implements Iterable<Item> {
	int size;
	Node root;
	ArrayList<Item> list = new ArrayList<Item>();	
	public mySet() {
		size = 0;
		root = null;
	}
	
	/**
	 * Adds an item to the tree
	 * @param item the item to be added
	 */
	public void add(Item item) {
		if(root == null){
			Node node = new Node(item);
			root = node;
			size++;
			return;
		}
		if(this.contains(item) == false) {
		add(root,item);
		} else {
			return;
		}
		
	}
	/**
	 * Helper method to the add method
	 * @param root
	 * @param value
	 * @return
	 */
	private Item add(Node root, Item value) {
       int comparison = value.compareTo(root.value);
		
		if(comparison == 0) {
			return null;
		}
		if(comparison < 0){
			if(root.left == null){
				Node node = new Node(value);
				root.left = node;
				size++;
			} else{
			 return add(root.left,value);
			}
			}
		if(comparison > 0){
			if(root.right == null){
				Node node = new Node(value);
				root.right = node;
				size++;
			}else{
				return add(root.right,value);
			}
		}
		return value;
	}
	
	public boolean remove() {
		if(list.isEmpty()) {
			return false;
		} else {
			 return remove(list.get(size-1));
		}
	}
	
	/**
	 * removes a certain item from the tree
	 * @param item
	 * @return
	 */
public boolean remove(Item s) {
		
		if(!this.contains(s)) {
			return false;
		}
		size--;
		if(s.equals(root.value) && root.left==null && root.right == null){
			root=null;
			return true;
		}
		if(s.equals(root.value) && root.left==null && root.right != null){
			root=root.right;
			return true;
		}
		if(s.equals(root.value) && root.right==null && root.left != null){
			root=root.left;
			return true;
		}
		Node current = root;
		Node previous = root;
		while(current != null) {
			int comparison = s.compareTo(current.value);
			if(comparison < 0) {
				previous = current;
				current = current.left;
			}
			if (comparison > 0) {
				previous = current;
				current = current.right;
			}
			
			if(comparison == 0) {
				if(current.right==null && current.left == null) {
					if(previous.left == current) 
						previous.left = null;
					else 
						previous.right = null;
					return true;
				}
				else if(current.left == null || current.right == null) {
					if(previous.left==current) 
						previous.left = current.left == null ? current.right:current.left;
				else 
					previous.right = current.right == null ? current.right:current.left;
					return true;
			}
				if(current.left != null && current.right !=null) {
					Item max = findMax(current);
					this.remove(max);
					current.value = max;
					return true;
				}
		}
		}
		return false;

	}
	public Item findMax(Node node){
		while(node.right != null){
	        node = node.right;
	    }
	    return node.value;
	}

	    /**
		 * returns a set that contains the union between this set and another set without duplicates
		 * @param thatSet the other set to find the union of
		 * @return a mySet object
		 */
	public mySet<Item> union(mySet<Item> thatSet) {
		mySet unionSet = new mySet();
	//	if(this.list == null) {
			this.createList();
	//	}
	//	if(thatSet.list == null) {
		thatSet.createList();
	//	}
		for(int i = 0; i < list.size(); i++) {
			unionSet.add(list.get(i));
		}
		for(Item item : thatSet.list) {
			unionSet.add(item);
		}
		return unionSet;
	}
	
	/**
	 * returns a set that contains the intersection between this set and another set
	 * @param thatSet the other set to find the intersection with
	 * @return a mySet object
	 */
	public mySet<Item> intersection(mySet<Item> thatSet) {
		mySet intersection = new mySet();
	//	if(this.list.get(1) == null) {
			this.createList();
	//	}
	//	if(thatSet.list.get(1) == null) {
		thatSet.createList();
	//	}
		for(Item item : list) {
			if(thatSet.contains(item)) {
				intersection.add(item);
			}
		}
		return intersection;
	}
	
	/**
	 * returns a set that contains the difference between this set and another set
	 * @param thatSet the other set to find the difference of
	 * @return a mySet object
	 */
    public mySet<Item> difference(mySet<Item> thatSet) {
    	mySet difference = new mySet();
			this.createList();
		thatSet.createList();
		for(Item item : list) {
			if(!thatSet.contains(item)) {
				difference.add(item);
			}
		}
		return difference;
	}
    
    /**
     * Checks to see if an item is in the set
     * @param item the item to check
     * @return true if found, false if not
     */
    public boolean contains(Item item) {
    	Node current = new Node(item);
    	boolean found = false;
    	if(root == null) {
    		return found;
    	}
    	else if(current.value.equals(root.value)) {
    		found = true;
    		return found;
    	} else {
    		if(current.value.compareTo(root.value) < 0) {
    			return contains(root.left, item);
    		} else {
    			return contains(root.right, item);
    		}
    		
    	}
    }
    
    /**
     * Helper to the contains method
     * @param root
     * @param item
     * @return
     */
    private boolean contains(Node root, Item item) {
    	Node current = new Node(item);
    	boolean found = false;
    	if(root == null) {
    		return found;
    	}
    	else if(current.value.equals(root.value)) {
    		found = true;
    		return found;
    	} else {
    		if(current.value.compareTo(root.value) < 0 && root.left != null) {
    			return contains(root.left, item);
    		} else {
    			if(root.right != null) {
    			return contains(root.right, item);
    			}
    			return found;
    		}
    		
    	}
    }
    /**
     * checks if the tree is empty
     * @return
     */
    public boolean isEmpty() {
    	return (size == 0);
    }
    
    /**
     * Returns the size of tree (int)
     * @return
     */
    public int size() {
    	return size;
    }
    
    /**
     * Returns a custom hashcode for this tree based on items in the tree
     */
    public int hashCode() {
    	this.createList();
    	int sum = 0;
    	
    	for(int i = 0; i < size; i++) {
    		sum += this.list.get(i).hashCode();
    	
    	}
    	int hash = (sum) % this.size;
    	return hash;
    }
    /**
     * Creates an iterator to iterate through an arraylist created by the tree
     */
    public Iterator<Item> iterator() {
    	createList();
    	return new ListIterator<Item>(this);
    }
    /**
     * Converts the tree to an array list for easier comparisons between sets
     */
    public void createList() {
    	list.clear();
    	Node current = root;
    	list.add(current.value);
    	if(root.left != null) {
    	createList(current.left);
    	}
    	if(root.right != null) {
    	createList(current.right);
    	}
    }
    
    /**
     * Helper to the createList method
     * @param root
     */
    private void createList(Node root) {
    	list.add(root.value);
    	if(root.left != null) {
    		createList(root.left);
    	}
    	if(root.right != null) {
    		createList(root.right);
    	}
    }
    
    /**
     * Converts the array into a string for easy display to console
     */
    public String toString() {
    //	if(list == null) {
    		createList();
    //	}
    	StringBuilder setlist = new StringBuilder();
    	setlist.append("[ ");
    	for(int i = 0; i < this.list.size(); i++) {
    		setlist.append(this.list.get(i) + " ");
    	}
    	setlist.append("]");
    	
    	return setlist.toString();
    	
    }
    
    /**
     * Used to compare this tree to another object
     */
    public boolean equals(Object obj) {
    	return this.hashCode() == obj.hashCode();
    	
    }
    
    /**
     * returns the root of this tree
     * @return
     */
    public Node getRoot() {
    	return root;
    }
    
    private class ListIterator<Item extends Comparable<Item>> implements Iterator<Item> { 
        Item current;
        int count = 0;
          
        // initialize pointer to head of the list for iteration 
        public ListIterator(mySet<Item> mySet) 
        { 
            current = (Item) list.get(count); 
        } 
          
        // returns false if next element does not exist 
        public boolean hasNext() 
        { 
            return count < list.size(); 
        } 
          
        // return current data and update pointer 
        public Item next() 
        { 
            count++;
            current = (Item) list.get(count); 
            return current; 
        } 
       
    } 
    
    public class Node implements Comparable<Node>{
		Item value;
		Node left;
		Node right;
		Node next;
		
		public Node(Item value) {
			this.value = value;
		}
		
		public Item getValue() {
			return value;
		}
		
		public int compareTo(Node othernode) {
			if (this.value.compareTo(othernode.value) < 0) {
				return -1;
			} 
			return 1;
		
	}
		

}
    

}
