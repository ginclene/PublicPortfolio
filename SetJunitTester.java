import static org.junit.Assert.*;

import java.util.ListIterator;

import javax.swing.text.html.HTMLDocument.Iterator;

import org.junit.Test;

public class SetJunitTester {
	mySet<Integer> set = new mySet<Integer>();

	@Test
	public void Constructortest() {
		mySet<Integer> set = new mySet<Integer>();
	}
	
	@Test
	public void Addtest() {
		set.add(1);
		for(int i = 1; i < 10; i++) {
			set.add(i);
		}
		for(int i = 1; i < 10; i++) {
		assertTrue(set.contains(i));
		}
		set.createList();
		assertTrue(set.getRoot().value == 1);
		assertTrue(set.size() == 9);
		set.add(1);
		assertTrue(set.size() == 9);
	}
	
	@Test
	public void Removetest() {
	    assertTrue(set.size() == 0);
	    assertTrue(set.isEmpty());
	    for(int i = 1; i < 10; i++) {
			set.add(i);
		}
	    assertTrue(set.size()==9);
	    assertFalse(set.isEmpty());
	    assertTrue(set.contains(1));
	    set.remove(1);
	    assertFalse(set.contains(1));
	    for(int i = 2; i < 10; i++) {
			set.remove(i);
			assertFalse(set.contains(i));
		}
	    assertTrue(set.isEmpty());
	    
	}
	
	@Test
	public void Uniontest() {
		assertTrue(set.isEmpty());
		mySet<Integer> set2 = new mySet<Integer>();
		for(int i = 0; i < 5; i++) {
			set.add(i);
			set2.add(i+5);
	}
		mySet<Integer> set3 = set.union(set2);
		for(int i = 0; i < 10; i++) {
			assertTrue(set3.contains(i));
		}
	}
	
	@Test
	public void IntersectionTest() {
		assertTrue(set.isEmpty());
		mySet<Integer> set2 = new mySet<Integer>();
		for(int i = 0; i < 5; i++) {
			set.add(i);
			set2.add(i+2);
	}
		mySet<Integer> set3 = set.intersection(set2);
		for(int i = 2; i < 5; i++) {
			assertTrue(set3.contains(i));
		}
	}
	
	@Test
	public void Differencetest() {
		assertTrue(set.isEmpty());
		mySet<Integer> set2 = new mySet<Integer>();
		for(int i = 0; i < 5; i++) {
			set.add(i);
			set2.add(i+3);
	}
		set.add(-1);
		mySet<Integer> set3 = set.difference(set2);
		for(int i = -1; i < 3; i++) {
			assertTrue(set3.contains(i));
		}
	}
	
	@Test
	public void Isemptytest() {
		assertTrue(set.isEmpty());
		set.add(1);
		set.add(2);
		set.add(3);
		assertFalse(set.isEmpty());
		set.remove(3);
		assertFalse(set.isEmpty());
		set.remove(2);
		assertFalse(set.isEmpty());
		set.remove(1);
		assertTrue(set.isEmpty());
		
	}
	
	@Test
	public void Sizetest() {
		assertTrue(set.size() == 0);
		set.add(1);
		set.add(2);
		set.add(3);
		assertTrue(set.size() == 3);
		set.remove(3);
		assertTrue(set.size() == 2);
		set.remove(2);
		assertTrue(set.size() == 1);
		set.remove(1);
		assertTrue(set.size() == 0);
		
	}
	
	@Test
	public void HashCodeTest() {
		for(int i = 0; i < 5; i++) {
			set.add(i);
		}
		set.hashCode();
	}
	
	@Test
	public void IteratorTest() {
		for(int i = 0; i < 5; i++) {
			set.add(i);
	}
		java.util.Iterator<Integer> it = set.iterator();
		assertTrue(it.hasNext());
		for(int i = 1; i < 5; i++) {
		assertTrue(it.hasNext());
		assertTrue(it.next() == i);
		}
	}
	
	@Test
	public void toStringTest() {
		for(int i = 0; i < 5; i++) {
			set.add(i);
	}
		String test = "[ 0 1 2 3 4 ]";
		assertEquals(test, set.toString());
	}
	
	@Test
	public void EqualsTest() {
		mySet<Integer> set2 = new mySet<Integer>();
		for(int i = 0; i < 5; i++) {
			set.add(i);
			set2.add(i);
	}
		assertTrue(set.equals(set2));
		set2.add(7);
		assertFalse(set.equals(set2));
	}
	
	@Test
	public void Containstest() {
		assertFalse(set.contains(1));
		set.add(1);
		assertTrue(set.contains(1));
		assertFalse(set.contains(2));
		set.add(2);
		assertTrue(set.contains(2));
		assertFalse(set.contains(3));
		set.add(3);
		assertTrue(set.contains(3));
		set.remove(3);
		assertFalse(set.contains(3));
		set.remove(2);
		assertFalse(set.contains(2));
		set.remove(1);
		assertFalse(set.contains(1));
		assertTrue(set.isEmpty());
		
	}
	
	

}
