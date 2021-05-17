import syntaxtree.*;
import java.util.*;
import visitor.GJDepthFirst;

public class offset extends GJDepthFirst<String, String> {

	public static LinkedHashMap<String, LinkedHashMap<String, String>> owner_func_offsets = new LinkedHashMap<String, LinkedHashMap<String, String>>();
	public static LinkedHashMap<String, LinkedHashMap<String, String>> owner_var_offsets = new LinkedHashMap<String, LinkedHashMap<String, String>>();

	/**
	 * f0 -> MainClass()
	 * f1 -> ( TypeDeclaration() )*
	 * f2 -> <EOF>
	 */
	public String visit(Goal n, String argu) throws Exception {
		 n.f0.accept(this, argu);
		 n.f1.accept(this, argu);
		 return null;
	}

	/**
	 * f0 -> "class"
	 * f1 -> Identifier()
	 * f2 -> "{"
	 * f3 -> "public"
	 * f4 -> "static"
	 * f5 -> "void"
	 * f6 -> "main"
	 * f7 -> "("
	 * f8 -> "String"
	 * f9 -> "["
	 * f10 -> "]"
	 * f11 -> Identifier()
	 * f12 -> ")"
	 * f13 -> "{"
	 * f14 -> ( VarDeclaration() )*
	 * f15 -> ( Statement() )*
	 * f16 -> "}"
	 * f17 -> "}"
	 */
	public String visit(MainClass n, String argu) throws Exception {
	   String name=n.f1.accept(this, argu);
		 owner_func_offsets.put(name, new LinkedHashMap<String, String>());
		 owner_var_offsets.put(name, new LinkedHashMap<String, String>());
		 return null;
	}

	/**
	* f0 -> "class"
	* f1 -> Identifier()
	* f2 -> "{"
	* f3 -> ( VarDeclaration() )*
	* f4 -> ( MethodDeclaration() )*
	* f5 -> "}"
	*/
	public String visit(ClassDeclaration n, String argu) throws Exception {
		String name=n.f1.accept(this, argu);
		//make new map to store offsets
		owner_func_offsets.put(name, new LinkedHashMap<String, String>());
		owner_var_offsets.put(name, new LinkedHashMap<String, String>());

		n.f3.accept(this, name);
		n.f4.accept(this, name);
		return null;
	}

	/**
	* f0 -> "class"
	* f1 -> Identifier()
	* f2 -> "extends"
	* f3 -> Identifier()
	* f4 -> "{"
	* f5 -> ( VarDeclaration() )*
	* f6 -> ( MethodDeclaration() )*
	* f7 -> "}"
	*/
	public String visit(ClassExtendsDeclaration n, String argu) throws Exception {
		String name=n.f1.accept(this, argu);

		//make new map to store offsets
		owner_func_offsets.put(name, new LinkedHashMap<String, String>());
		owner_var_offsets.put(name, new LinkedHashMap<String, String>());

		n.f5.accept(this, name);
		n.f6.accept(this, name);
		return null;
	}

	/**
	* f0 -> Type()
	* f1 -> Identifier()
	* f2 -> ";"
	*/
	public String visit(VarDeclaration n, String argu) throws Exception {
		String type=String.valueOf(n.f0.accept(this,argu)), var=String.valueOf(n.f1.accept(this,argu));

		if(!visitor1.classes.get(argu).inheritance.equals("") &&
						visitor1.classes.get(argu).var_offset == 0)
			visitor1.classes.get(argu).var_offset = visitor1.classes.get(visitor1.classes.get(argu).inheritance).var_offset;

		owner_var_offsets.get(argu).put(var,String.valueOf(visitor1.classes.get(argu).var_offset));

		if(type.equals("int"))
			visitor1.classes.get(argu).var_offset += 4;
		else if(type.equals("boolean"))
			visitor1.classes.get(argu).var_offset += 1;
		else
			visitor1.classes.get(argu).var_offset += 8;

		return null;
	}

	/**
	* f0 -> "public"
	* f1 -> Type()
	* f2 -> Identifier()
	* f3 -> "("
	* f4 -> ( FormalParameterList() )?
	* f5 -> ")"
	* f6 -> "{"
	* f7 -> ( VarDeclaration() )*
	* f8 -> ( Statement() )*
	* f9 -> "return"
	* f10 -> Expression()
	* f11 -> ";"
	* f12 -> "}"
	*/
	public String visit(MethodDeclaration n, String argu) throws Exception {
		String name = String.valueOf(n.f2.accept(this,argu));

		String parent_class = argu;
		//iterate through all inheritance classes
		while(!visitor1.classes.get(parent_class).inheritance.equals("")){
			parent_class = visitor1.classes.get(parent_class).inheritance;//curr class=parent class
			if(visitor1.classes.get(parent_class).funcs.containsKey(name))
				return null;
		}

		if(!visitor1.classes.get(argu).inheritance.equals("") &&
				 visitor1.classes.get(argu).func_offset == 0)
		 visitor1.classes.get(argu).func_offset = visitor1.classes.get(visitor1.classes.get(argu).inheritance).func_offset;

		owner_func_offsets.get(argu).put(name,String.valueOf(visitor1.classes.get(argu).func_offset));

		visitor1.classes.get(argu).func_offset += 8;
		return null;
	}

	/**
	* f0 -> "int"
	* f1 -> "["
	* f2 -> "]"
	*/
	public String visit(ArrayType n, String argu) throws Exception {
	  return "int[]";
	}

	/**
	* f0 -> "boolean"
	*/
	public String visit(BooleanType n, String argu) throws Exception {
	  return "boolean";
	}

	/**
	* f0 -> "int"
	*/
	public String visit(IntegerType n, String argu) throws Exception {
	  return "int";
	}

	/**
	* f0 -> <IDENTIFIER>
	*/
	public String visit(Identifier n, String argu) throws Exception {
		return String.valueOf(n.f0);
	}

}
