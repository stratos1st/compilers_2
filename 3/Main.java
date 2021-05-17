import syntaxtree.*;
import visitor.*;
import java.io.*;
import java.util.*;

public class Main {

	public static void main (String [] args){
		if(args.length < 1){
			System.err.println("No input file given");
			return;
		}

		for (int i=0;i<args.length;i++){
			FileInputStream file = null;
			try{
				file = new FileInputStream(args[i]);
				MiniJavaParser parser = new MiniJavaParser(file);
				Goal root = parser.Goal();

				visitor1 eval1 = new visitor1();
				visitor1.classes.clear();
				root.accept(eval1, "main");

				offset offsets = new offset();
				offsets.owner_func_offsets.clear();
				offsets.owner_var_offsets.clear();
				root.accept(offsets, "main");

				visitor2 eval2 = new visitor2();
				root.accept(eval2, "main");

				System.out.println(eval2.ans_str);

				try{
					String file_name=args[i].substring(0, args[i].lastIndexOf('.'))+".ll";
					PrintWriter writer = new PrintWriter(file_name, "UTF-8");
					writer.println(eval2.ans_str);
					writer.close();
		    }
				catch (IOException ex){
					System.err.println(args[i]+": "+ex.getMessage());
					ex.printStackTrace();
		    }

			}
			catch(ParseException ex){
				System.err.println(args[i]+": "+ex.getMessage());
				ex.printStackTrace();
			}
			catch(FileNotFoundException ex){
				System.err.println(args[i]+": "+ex.getMessage());
				ex.printStackTrace();
			}
			catch(my_exception ex){
				System.err.println(args[i]+": "+ex.getMessage());
				ex.printStackTrace();
			}
			catch(Exception ex){
				//System.err.println(args[i]+": Exception\n");
				System.err.println(args[i]+": "+ex);
				ex.printStackTrace();
			}
			try{
				if(file != null)
					file.close();
			}
			catch(IOException ex){
				System.err.println(args[i]+": "+ex.getMessage());
			}
		}

	}
}
