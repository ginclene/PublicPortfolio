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
public class PPTester {
	
	final static int PEACHES = 1;
	final static int AVOCADOS = 1;
	final static int MANGOS = 1;
	static PromotionalPricing tester = new PromotionalPricing();
	
	public static void main(String args[]) {
		double totalPrice;
		System.out.println("conducting pricing test with:");
		System.out.println(PEACHES + " Peaches " + AVOCADOS + " Avocados " + MANGOS + " Mangos.");
		totalPrice = tester.calculatePrice(PEACHES, AVOCADOS, MANGOS);
		
		System.out.println("the total price is: " + totalPrice);

	}
}
