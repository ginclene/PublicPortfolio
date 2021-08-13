
public class User 
{
	// there has to at least be 1 of each except email
	String[] email = {"N/A", "N/A"}; 
	String[] phoneNumber = {"N/A", "N/A"}; 
	String lastName, firstName; 
	public boolean administrator = false;
	public String username = ""; // so checkEquals doesn't throw nullPointer exception
	public String password = "";
	
	
	public User(String name, String pass, boolean admin)
	{
		username = name; 
		password = pass; 
		administrator = admin; 
	}
	public User(String name, String pass, String emails, String nums, String fn, String ln)
	{
		username = name; 
		password = pass; 
		phoneNumber[0] = nums; 
		email[0] = emails; 
		lastName = ln;
		firstName = fn; 
	}
	
	public User(String name, String pass) 
	{
		username = name; 
		password = pass; 
	}
	
	boolean setFName(String firstName)
	{
		this.firstName = firstName; 
		return false; 
	}
	
	boolean setLName(String lastName)
	{
		this.lastName = lastName; 
		return false; 
	}
	
	boolean setEmail(String[] email)
	{
		this.email = email; 
		return true; 
	}
	
	boolean setPhoneNumber(String[] phoneNumber)
	{
		this.phoneNumber = phoneNumber; 
		return true; 
	}
	
	String getPhoneNumber()
	{
		return phoneNumber[0]; 
	}
	
	String getEmail()
	{
		return email[0]; 
	}
	
	boolean setAdmin(boolean admin)
	{
		administrator = admin; 
		return true; 
	}
	
	boolean requestAnimal(Animal newAnimal)
	{
		return false; 
	}
	
	boolean loggedIn(String username, String password)
	{
		return false;
	}
	
	// returns 1 if admin and 0 if not 
	int isAdmin()
	{
		return administrator ? 1 : 0;
	}
	
	
	void commentOnAnimal(String comment)
	{
		
	}
	
	
}

