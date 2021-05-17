import syntaxtree.*;
import java.util.*;
import visitor.GJDepthFirst;

public class visitor1 extends GJDepthFirst<String, String> {

	//class name, class_info
	public static LinkedHashMap<String, class_info> classes = new LinkedHashMap<String, class_info>();

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
		String name= n.f1.accept(this, "");
		String string_array_name=n.f11.accept(this, argu);

		classes.put(name, new class_info());
		class_info curr_class = classes.get(name);
		curr_class.funcs.put("main", new class_func_info());
		class_func_info curr_func = curr_class.funcs.get("main");
		curr_func.args.put(string_array_name, "String");
		curr_func.return_type = "void";

		n.f14.accept(this, name+"#main");
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
		String name=n.f1.accept(this, "");

		if (classes.containsKey(name))
			throw new my_exception(name+": already defined");

		classes.put(name, new class_info());
		class_info curr_class = classes.get(name);
		curr_class.inheritance = "";

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
		String name1=n.f1.accept(this, ""), name2=n.f3.accept(this, "");

		if (classes.containsKey(name1))
			throw new my_exception(name1+": redefinition");
		else if (!classes.containsKey(name2))
			throw new my_exception(name2+": not defined");

		// if (classes.get(name2).funcs.containsKey("main"))
		// 	throw new my_exception(name1+": can not inherit from main class");

		classes.put(name1, new class_info());
		class_info curr_class=classes.get(name1);
		curr_class.inheritance = name2;

		//cyclic inheritance
		//not needed
		// Set<String> set = new HashSet<>();
		// String parent_class_name = name1;
		// while(!classes.get(parent_class_name).inheritance.equals("")){
		// 	if (!set.add(parent_class_name)){
		// 		throw new my_exception(name1+": cyclic inheritance not permited");
	  //   }
		// 	parent_class_name = classes.get(parent_class_name).inheritance;
		// }

		n.f5.accept(this, name1);
		n.f6.accept(this, name1);
		return null;
	}

	/**
	 * f0 -> Type()
	 * f1 -> Identifier()
	 * f2 -> ";"
	 */
	public String visit(VarDeclaration n, String argu) throws Exception {
		String type=n.f0.accept(this, ""), name=n.f1.accept(this, "");

		if (argu.contains("#")){ //class function
			String [] parts = argu.split("#");
			String class_name = parts[0];
			String function_name = parts[1];
			class_info curr_class=classes.get(class_name);
			class_func_info curr_func=curr_class.funcs.get(function_name);

			if (curr_func.args.containsKey(name)
						|| curr_func.vars.containsKey(name))
				throw new my_exception(class_name+"."+function_name+"."+name+": declared berore");
			curr_func.vars.put(name, type);
		}
		else{ //class variable
			class_info curr_class=classes.get(argu);
			if (curr_class.vars.containsKey(name))
			 throw new my_exception(argu+"."+name+": declared");
			curr_class.vars.put(name, type);
		}
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
		String type = n.f1.accept(this, ""), name = n.f2.accept(this, "");
		class_info curr_class = classes.get(argu);

		if (curr_class.funcs.containsKey(name))
			throw new my_exception(argu+"."+name+": redeclaration");

		if (name.equals("main"))
			throw new my_exception(argu+".main: class can not have function named main");

		curr_class.funcs.put(name, new class_func_info());
		class_func_info curr_func = curr_class.funcs.get(name);
		curr_func.return_type = type;

		n.f4.accept(this, argu + "#" + name);
		String parent_class_name = argu;
		while(!classes.get(parent_class_name).inheritance.equals("")){ //overload check
			parent_class_name = classes.get(parent_class_name).inheritance;
			if (!classes.get(parent_class_name).funcs.containsKey(name))
				continue;
			else if (!type.equals(classes.get(parent_class_name).funcs.get(name).return_type))
				throw new my_exception(argu+"."+name+": different return type");
			else if (classes.get(parent_class_name).funcs.get(name).args.size() != curr_func.args.size())
				throw new my_exception(argu+"."+name+": different args number");
			else{
				Iterator <String> it1 = curr_func.args.values().iterator();
				Iterator <String> it2 = classes.get(parent_class_name).funcs.get(name).args.values().iterator();

				while (it1.hasNext())
					if (it1.next() != it2.next())
						throw new my_exception(argu+"."+name+": different args types");
			}
		}

		n.f7.accept(this, argu + "#" + name);
		return null;
	}

	/**
	 * f0 -> Type()
	 * f1 -> Identifier()
	 */
	public String visit(FormalParameter n, String argu) throws Exception {
		String type, name, class_name, function_name;
		String [] parts = argu.split("#");

		type = n.f0.accept(this, "");
		name = n.f1.accept(this, "");
		class_name = parts[0];
		function_name = parts[1];
		LinkedHashMap<String, String> func_args = classes.get(class_name).funcs.get(function_name).args;

		if (func_args.containsKey(name))
			throw new my_exception(class_name+"."+function_name+"."+name+": redeclaration");

		func_args.put(name, type);
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
	public String visit(Identifier n, String argu) throws Exception{
		return String.valueOf(n.f0);
	}

	/**
	 * f0 -> <INTEGER_LITERAL>
	 */
	public String visit(IntegerLiteral n, String argu) throws Exception {
		return "int";
	}

	/**
	 * f0 -> "true"
	 */
	public String visit(TrueLiteral n, String argu) throws Exception {
		 return "boolean";
	}

	/**
	 * f0 -> "false"
	 */
	public String visit(FalseLiteral n, String argu) throws Exception {
		 return "boolean";
	}

}
