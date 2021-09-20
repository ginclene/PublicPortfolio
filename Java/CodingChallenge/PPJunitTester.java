/*
 * Flooid Coding Challenge
 * Author: Nicholas Gincley
 * Assignment: Write an application that will calculate the total basket cost for a mix of items.
 * 
 * Write a program that can calculate the total basket cost of these items.  The program inputs should
be how many of each item was purchased.  Inputs can come from user input, read from a file,
passed as command-line arguments, Unit Tests, etc.  You can be flexible here.  As long as the
program can be run and inputs can be changed.
 */
import org.junit.jupiter.api.Test;

import junit.framework.TestCase;

public class PPJunitTester extends TestCase {
	static PromotionalPricing tester = new PromotionalPricing();
	double price;
	@Test
	public void testPeaches1() {
		price = tester.calculatePrice(3, 0, 0);
		assertEquals(price, 2.25);
	}
	@Test
	public void testPeaches2() {
		price = tester.calculatePrice(4, 0, 0);
		assertEquals(price, 2.00);
	}
	@Test
	public void testPeaches3() {
		price = tester.calculatePrice(5, 0, 0);
		assertEquals(price, 2.50);
	}
	@Test
	public void testMangos1() {
		price = tester.calculatePrice(0, 0, 1);
		assertEquals(price, 2.00);
	}
	@Test
	public void testMangos2() {
		price = tester.calculatePrice(0, 0, 2);
		assertEquals(price, 2.00);
	}
	@Test
	public void testMangos3() {
		price = tester.calculatePrice(0, 0, 3);
		assertEquals(price, 4.00);
	}
	@Test
	public void testMangos4() {
		price = tester.calculatePrice(0, 0, 4);
		assertEquals(price, 4.00);
	}
	@Test
	public void testMangos5() {
		price = tester.calculatePrice(0, 0, 5);
		assertEquals(price, 6.00);
	}
	@Test
	public void testGeneral() {
		price = tester.calculatePrice(5, 3, 7);
		assertEquals(price, 16.50);
	}
}
