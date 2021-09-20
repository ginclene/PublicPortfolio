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
import java.util.Scanner;
public class PPTester2 {
	
	static PromotionalPricing tester = new PromotionalPricing();
	static Scanner keyboard = new Scanner(System.in);
	
	public static void main(String args[]) {
		double totalPrice;
		int peaches, avocados, mangos;
		System.out.println("enter the number of peaches");
		peaches = keyboard.nextInt();
		System.out.println("enter the number of avocados");
		avocados = keyboard.nextInt();
		System.out.println("enter the number of mangos");
		mangos = keyboard.nextInt(); 
		System.out.println("conducting pricing test with:");
		System.out.println(peaches + " Peaches " + avocados + " Avocados " + mangos + " Mangos.");
		totalPrice = tester.calculatePrice(peaches, avocados, mangos);
		
		System.out.println("the total price is: " + totalPrice);

	}
}
