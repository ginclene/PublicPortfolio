import java.io.BufferedWriter;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;


public class Animal implements Comparable<Animal>
{
	String name, diet, commonRegion, prefferedBiome, animalClass;
	Integer numOfLimbs, averageLifespan, coldOrWarmBlooded; // 1 = cold blooded 0 = warmblooded
	String[] methodsOfTravel = new String[10];
	LinkedList comments = new LinkedList(); 
	int lastComment = 0; 
	File animalStorage;
	String filename;
	
	public Animal() {
		
	}
	
	public Animal(String Aname, String identifier) {
		name = Aname;
		filename = name + "Storage.dat";
		
		try {
			readComments();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	/*
	 * Animal constructor 
	 * animal info is saved as .dat file 
	 * anmal comments are saved as a .txt file
	 */
	public Animal(String Aname, String Adiet, String region, String biome, String Aclass,
			int limbs, int lifespan, String[] travel, String blood) throws IOException {
		filename = Aname  + " Storage.dat";
		File newFile = new File(filename); 
		newFile.createNewFile(); // if file already exists will do nothing
		File commentFile = new File(Aname + " Comments.txt"); 
		commentFile.createNewFile(); // if file already exists will do nothing
		
		name = Aname;
		diet = Adiet;
		commonRegion = region;
		prefferedBiome = biome;
		animalClass = Aclass;
		numOfLimbs = limbs;
		averageLifespan = lifespan;
		methodsOfTravel = travel;
		if(blood.contains("cold")) {
			coldOrWarmBlooded = 1;
		} else {
			coldOrWarmBlooded = 0;
		}
		filename = Aname + " Storage.dat";
		animalStorage = new File(filename);
		saveAnimal();
		readComments(); 
	}
	
	String getName() {
		return name;
	}
	
	String getDiet() {
		return diet;
	}
	
	String getCommonRegion() {
		return commonRegion;
	}
	
	String getPreferredBiome() {
		return prefferedBiome;
	}
	
	String getAnimalClass() {
		return animalClass;
	}
	
	String[] getTravelMethods() {
		return methodsOfTravel;
	}
	
	int getNumOfLimbs() {
		return numOfLimbs;
	}
	
	int getAverageLifespan() {
		return averageLifespan;
	}
	
	int getColdOrWarmBlooded() {
		return coldOrWarmBlooded;
	}
	
	File getAnimalFile() {
		return animalStorage;
	}
	
	String getFilename() {
		return filename;
	}
	
	/*
	 * Returns name, diet, commonRegion, preferredBiome, animalClass, 
	 * numOfLimbs, averageLifespan, coldOrWarmBlooded
	 */
	String[] getTraits()
	{
		String[] traits = new String[8];
		traits[0] = name;
		traits[1] = diet;
		traits[2] = commonRegion;
		traits[3] = prefferedBiome;
		traits[4] = animalClass;
		traits[5] = Integer.toString(numOfLimbs);
		traits[6] = Integer.toString(averageLifespan);
		String blood;
		if (coldOrWarmBlooded==0) blood = "warm blooded";
		else blood = "cold blooded";
		traits[7] = blood;
		return traits; 
	}
	
	boolean addTrait()
	{
		return false;
	}
	
	String[] getComments() throws IOException
	{
		String[] com = new String[comments.size()];
		
		ListIterator<String> commentIterator = comments.listIterator();
		for(int c = 0; c < com.length; c++)
		{
			com[c] = commentIterator.next(); 
		}
		
		return com; 
	}
	
	boolean addComment(String comment) throws IOException
	{ 
		lastComment++;
		comments.add(comment); 
		writeComments(); 
		return true; 
	}
	
	void deleteComment(String comment) throws IOException
	{ 
		//readComments(); 
		comments.remove(comment); 
		writeComments(); 
	}
	
	public void readComments() throws IOException 
	{
		Scanner read = new Scanner(new File(name + " Comments.txt"));
		
		while(read.hasNext())
		{
			String line = read.nextLine(); 
			if(!line.isEmpty())
				comments.add(line); 
		}
		
		read.close();
	}
	
	void writeComments() throws IOException 
	{
		//readUsers(); // get all current accounts in the linked list
		 
		PrintWriter to = new PrintWriter(new File(name + " Comments.txt"));
		String line;
		ListIterator<String> ui = comments.listIterator();
		to.println(); 
		
		while(ui.hasNext())
		{
			to.println(ui.next());
		}
		
		to.println();
		to.close();
	}
	
	void printComments() throws IOException {
		String[] com = getComments(); 
		System.out.println(com[0]);
		for(int i = 0; i < com.length; i++) {
			System.out.println(com[i]);
		}
	}
	
	void printTravel() {
		for(int i = 0; i < methodsOfTravel.length; i++) {
			System.out.println(methodsOfTravel[i]);
		}
	}
	
	public void saveAnimal() throws IOException {
		File checker = new File(filename);
		checker.createNewFile(); 
		if(checker.exists()) {
			checker.delete();
		}
			FileWriter fstream = new FileWriter(filename, true);
	        BufferedWriter out = new BufferedWriter(fstream);
			out.write(name);
			out.newLine();
			out.write(diet);
			out.newLine();
			out.write(commonRegion);
			out.newLine();
			out.write(prefferedBiome);
			out.newLine();
			out.write(animalClass);
			out.newLine();
			out.write(String.valueOf(getNumOfLimbs()));
			out.newLine();
			out.write(String.valueOf(getAverageLifespan()));
			out.newLine();
			out.write(String.valueOf(getColdOrWarmBlooded()));
			out.newLine();
			String[] com = getComments(); 
			for(int i = 0; i < com.length; i++) {
				out.write(com[i]);
			}
			out.newLine();
			for(int j = 0; j < methodsOfTravel.length; j++) {
				out.write(methodsOfTravel[j]);
			}
		out.close();		
		}

	public int compareTo(Animal o) {
		Animal a = (Animal) o;
		return this.name.compareTo(a.name);
	}
}
class SortReverse implements Comparator<Animal> {
	public int compare(Animal a, Animal b) {
		return b.name.compareTo(a.name);
	}
	
}
class SortLimbs implements Comparator<Animal> {
	public int compare(Animal a, Animal b) {
		int compare = a.numOfLimbs - b.numOfLimbs;
		if (compare == 0) {
			return a.filename.compareTo(b.name);
		}
		else return compare;
	}
}
class SortBiome implements Comparator<Animal> {
	public int compare(Animal a, Animal b) { 
		return a.prefferedBiome.compareTo(b.prefferedBiome);
	}
}
/*
 * These are the comparators that we use to sort the animals
 * by their traits 
 * 
 */
class SortTravel implements Comparator<Animal> {
	public int compare(Animal a, Animal b) {
		return a.methodsOfTravel[0].compareTo(b.methodsOfTravel[0]);
	}
}
class SortLifespan implements Comparator<Animal> {
	public int compare(Animal a, Animal b) {
		return a.averageLifespan-b.averageLifespan;
	}
}
class SortDiet implements Comparator<Animal> {
	public int compare(Animal a, Animal b) {
		return a.diet.compareTo(b.diet);
	}
}

class SortCold implements Comparator<Animal>
{
	public int compare(Animal a, Animal b)
	{
		return b.getColdOrWarmBlooded()-(a.getColdOrWarmBlooded());
	}
}

class SortWarm implements Comparator<Animal>
{
	public int compare(Animal a, Animal b)
	{
		return a.getColdOrWarmBlooded()-(b.getColdOrWarmBlooded());
	}
}