import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class LinkedList {
	private Node head; // references the first node in the list
	public String filename = "accounts.txt";

	public LinkedList(){
		head=null; // the list is empty
	}
	
	public void add(String name, String pass, boolean ad){
		if(contains(name) == false) {
		Node newNode = new Node(name, pass, ad);
		if(head == null){ // if the list is empty
			head=newNode;
			return;
		}
		//If the list is not empty
		newNode.next=head;
		head=newNode;
		} else {
			System.out.println("User already exists :( try " + name + "1");
		}
	}
	
	public void add(User user) {
		if(contains(user.username) == false) {
			Node newNode = new Node(user.username, user.password, user.administrator);
			if(head == null){ // if the list is empty
				head=newNode;
				return;
			}
			//If the list is not empty
			newNode.next=head;
			head=newNode;
			} else {
				System.out.println("User already exists :( try " + user.username + "1");
			}
	}
	
	public String removeUser(String name) {
		if(head==null){
			return "No users!";
		}
		if (contains(name) == false) {
			return "User already doesn't exist!";
		}
		Node current = head;
		while(current.next != null) {
			if(current.next.username==name) {
				current.next = current.next.next;
				
			}
		}
		return name + "has been removed!";
	}
	
	
	public boolean contains(String name){
		Node current = head;
		while(current!=null){
			if(current.username==name){
				return true;
			}
			current = current.next;
		}
		return false;
	}
	
	public int countUsers(){
		int count = 0;
		Node current = head;
		while(current!=null){
			count++;
			current=current.next;
		}
		return count;
	}
	
	public String toString(){
		String str = "[ ";
		Node current = head;
		while(current!=null){
			str += ("user:" + current.username + ", admin privilages: " + current.admin);
			current = current.next;
		}
		
		str += " ]";
		return str;
	}
	
	public boolean checkAdmin(String name) {
		if(contains(name) == false) {
			return false;
		}
		Node current = head;
		while(current!=null) {
			if(current.username.equals(name)) {
				if(current.admin == true) {
					return true;
				}
			}
			current = current.next;
		}
		return false;
	}
	
	public boolean checkLogin(String name, String pass) {
		if(contains(name) == false) {
			return false;
		} else {
			Node current = head;
			while(current!=null) {
				if(current.username.equals(name)) {
					if(current.password.equals(pass)) {
						return true;
					} else {
						return false;
					}
				}
				current = current.next;
			}
			return false;
		}
		
	}
	public void saveAllUsers() throws IOException {
		File checker = new File(filename);
		if(checker.exists()) {
			checker.delete();
		}
		FileWriter fstream = new FileWriter(filename, true);
        BufferedWriter out = new BufferedWriter(fstream);
        Node current = head;
        while(current != null) {
        	out.write(current.username);
        	out.newLine();
        	out.write(current.password);
        	out.newLine();
        	if(current.admin == true) {
        		out.write(1);
        	}
        	if(current.admin == false) {
        		out.write(0);
        	}
        	out.newLine();
        	current = current.next;
        }
		out.close();
	}
	
	}


