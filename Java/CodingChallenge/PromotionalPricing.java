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

public class PromotionalPricing {
	
	final float PEACH = 0.75f;
	final float PEACHDISCOUNT = 0.50f;
	final int AVOCADO = 2;
	final int MANGO = 2;
	
	public double calculatePrice(int p, int a, int m) {
		double price = 0.00;
		price += peachCalc(p);
		price += avocadoCalc(a);
		price += mangoCalc(m);
		return price;
	}
	
	public double peachCalc(int p) {
		if(p >= 4) {
			return p * PEACHDISCOUNT;
		} else {
			return p * PEACH;
		}
	}
	
	public double avocadoCalc(int a) {
		return a * AVOCADO;
	}
	
	public double mangoCalc(int m) {
		if(m == 1) {
			return MANGO;
		}
		else if(m % 2 == 0) {
			return (m/2) * MANGO;
		} else {
			double normalPrice = m * MANGO;
			int freeItems = (m-1)/2;
			return normalPrice - (freeItems * MANGO);
		}
	}

}
