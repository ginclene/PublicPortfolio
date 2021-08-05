import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.LinkedList;
import java.util.ListIterator;
import java.util.Scanner;

public class Accounts {
	public LinkedList userlist;
	public String filename = "accounts.txt";
	
	public Accounts() throws IOException {
		userlist = new LinkedList();
		readUsers(); 
	}
	
	public void Makaccount(User newUser) throws IOException
	{
		userlist.add(newUser);
		writeUser(newUser);
	}
	
	public void Makeaccount(String username, String password) throws IOException {
		User user = new User(username, password);
		userlist.add(user);
		writeUser(user);
	}
	
	public void Makeaccount(String username, String password, boolean admin) throws IOException {
		User user = new User(username, password, admin);
		userlist.add(user);
		writeUser(user);
	}
	
	 
	public void readUsers() throws IOException 
	{
		Scanner read = new Scanner(new File(filename));
		
		while(read.hasNext())
		{
			String username = read.next().trim();
			String password = read.next().trim();
			int a = read.nextInt(); // admin or not 
			String nameF =  read.next().trim();
			String nameL =  read.next().trim(); 
			String[] phonenumbers = {read.next().trim(), read.next().trim()}; 
			String[] emails = {read.next().trim(), read.next().trim()};
			Boolean admin = false; 
			if(a == 1)
				admin = true; 
			User user = new User(username, password, admin);
			userlist.add(user); 
		}
		
		read.close();
	}
	
	public void changePassword(String un, String newP) throws IOException
	{
		ListIterator<User> userIterator = userlist.listIterator();
		for(int c  = 0; c < userlist.size(); c++)
		{
			User temp = userIterator.next();
			if((temp.username).equals(un))
			{
				temp.password = newP; 
				User changedUser = temp; 
				userlist.remove(temp); 
				userlist.add(temp); 
				writeUser(temp);
			}
		}
	}
	
	public void changeUsername(String un, String newU) throws IOException
	{
		ListIterator<User> userIterator = userlist.listIterator();
		for(int c  = 0; c < userlist.size(); c++)
		{
			User temp = userIterator.next();
			if((temp.username).equals(un))
			{
				temp.username = newU; 
				User changedUser = temp; 
				userlist.remove(temp); 
				userlist.add(temp); 
				writeUser(temp);
			}
		}
	}
	
	/*
	 * Changes the phone number of a user 
	 * in linkedlist and then file 
	 */
	public void changePhoneNumber(String un, String newN) throws IOException
	{
		ListIterator<User> userIterator = userlist.listIterator();
		for(int c  = 0; c < userlist.size(); c++)
		{
			User temp = userIterator.next();
			if((temp.username).equals(un))
			{
				
				String[] number = {newN, temp.getPhoneNumber()}; 
				temp.setPhoneNumber(number); 
			}
		}
	}
	
	/*
	 * Changes the email of a user 
	 * in linkedlist and then the file 
	 */
	public void changeEmail(String un, String newE) throws IOException
	{
		ListIterator<User> userIterator = userlist.listIterator();
		for(int c  = 0; c < userlist.size(); c++)
		{
			User temp = userIterator.next();
			if((temp.username).equals(un))
			{
				String[] em = {newE, temp.getEmail()}; 
				temp.setEmail(em); 
			}
		}
	}
	
	/*
	 * NEED FOR GUI PLEASE DON'T CHANGE 
	 * checks that user exists in the accounts.txt file with the 
	 * username and password that they entered
	 */
	int hasAccount(String username, String password) throws IOException
	{
		ListIterator<User> userIterator = userlist.listIterator();
		for(int c  = 0; c < userlist.size(); c++)
		{
			User temp = userIterator.next();
			if((temp.username).equals(username))
			{
				if((temp.password).equals(password))
				{
					return c;
				}
			}
		}
		
		return -66; 
	}
	
	/*
	 * Writes the users to the Accounts.txt from the linkedlist 
	 */
	void writeUser(User usr) throws IOException 
	{
		//readUsers(); // get all current accounts in the linked list

		PrintWriter to = new PrintWriter(new File(filename));
		String line;
		ListIterator<User> ui = userlist.listIterator();
		to.println(); 
		
		while(ui.hasNext())
		{
			User temp = ui.next(); 
			to.println(temp.username);
			to.println(temp.password);
			to.println(temp.isAdmin());
			to.println(temp.firstName);
			to.println(temp.lastName);
			to.println(temp.email[0]);
			to.println(temp.email[1]);
			to.println(temp.phoneNumber[0]);
			to.println(temp.phoneNumber[1]);
		}
		
		to.println();
		to.close();
	}
}
