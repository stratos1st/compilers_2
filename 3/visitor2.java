import syntaxtree.*;
import java.util.*;
import java.lang.Character.*;
import visitor.GJDepthFirst;

public class visitor2 extends GJDepthFirst<String, String> {

	String ans_str="";
	int curr_var_name=0, curr_tag_name=0;

	//keeps all offsets
	public static LinkedHashMap<String, LinkedHashMap<String, Pair<String, String>>> class_func_offsets = new LinkedHashMap<String, LinkedHashMap<String, Pair<String, String>>>();
	public static LinkedHashMap<String, LinkedHashMap<String, Pair<String, String>>> class_var_offsets = new LinkedHashMap<String, LinkedHashMap<String, Pair<String, String>>>();

	//keeps them ordered to be used for offsets
	public static LinkedHashMap<String, LinkedHashMap<String, String>> class_func_offsets_tmp = new LinkedHashMap<String, LinkedHashMap<String, String>>();
	public static LinkedHashMap<String, LinkedHashMap<String, String>> class_var_offsets_tmp = new LinkedHashMap<String, LinkedHashMap<String, String>>();

	//keeps class sz
	public static LinkedHashMap<String, String> class_sz = new LinkedHashMap<String, String>();


 	//identifier with	! is class name
	//								NONE is variable name
	//								$ is function name
	//								% is declaration name (class of func)

	public String visit(NodeListOptional n, String argu) throws Exception {
     if ( n.present() ) {
        String _ret="";
        int _count=0;
        for ( Enumeration<Node> e = n.elements(); e.hasMoreElements(); ) {
           _ret += "-" + e.nextElement().accept(this,argu);
           _count++;
        }
        return _ret;
     }
     else
        return null;
  }

	/**
	 * f0 -> MainClass()
	 * f1 -> ( TypeDeclaration() )*
	 * f2 -> <EOF>
	 */
	public String visit(Goal n, String argu) throws Exception {
		ans_str=ans_str+"declare i8* @calloc(i32, i32)\n"
										+"declare i32 @printf(i8*, ...)\n"
										+"declare void @exit(i32)\n"
										+"\n"
										+"@_cint = constant [4 x i8] c\"%d\\0a\\00\"\n"
										+"@_cOOB = constant [15 x i8] c\"Out of bounds\\0a\\00\"\n"
										+"@_cNSZ = constant [15 x i8] c\"Negative size\\0a\\00\"\n"
										+"\n"
										+"define void @throw_nsz() {\n"
								    +"\t%_str = bitcast [15 x i8]* @_cNSZ to i8*\n"
								    +"\tcall i32 (i8*, ...) @printf(i8* %_str)\n"
								    +"\tcall void @exit(i32 1)\n"
								    +"\tret void\n"
										+"}\n"
										+"\n"
										+"define void @print_int(i32 %i) {\n"
										+"\t%_str = bitcast [4 x i8]* @_cint to i8*\n"
										+"\tcall i32 (i8*, ...) @printf(i8* %_str, i32 %i)\n"
										+"\tret void\n"
										+"}\n"
										+"\n"
										+"define void @throw_oob() {\n"
										+"\t%_str = bitcast [15 x i8]* @_cOOB to i8*\n"
										+"\tcall i32 (i8*, ...) @printf(i8* %_str)\n"
										+"\tcall void @exit(i32 1)\n"
										+"\tret void\n"
										+"}\n;----------------------------------------------------------------------------\n"
										+"\n";

		LinkedHashMap<String, LinkedHashMap<String, String>> ordered_funcs = new LinkedHashMap<String, LinkedHashMap<String, String>>();
		LinkedHashMap<String, LinkedHashMap<String, String>> ordered_vars = new LinkedHashMap<String, LinkedHashMap<String, String>>();

		//preparation for get_offsets() and get_class_sz()
		for(String class_name : visitor1.classes.keySet()){//for every class
			ordered_funcs.put(class_name,new LinkedHashMap<String, String>());
			ordered_vars.put(class_name,new LinkedHashMap<String, String>());

			String parent_class = class_name;
			while(!visitor1.classes.get(parent_class).inheritance.equals("")){//add all previus functions (fron parent,...)
				parent_class = visitor1.classes.get(parent_class).inheritance;//search father, grandfather....

				for (String func_name : visitor1.classes.get(parent_class).funcs.keySet()){
					if(func_name.equals("main"))//we dont care about main
						continue;
					else if(ordered_funcs.get(class_name).containsKey(func_name))//we dont want to overload parents func with grandparents
						continue;
					else
						ordered_funcs.get(class_name).put(func_name, parent_class);
					for (String var_name : visitor1.classes.get(parent_class).vars.keySet()){// add variables
						if(ordered_vars.get(class_name).containsKey(var_name))//we dont want to overload parents vars with grandparents
							continue;
						else
							ordered_vars.get(class_name).put(var_name, parent_class);
					}
				}
			}
			for (String func_name : visitor1.classes.get(class_name).funcs.keySet()){// add my new fynctions and update overloaded
				if(!func_name.equals("main"))//we dont care about main
					ordered_funcs.get(class_name).put(func_name, class_name);
				for (String var_name : visitor1.classes.get(class_name).vars.keySet()){// add variables
					if(ordered_vars.get(class_name).containsKey(var_name))//we dont want to overload parents vars with grandparents
						continue;
					else
						ordered_vars.get(class_name).put(var_name, class_name);
				}
			}

			class_func_offsets_tmp.put(class_name, new LinkedHashMap<String, String>(ordered_funcs.get(class_name)));
			class_var_offsets_tmp.put(class_name, new LinkedHashMap<String, String>(ordered_vars.get(class_name)));
		}

		get_offsets();
		// // prints offsets for testing
		// for(String class_name: class_func_offsets.keySet()){
		// 	System.out.println(class_name+" funcs-------------");
		// 	for(String func_name: class_func_offsets.get(class_name).keySet())
		// 		System.out.println(class_func_offsets.get(class_name).get(func_name).getLeft()+"."+func_name+": "+class_func_offsets.get(class_name).get(func_name).getRight());
		// }
		//
		// for(String class_name: class_var_offsets.keySet()){
		// 	System.out.println(class_name+" vars-------------");
		// 	for(String var_name: class_var_offsets.get(class_name).keySet())
		// 		System.out.println(class_var_offsets.get(class_name).get(var_name).getLeft()+"."+var_name+": "+class_var_offsets.get(class_name).get(var_name).getRight());
		// }

		//start printing for v-table
		for(String class_name : visitor1.classes.keySet()){
			if(visitor1.classes.get(class_name).funcs.containsKey("main"))
				continue;
			else
				ans_str+="@."+class_name+"_vtable = global ["+class_func_offsets.get(class_name).size()+" x i8*] [ \n";

			for (String func_name : class_func_offsets.get(class_name).keySet()){
				String func_owner=ordered_funcs.get(class_name).get(func_name);
				String func_type=visitor1.classes.get(func_owner).funcs.get(func_name).return_type;
				if(func_type.equals("int"))
					ans_str+="\ti8* bitcast (i32 (i8*";
				else if(func_type.equals("boolean"))
					ans_str+="\ti8* bitcast (i1 (i8*";
				else if(func_type.equals("int[]"))
					ans_str+="\ti8* bitcast (i32* (i8*";
				else //class
					ans_str+="\ti8* bitcast (i8* (i8*";

				for(String var_name : visitor1.classes.get(func_owner).funcs.get(func_name).args.keySet()){
					String var_type=visitor1.classes.get(func_owner).funcs.get(func_name).args.get(var_name);
					if(var_type.equals("int"))
						ans_str+=",i32";
					else if(var_type.equals("boolean"))
						ans_str+=",i1";
					else if(var_type.equals("int[]"))
						ans_str+=",i32*";
					else// class
						ans_str+=",i8*";
				}

				ans_str+=")* @"+func_owner+"."+func_name+" to i8*),\n";
			}
			ans_str=ans_str.substring(0, ans_str.length() - 2);// deletes last ,\n
			ans_str+="\n]\n\n";
		}

		get_class_sz();
		// prints class_sz for testing
		// for(String class_name: class_sz.keySet())
		// 	System.out.println(class_name+": "+class_sz.get(class_name));

		n.f0.accept(this, argu);
		n.f1.accept(this, argu);
		n.f2.accept(this, argu);
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
		ans_str+="define i32 @main() {\n";

		String name= n.f1.accept(this, "%");
		n.f14.accept(this, name + "#main");
		n.f15.accept(this, name + "#main");

		ans_str=ans_str+"ret i32 0\n"
										+"}\n\n";

		return null;
	}

	/**
	 * f0 -> ClassDeclaration()
	 *       | ClassExtendsDeclaration()
	 */
	public String visit(TypeDeclaration n, String argu) throws Exception {
		 return n.f0.accept(this, argu);
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
		 String id=n.f1.accept(this, argu+"%");
		 // n.f3.accept(this, id);
		 n.f4.accept(this, id);
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
		 String id1=n.f1.accept(this, argu+"%");
		 String id2=n.f3.accept(this, argu+"%");
		 // n.f5.accept(this, id1);
		 n.f6.accept(this, id1);
		 return null;
	}

	/**
	 * f0 -> Type()
	 * f1 -> Identifier()
	 * f2 -> ";"
	 */
	public String visit(VarDeclaration n, String argu) throws Exception {
		String type=n.f0.accept(this, argu);
		String id=n.f1.accept(this, argu+"%");

		String [] parts = id.split("#");
		String var_name = parts[0];
		// String type = parts[1];

		ans_str+="%"+var_name+" = alloca "+get_type(type)+"\n";
		if(type.equals("int") || type.equals("boolean"))
			ans_str+="store "+get_type(type)+" 0, "+get_type(type)+"* %"+var_name+"\n";
		else
			ans_str+="store "+get_type(type)+" null, "+get_type(type)+"* %"+var_name+"\n";

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
		n.f1.accept(this, argu);
		String id=n.f2.accept(this, argu+"%");

		ans_str+="define "+get_type(visitor1.classes.get(argu).funcs.get(id).return_type)+" @"+argu+"."+id+"(i8* %this";

		for(String var_name: visitor1.classes.get(argu).funcs.get(id).args.keySet())
				ans_str+=", "+get_type(visitor1.classes.get(argu).funcs.get(id).args.get(var_name))+" %."+var_name;
		ans_str+="){\n";

		//allocate function arguments
		for(String var_name: visitor1.classes.get(argu).funcs.get(id).args.keySet()){
			ans_str+="%"+var_name+" = alloca "+get_type(visitor1.classes.get(argu).funcs.get(id).args.get(var_name))+"\n";
			// if(visitor1.class_funcs_args.get(argu).get(id).get(var_name).equals("int") ||
			// 						visitor1.class_funcs_args.get(argu).get(id).get(var_name).equals("boolean"))
				ans_str+="store "+get_type(visitor1.classes.get(argu).funcs.get(id).args.get(var_name))+" %."+var_name+
									", "+get_type(visitor1.classes.get(argu).funcs.get(id).args.get(var_name))+"* %"+var_name+"\n";
		}

		n.f7.accept(this, argu+"#"+id);
		n.f8.accept(this, argu+"#"+id);

		// return
		String result=n.f10.accept(this, argu+"#"+id);
		String [] parts = result.split("#");
		String ans = parts[0];
		String ans_type = parts[1];
		if(ans_type.equals("int[]")){//den ine 100% sosto px this.foo()
			String new_ans=next_name();
			ans_str+=new_ans+" = load "+get_type(ans_type)+", "+get_type(ans_type)+"* "+ans+"\n";
			ans=new_ans;
		}
		ans_str+="ret "+get_type(ans_type)+" "+ans+"\n}\n\n";

		return null;
	}

	/**
	 * f0 -> FormalParameter()
	 * f1 -> FormalParameterTail()
	 */
	public String visit(FormalParameterList n, String argu) throws Exception {
		 String _ret=null;
		 n.f0.accept(this, argu);
		 n.f1.accept(this, argu);
		 return _ret;
	}

	/**
	 * f0 -> Type()
	 * f1 -> Identifier()
	 */
	public String visit(FormalParameter n, String argu) throws Exception {
		 String _ret=null;
		 n.f0.accept(this, argu);
		 n.f1.accept(this, argu+"%");
		 return _ret;
	}

	/**
	 * f0 -> ( FormalParameterTerm() )*
	 */
	public String visit(FormalParameterTail n, String argu) throws Exception {
		 return n.f0.accept(this, argu);
	}

	/**
	 * f0 -> ","
	 * f1 -> FormalParameter()
	 */
	public String visit(FormalParameterTerm n, String argu) throws Exception {
		 String _ret=null;
		 n.f0.accept(this, argu);
		 n.f1.accept(this, argu);
		 return _ret;
	}

	/**
	 * f0 -> ArrayType()
	 *       | BooleanType()
	 *       | IntegerType()
	 *       | Identifier()
	 */
	public String visit(Type n, String argu) throws Exception {
		 return n.f0.accept(this, argu+"%");
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
	 * f0 -> Block()
	 *       | AssignmentStatement()
	 *       | ArrayAssignmentStatement()
	 *       | IfStatement()
	 *       | WhileStatement()
	 *       | PrintStatement()
	 */
	public String visit(Statement n, String argu) throws Exception {
		 return n.f0.accept(this, argu);
	}

	/**
	 * f0 -> "{"
	 * f1 -> ( Statement() )*
	 * f2 -> "}"
	 */
	public String visit(Block n, String argu) throws Exception {
		 String _ret=null;
		 n.f0.accept(this, argu);
		 n.f1.accept(this, argu);
		 n.f2.accept(this, argu);
		 return _ret;
	}

	/**
	 * f0 -> Identifier()
	 * f1 -> "="
	 * f2 -> Expression()
	 * f3 -> ";"
	 */
	public String visit(AssignmentStatement n, String argu) throws Exception {
		String id_tmp=n.f0.accept(this, argu+"%");
		String [] parts = argu.split("#");
		String class_name = parts[0];
		String func_name = parts[1];
		String var_name="", var_type="";

		if(visitor1.classes.get(class_name).funcs.get(func_name).vars.containsKey(id_tmp) ||
					visitor1.classes.get(class_name).funcs.get(func_name).args.containsKey(id_tmp)){

			String id=n.f0.accept(this, argu);
			String [] parts1 = id.split("#");
			var_name = parts1[0];
			var_type = parts1[1];
		}
		else{
			var_type=visitor1.classes.get(class_var_offsets.get(class_name).get(id_tmp).getLeft()).vars.get(id_tmp);
			String tmp_ptr=next_name();
			ans_str+=tmp_ptr+" = getelementptr i8, i8* %this, i32 "+class_var_offsets.get(class_name).get(id_tmp).getRight()+"\n";
			var_name=next_name();
			ans_str+=var_name+" = bitcast i8* "+tmp_ptr+" to "+get_type(var_type)+"*\n";
		}

		String val=n.f2.accept(this, argu);
		String [] parts2 = val.split("#");
		String value = parts2[0];
		// String var_type = parts2[1];

		ans_str+="store "+get_type(var_type)+" "+value+", "+get_type(var_type)+"* "+var_name+"\n";

		return null;
	}

	/**
	 * f0 -> Identifier()
	 * f1 -> "["
	 * f2 -> Expression()
	 * f3 -> "]"
	 * f4 -> "="
	 * f5 -> Expression()
	 * f6 -> ";"
	 */
	public String visit(ArrayAssignmentStatement n, String argu) throws Exception {
		String id=n.f0.accept(this, argu);
		String [] parts1 = id.split("#");
		String var_name = parts1[0];
		String var_type = parts1[1];

		String expr1=n.f2.accept(this, argu);
		String [] parts2 = expr1.split("#");
		String index = parts2[0];
		// String var_type = parts2[1];

		String expr2=n.f5.accept(this, argu);
		String [] parts3 = expr2.split("#");
		String expr = parts3[0];
		// String var_type = parts3[1];

		String [] parts = argu.split("#");
		String class_name = parts[0];
		String func_name = parts[1];
		//if class variable
		if(!visitor1.classes.get(class_name).funcs.get(func_name).vars.containsKey(var_name.substring(1,var_name.length())) &&
		!visitor1.classes.get(class_name).funcs.get(func_name).args.containsKey(var_name.substring(1,var_name.length()))){
			String tmp_ptr=next_name();
			ans_str+=tmp_ptr+" = getelementptr i8, i8* %this, i32 "+class_var_offsets.get(class_name).get(var_name.substring(1,var_name.length())).getRight()+"\n";
			String ptr=next_name();
			var_type=visitor1.classes.get(class_var_offsets.get(class_name).get(var_name.substring(1,var_name.length())).getLeft()).vars.get(var_name.substring(1,var_name.length()));
			ans_str+=ptr+" = bitcast i8* "+tmp_ptr+" to "+get_type(var_type)+"*\n";
			var_name=ptr;
		}

		if(var_type.equals("int[]")){
			//load address and size
			String array_ptr=next_name();
			ans_str+=array_ptr+" = load i32*, i32** "+var_name+"\n";
			String sz=next_name();
			ans_str+=sz+" = load i32, i32* "+array_ptr+"\n";

			//Check that the index is greater than zero
			String cond1=next_name();
			ans_str+=cond1+" = icmp sge i32 "+index+", 0\n";

			//Check that the index is less than the size of the array
			String cond2=next_name();
			ans_str+=cond2+" = icmp slt i32 "+index+", "+sz+"\n";

			//Both of these conditions must hold
			String cond=next_name();
			String err_tag=next_tag(), ok_tag=next_tag();
			ans_str+=cond+" = and i1 "+cond1+", "+cond2+"\n";
			ans_str+="br i1 "+cond+", label %"+ok_tag+", label %"+err_tag+"\n";

			// Else throw out of bounds exception
			ans_str+=err_tag+":\n";
			ans_str+="call void @throw_oob()\n";
			ans_str+="br label %"+ok_tag+"\n";

			// All ok, we can safely index the array now
			ans_str+=ok_tag+":\n";
			// Add one to the index
			String new_index=next_name();
			ans_str+=new_index+" = add i32 1, "+index+"\n";
			//Get pointer to the element
			String ptr=next_name();
			ans_str+=ptr+" = getelementptr i32, i32* "+array_ptr+", i32 "+new_index+"\n";
			//store
			ans_str+="store i32 "+expr+", i32* "+ptr+"\n";
		}
		else{
			System.out.println(var_type+" "+var_name+" "+expr1+" "+expr2);
			System.out.println("\n\n!! ERROR ArrayAssignmentStatement !!\n\n");
			System.out.println(ans_str);
			System.exit(1);
		}

		return null;
	}

	/**
	 * f0 -> "if"
	 * f1 -> "("
	 * f2 -> Expression()
	 * f3 -> ")"
	 * f4 -> Statement()
	 * f5 -> "else"
	 * f6 -> Statement()
	 */
	public String visit(IfStatement n, String argu) throws Exception {
		String expr=n.f2.accept(this, argu);
		String then_label=next_tag(), else_label=next_tag(), end_label=next_tag();
		String [] parts = expr.split("#");
		String var_name = parts[0];
		// String var_type = parts[1];

		ans_str+=";IfStatement\n";

		ans_str+="br i1 "+var_name+", label %"+then_label+", label %"+else_label+"\n";

		ans_str+=then_label+":\n";
		n.f4.accept(this, argu);
		ans_str+="br label %"+end_label+"\n";

		ans_str+=else_label+":\n";
		n.f6.accept(this, argu);
		ans_str+="br label %"+end_label+"\n";

		ans_str+=end_label+":\n";

		return null;
	}

	/**
	 * f0 -> "while"
	 * f1 -> "("
	 * f2 -> Expression()
	 * f3 -> ")"
	 * f4 -> Statement()
	 */
	public String visit(WhileStatement n, String argu) throws Exception {
		String tag1=next_tag(), tag2=next_tag(), tag3=next_tag();

		ans_str+=";WhileStatement\n";
		ans_str+="br label %"+tag1+"\n";

		//check if statment is true
		ans_str+=tag1+":\n";
		String expr=n.f2.accept(this, argu);
		String [] parts = expr.split("#");
		String expr_val = parts[0];
		// String var_type = parts[1];
		ans_str+="br i1 "+expr_val+", label %"+tag2+", label %"+tag3+"\n";

		//if true
		ans_str+=tag2+":\n";
		n.f4.accept(this, argu);
		//loop back
		ans_str+="br label %"+tag1+"\n";

		//if false
		ans_str+=tag3+":\n";

		return null;
	}

	/**
	 * f0 -> "System.out.println"
	 * f1 -> "("
	 * f2 -> Expression()
	 * f3 -> ")"
	 * f4 -> ";"
	 */
	public String visit(PrintStatement n, String argu) throws Exception {
		String expr=n.f2.accept(this, argu);
		String [] parts = expr.split("#");
		String var_name = parts[0];
		// String var_type = parts[1];

		ans_str+="call void (i32) @print_int(i32 "+var_name+")\n";

		return null;
	}

	/**
	 * f0 -> AndExpression()
	 *       | CompareExpression()
	 *       | PlusExpression()
	 *       | MinusExpression()
	 *       | TimesExpression()
	 *       | ArrayLookup()
	 *       | ArrayLength()
	 *       | MessageSend()
	 *       | Clause()
	 */
	public String visit(Expression n, String argu) throws Exception {
		 return n.f0.accept(this, argu);
	}

	/**
	 * f0 -> Clause()
	 * f1 -> "&&"
	 * f2 -> Clause()
	 */
	public String visit(AndExpression n, String argu) throws Exception {
		ans_str+=";AndExpression\n";
		String a=n.f0.accept(this, argu);
		String [] partsa = a.split("#");
		String a_name = partsa[0];
		// String var_type = partsa[1];
		String tag1=next_tag(), tag2=next_tag(), tag3=next_tag(), tag4=next_tag();

		ans_str+="br i1 "+a_name+", label %"+tag2+", label %"+tag1+"\n";

		ans_str+=tag1+":\n";
		ans_str+="br label %"+tag4+"\n";

		ans_str+=tag2+":\n";
		String b=n.f2.accept(this, argu);
		String [] partsb = b.split("#");
		String b_name = partsb[0];
		// String var_type = partsb[1];
		ans_str+="br label %"+tag3+"\n";

		ans_str+=tag3+":\n";
		ans_str+="br label %"+tag4+"\n";

		ans_str+=tag4+":\n";
		String ans=next_name();
		ans_str+=ans+" = phi i1  [ 0, %"+tag1+" ], [ "+b_name+", %"+tag3+" ]\n";

		return ans+"#boolean";
	}

	/**
	 * f0 -> PrimaryExpression()
	 * f1 -> "<"
	 * f2 -> PrimaryExpression()
	 */
	public String visit(CompareExpression n, String argu) throws Exception {
		String a=n.f0.accept(this, argu);
		String b=n.f2.accept(this, argu);
		String tmp_var=next_name();
		String [] partsa = a.split("#");
		String a_name = partsa[0];
		// String var_type = partsa[1];
		String [] partsb = b.split("#");
		String b_name = partsb[0];
		// String var_type = partsb[1];

		ans_str+=tmp_var+" = icmp slt i32 "+a_name+", "+b_name+"\n";

		return tmp_var+"#boolean";
	}

	/**
	 * f0 -> PrimaryExpression()
	 * f1 -> "+"
	 * f2 -> PrimaryExpression()
	 */
	public String visit(PlusExpression n, String argu) throws Exception {
		String tmp_var=next_name();
		String a=n.f0.accept(this, argu);
		String b=n.f2.accept(this, argu);
		String [] partsa = a.split("#");
		String a_name = partsa[0];
		// String var_type = partsa[1];
		String [] partsb = b.split("#");
		String b_name = partsb[0];
		// String var_type = partsb[1];

		ans_str+=tmp_var+" = add i32 "+a_name+", "+b_name+"\n";

		return tmp_var+"#int";
	}

	/**
	 * f0 -> PrimaryExpression()
	 * f1 -> "-"
	 * f2 -> PrimaryExpression()
	 */
	public String visit(MinusExpression n, String argu) throws Exception {
		String tmp_var=next_name();
		String a=n.f0.accept(this, argu);
		String b=n.f2.accept(this, argu);
		String [] partsa = a.split("#");
		String a_name = partsa[0];
		// String var_type = partsa[1];
		String [] partsb = b.split("#");
		String b_name = partsb[0];
		// String var_type = partsb[1];

		ans_str+=tmp_var+" = sub i32 "+a_name+", "+b_name+"\n";

		return tmp_var+"#int";
	}

	/**
	 * f0 -> PrimaryExpression()
	 * f1 -> "*"
	 * f2 -> PrimaryExpression()
	 */
	public String visit(TimesExpression n, String argu) throws Exception {
		String tmp_var=next_name();
		String a=n.f0.accept(this, argu);
		String b=n.f2.accept(this, argu);
		String [] partsa = a.split("#");
		String a_name = partsa[0];
		// String var_type = partsa[1];
		String [] partsb = b.split("#");
		String b_name = partsb[0];
		// String var_type = partsb[1];

		ans_str+=tmp_var+" = mul i32 "+a_name+", "+b_name+"\n";

		return tmp_var+"#int";
	}

	/**
	 * f0 -> PrimaryExpression()
	 * f1 -> "["
	 * f2 -> PrimaryExpression()
	 * f3 -> "]"
	 */
	public String visit(ArrayLookup n, String argu) throws Exception {
		String id=n.f0.accept(this, argu);
		String [] parts1 = id.split("#");
		String var_name = parts1[0];
		String var_type = parts1[1];

		String expr1=n.f2.accept(this, argu);
		String [] parts2 = expr1.split("#");
		String index = parts2[0];
		// String var_type = parts2[1];

		String [] parts = argu.split("#");
		String class_name = parts[0];
		String func_name = parts[1];
		//if class variable
		if(!visitor1.classes.get(class_name).funcs.get(func_name).vars.containsKey(var_name.substring(1,var_name.length())) &&
		!visitor1.classes.get(class_name).funcs.get(func_name).args.containsKey(var_name.substring(1,var_name.length()))){
			if(class_var_offsets.get(class_name).containsKey(var_name.substring(1,var_name.length()))){//if not (a.foo())[2]
				String tmp_ptr=next_name();
				ans_str+=tmp_ptr+" = getelementptr i8, i8* %this, i32 "+class_var_offsets.get(class_name).get(var_name.substring(1,var_name.length())).getRight()+"\n";
				String ptr=next_name();
				var_type=visitor1.classes.get(class_var_offsets.get(class_name).get(var_name.substring(1,var_name.length())).getLeft()).vars.get(var_name.substring(1,var_name.length()));
				ans_str+=ptr+" = bitcast i8* "+tmp_ptr+" to "+get_type(var_type)+"*\n";
				var_name=ptr;
			}
			else{
				String ptr=next_name();
				ans_str+=ptr+" = bitcast i8* "+var_name+" to "+get_type(var_type)+"*\n";
				var_name=ptr;
			}
		}

		if(var_type.equals("int[]")){
			//load address and size
			String array_ptr=next_name();
			ans_str+=array_ptr+" = load i32*, i32** "+var_name+"\n";
			String sz=next_name();
			ans_str+=sz+" = load i32, i32* "+array_ptr+"\n";

			//Check that the index is greater than zero
			String cond1=next_name();
			ans_str+=cond1+" = icmp sge i32 "+index+", 0\n";

			//Chech that the index is less than the size of the array
			String cond2=next_name();
			ans_str+=cond2+" = icmp slt i32 "+index+", "+sz+"\n";

			//Both of these conditions must hold
			String cond=next_name();
			String err_tag=next_tag(), ok_tag=next_tag();
			ans_str+=cond+" = and i1 "+cond1+", "+cond2+"\n";
			ans_str+="br i1 "+cond+", label %"+ok_tag+", label %"+err_tag+"\n";

			// Else throw out of bounds exception
			ans_str+=err_tag+":\n";
			ans_str+="call void @throw_oob()\n";
			ans_str+="br label %"+ok_tag+"\n";

			// All ok, we can safely index the array now
			ans_str+=ok_tag+":\n";
			// Add one to the index
			String new_index=next_name();
			ans_str+=new_index+" = add i32 1, "+index+"\n";
			//Get pointer to the element
			String ptr=next_name();
			ans_str+=ptr+" = getelementptr i32, i32* "+array_ptr+", i32 "+new_index+"\n";
			//load
			String array_val=next_name();
			ans_str+=array_val+" = load i32, i32* "+ptr+"\n";

			return array_val+"#int";
		}
		else{
			System.out.println(var_type+" "+var_name+" "+expr1);
			System.out.println("\n\n!! ERROR ArrayLookup !!\n\n");
			System.out.println(ans_str);
			System.exit(1);
		}

		//return array_val+"#"+var_type;
		return null;
	}

	/**
	 * f0 -> PrimaryExpression()
	 * f1 -> "."
	 * f2 -> "length"
	 */
	public String visit(ArrayLength n, String argu) throws Exception {
		String expr=n.f0.accept(this, argu);
		String [] parts = expr.split("#");
		String var_name = parts[0];
		String var_type = parts[1];

		String tmp_var=next_name();
		String tmp_var2=next_name();

		if(var_type.equals("int[]")){
			ans_str+=tmp_var2+" = load i32*, i32** "+var_name+"\n";
			ans_str+=tmp_var+" = load i32, i32* "+tmp_var2+"\n";
			var_type="int";
		}
		else{
			System.out.println("\n\n!! ERROR ArrayLength !!\n\n");
			System.exit(1);
		}

		return tmp_var+"#"+var_type;
	}

	/**
	 * f0 -> PrimaryExpression()
	 * f1 -> "."
	 * f2 -> Identifier()
	 * f3 -> "("
	 * f4 -> ( ExpressionList() )?
	 * f5 -> ")"
	 */
	public String visit(MessageSend n, String argu) throws Exception {
		String obj=n.f0.accept(this, argu);
		String [] parts = obj.split("#");
		String obj_name = parts[0];
		String obj_type = parts[1];

		String id=n.f2.accept(this, argu+"$"+obj_type);
		String [] parts1 = id.split("#");
		String func_name = parts1[0];
		String func_type = parts1[1];

		String func_owner=class_func_offsets.get(obj_type).get(func_name).getLeft();

		//load the object pointer
		// String obj_ptr=next_name();
		// ans_str+=obj_ptr+" = load i8*, i8** "+obj_name+"\n";

		//Load vtable_ptr
		String vtable_ptr_tmp=next_name();
		ans_str+=vtable_ptr_tmp+" = bitcast i8* "+obj_name+" to i8***\n";
		String vtable_ptr=next_name();
		ans_str+=vtable_ptr+" = load i8**, i8*** "+vtable_ptr_tmp+"\n";

		//get function ptr
		String func_ptr_tmp=next_name();
		ans_str+=func_ptr_tmp+" = getelementptr i8*, i8** "+vtable_ptr+", i32 "+Integer.parseInt(class_func_offsets.get(obj_type).get(func_name).getRight())/8+"\n";
		String func_ptr_tmp2=next_name();
		ans_str+=func_ptr_tmp2+" = load i8*, i8** "+func_ptr_tmp+"\n";
		String func_ptr=next_name();
		ans_str+=func_ptr+" = bitcast i8* "+func_ptr_tmp2+" to "+get_type(func_type)+" (i8*";

		for(String var_name : visitor1.classes.get(func_owner).funcs.get(func_name).args.keySet()){
			String var_type=visitor1.classes.get(func_owner).funcs.get(func_name).args.get(var_name);
				ans_str+=","+get_type(var_type);
		}
		ans_str+=")*\n";

		//Perform the call
		String tmp=n.f4.accept(this, argu);
		String[] expression_list;
		if (tmp!=null)
			expression_list = tmp.split("-");
		else
			expression_list=new String[0];
		//load nessesary variables (not loaded before)
		String [] variable_names=new String[expression_list.length];
		for(int i=0;i<expression_list.length;i++){
			String [] parts2 = expression_list[i].split("#");
			String var_name = parts2[0];
			String var_type = parts2[1];
			if(var_type.equals("int[]") && !var_name.contains("%_")){//if array ptr load first
				String array_ptr=next_name();
				ans_str+=array_ptr+" = load "+get_type(var_type)+", "+get_type(var_type)+"* "+var_name+"\n";
				variable_names[i]=array_ptr;
			}
			else
				variable_names[i]=var_name;
		}
		//call function with correct variables
		String result=next_name();
		ans_str+=result+" = call "+get_type(func_type)+" "+func_ptr+"(i8* "+obj_name;
		for(int i=0;i<expression_list.length;i++){
			String [] parts2 = expression_list[i].split("#");
			// String var_name = parts2[0];
			String var_type = parts2[1];
			ans_str+=", "+get_type(var_type)+" "+variable_names[i];
		}
		ans_str+=")\n";

		return result+"#"+func_type;
	}

	/**
	 * f0 -> Expression()
	 * f1 -> ExpressionTail()
	 */
	public String visit(ExpressionList n, String argu) throws Exception {
		String arg1=n.f0.accept(this, argu), arg_list="";
    if(arg1!=null){
      arg_list += arg1;//.replace("*", "");
      String argn=n.f1.accept(this, argu);
      if (argn!=null)
        arg_list += argn;
    }
    return arg_list;
	}

	/**
	 * f0 -> ","
	 * f1 -> Expression()
	 */
	public String visit(ExpressionTerm n, String argu) throws Exception {
		String argn=n.f1.accept(this, argu);
		if (argn!=null)
			return argn;//.replace("*", "");
		else
			return null;
	}

	/**
	 * f0 -> NotExpression()
	 *       | PrimaryExpression()
	 */
	public String visit(Clause n, String argu) throws Exception {
		 return n.f0.accept(this, argu);
	}

	/**
	 * f0 -> IntegerLiteral()
	 *       | TrueLiteral()
	 *       | FalseLiteral()
	 *       | Identifier()
	 *       | ThisExpression()
	 *       | ArrayAllocationExpression()
	 *       | AllocationExpression()
	 *       | BracketExpression()
	 */
	public String visit(PrimaryExpression n, String argu) throws Exception {
		String expr=n.f0.accept(this, argu);

		if(expr.contains(")"))
			return expr.substring(0, expr.length() - 1);

		if(expr.contains("!!"))//if INTEGER_LITERAL
			return expr.substring(0, expr.length() - 2)+"#int";
		else if(expr.contains("!"))//if 1,0
			return expr.substring(0, expr.length() - 1)+"#boolean";

		String [] parts1 = argu.split("#");
		String class_name = parts1[0];
		String func_name = parts1[1];

		if(expr.equals("%this"))
			return expr+"#"+class_name;

		String [] parts = expr.split("#");
		String var_name = parts[0];
		String var_type = parts[1];

		if(var_type.equals("int[]") || var_type.contains("&"))//if new
			return expr.replace("&","");

		if(expr.contains("#")){// if variable name
			if(visitor1.classes.get(class_name).funcs.get(func_name).args.containsKey(var_name.substring(1,var_name.length())) ||
					visitor1.classes.get(class_name).funcs.get(func_name).vars.containsKey(var_name.substring(1,var_name.length()))){//not class var
				String tmp_var=next_name();
				// if(var_type.equals("int") || var_type.equals("boolean"))
				ans_str+=tmp_var+" = load "+get_type(var_type)+", "+get_type(var_type)+"* "+var_name+"\n";

				return tmp_var+"#"+var_type;
			}
			else{//class variable
				String tmp_ptr=next_name();
		    ans_str+=tmp_ptr+" = getelementptr i8, i8* %this, i32 "+class_var_offsets.get(class_name).get(var_name.substring(1,var_name.length())).getRight()+"\n";
				String ptr=next_name();
				var_type=visitor1.classes.get(class_var_offsets.get(class_name).get(var_name.substring(1,var_name.length())).getLeft()).vars.get(var_name.substring(1,var_name.length()));
		    ans_str+=ptr+" = bitcast i8* "+tmp_ptr+" to "+get_type(var_type)+"*\n";
				String tmp_var=next_name();
				ans_str+=tmp_var+" = load "+get_type(var_type)+", "+get_type(var_type)+"* "+ptr+"\n";

				return tmp_var+"#"+var_type;
			}
		}

		//if other identifier ex class name, function name etc
		return expr;
	}

	/**
	 * f0 -> <INTEGER_LITERAL>
	 */
	public String visit(IntegerLiteral n, String argu) throws Exception {
		String a=String.valueOf(n.f0);

		return a+"!!";
	}

	/**
	 * f0 -> "true"
	 */
	public String visit(TrueLiteral n, String argu) throws Exception {
		return "1!";
	}

	/**
	 * f0 -> "false"
	 */
	public String visit(FalseLiteral n, String argu) throws Exception {
		return "0!";
	}

	/**
	 * f0 -> <IDENTIFIER>
	 */
	public String visit(Identifier n, String argu) throws Exception {
		String id=String.valueOf(n.f0);

		if(argu.equals(""))//main class
			return id;
		else if(argu.contains("!")){//class name
			return id;
		}
		else if(argu.contains("$")){// function name
			String [] parts = argu.split("#");
			String class_name = parts[0];
			String func_name_tmp = parts[1];
			String [] parts1 = func_name_tmp.split("\\$");
			// String func_name = parts1[0];
			String obj_type = parts1[1];

			String return_type=visitor1.classes.get(class_func_offsets.get(obj_type).get(id).getLeft()).funcs.get(id).return_type;

			if(return_type==null){//error
				System.out.println(class_name+" "+obj_type+" "+id);
				System.out.println("\n\n!! ERROR Identifier 1 !!\n\n");
				System.out.println(ans_str);
				System.exit(1);
			}

			return id+"#"+return_type;
		}
		else if(argu.contains("%"))// declaration name
			return id;
		else{// variable name
			String [] parts = argu.split("#");
			String class_name = parts[0];
			String var_type="";

			if(parts.length==2){//in function var call
				String function_name = parts[1];
				if(visitor1.classes.get(class_name).funcs.get(function_name).vars.get(id)==null)
					var_type=visitor1.classes.get(class_name).funcs.get(function_name).args.get(id);
				else
					var_type=visitor1.classes.get(class_name).funcs.get(function_name).vars.get(id);
				if(var_type==null)
					var_type=visitor1.classes.get(class_var_offsets.get(class_name).get(id).getLeft()).vars.get(id);
			}
			else//class var
				var_type=visitor1.classes.get(class_var_offsets.get(class_name).get(id).getLeft()).vars.get(id);

			if(var_type==null){//error
				System.out.println(class_name+" "+id);
				System.out.println("\n\n!! ERROR Identifier 2 !!\n\n");
				System.out.println(ans_str);
				System.exit(1);
			}

			return "%"+id+"#"+var_type;
		}

	}

	/**
	 * f0 -> "this"
	 */
	public String visit(ThisExpression n, String argu) throws Exception {
		String [] parts = argu.split("#");
		String class_name = parts[0];
		// String func_name = parts[1];
		return "%this";
	}

	/**
	 * f0 -> "new"
	 * f1 -> "int"
	 * f2 -> "["
	 * f3 -> Expression()
	 * f4 -> "]"
	 */
	public String visit(ArrayAllocationExpression n, String argu) throws Exception {
		String expr=n.f3.accept(this, argu);
		String [] parts = expr.split("#");
		String sz = parts[0];
		// String var_type = parts[1];

		//add 1 to size
		String new_sz=next_name();
		ans_str+=new_sz+" = add i32 1, "+sz+"\n";

		//check if size is >1
		String err_tag=next_tag(), ok_tag=next_tag();
		String cond=next_name();
		ans_str+=cond+" = icmp sge i32 "+new_sz+", 1\n";
		ans_str+="br i1 "+cond+", label %"+ok_tag+", label %"+err_tag+"\n";
		//if size is >1
		ans_str+=err_tag+":\n";
		ans_str+="call void @throw_nsz()\n";
		ans_str+="br label %"+ok_tag+"\n";
		//else
		ans_str+=ok_tag+":\n";

		//allocate Array
		String array_ptr_tmp=next_name();
		ans_str+=array_ptr_tmp+" = call i8* @calloc(i32 "+new_sz+", i32 4)\n";
		String array_ptr=next_name();
		ans_str+=array_ptr+" = bitcast i8* "+array_ptr_tmp+" to i32*\n";

		// store the size of the array in the first position of the array
    ans_str+="store i32 "+sz+", i32* "+array_ptr+"\n";

		return array_ptr+"#int[]";
	}

	/**
	 * f0 -> "new"
	 * f1 -> Identifier()
	 * f2 -> "("
	 * f3 -> ")"
	 */
	public String visit(AllocationExpression n, String argu) throws Exception {
		String class_name=n.f1.accept(this, argu+"%");
		// String [] parts = id.split("#");
		// String class_name = parts[0];
		// String var_type = parts[1];

		String obj_ptr=next_name();
		ans_str+=obj_ptr+" = call i8* @calloc(i32 1, i32 "+class_sz.get(class_name)+")\n";
		String vtable_ptr=next_name();
		ans_str+=vtable_ptr+" = bitcast i8* "+obj_ptr+" to i8***\n";

		String vtable=next_name();
		ans_str+=vtable+" = getelementptr ["+class_func_offsets.get(class_name).size()+" x i8*], ["+class_func_offsets.get(class_name).size()+" x i8*]* @."+class_name+"_vtable, i32 0, i32 0\n";

		ans_str+="store i8** "+vtable+", i8*** "+vtable_ptr+"\n";

		return obj_ptr+"#"+class_name+"&";
	}

	/**
	 * f0 -> "!"
	 * f1 -> Clause()
	 */
	public String visit(NotExpression n, String argu) throws Exception {
		String clau=n.f1.accept(this, argu);
		String [] parts = clau.split("#");
		String var_name = parts[0];
		// String var_type = parts[1];
		String tmp_var=next_name();

		ans_str+=tmp_var+" = xor i1 1, "+var_name+"\n";

		return tmp_var+"#boolean";
	}

	/**
	 * f0 -> "("
	 * f1 -> Expression()
	 * f2 -> ")"
	 */
	public String visit(BracketExpression n, String argu) throws Exception {
		return n.f1.accept(this, argu)+")";//.split("#")[0];
	}

	//returns next variable name
	public String next_name(){
		String ans=String.valueOf(curr_var_name);
		curr_var_name++;
		return "%_"+ans;
	}

	//returns next tag name
	public String next_tag(){
		String ans=String.valueOf(curr_tag_name);
		curr_tag_name++;
		return "tag_"+ans;
	}

	//returns if string is numeric
	public static boolean isNumeric(String str){
    for (char c : str.toCharArray())
        if (!Character.isDigit(c))
					return false;
    return true;
	}

	// fills class_var_offsets and class_func_offsets
	public static void get_offsets(){
		//get functions from previus classes
		for(String class_name: class_func_offsets_tmp.keySet()){
			class_func_offsets.put(class_name, new LinkedHashMap<String, Pair<String, String>>());
			for(String owner_name : offset.owner_func_offsets.keySet())
				for(String func_name : offset.owner_func_offsets.get(owner_name).keySet())
					if(class_func_offsets_tmp.get(class_name).containsKey(func_name)){
						String parent_class = class_name;
						while(!visitor1.classes.get(parent_class).inheritance.equals("")){//search father, grandfather....
							parent_class = visitor1.classes.get(parent_class).inheritance;
							class_func_offsets.get(class_name).put(func_name, new Pair<String, String>(owner_name,offset.owner_func_offsets.get(owner_name).get(func_name)));
						}
					}
		}
		//add my functions
		for(String class_name: class_func_offsets_tmp.keySet())
			for(String func_name : offset.owner_func_offsets.get(class_name).keySet())
				class_func_offsets.get(class_name).put(func_name, new Pair<String, String>(class_name,offset.owner_func_offsets.get(class_name).get(func_name)));

		//get variables from previus classes
		for(String class_name: class_var_offsets_tmp.keySet()){
			class_var_offsets.put(class_name, new LinkedHashMap<String, Pair<String, String>>());
			for(String owner_name : offset.owner_var_offsets.keySet())
				for(String var_name : offset.owner_var_offsets.get(owner_name).keySet())
					if(class_var_offsets_tmp.get(class_name).containsKey(var_name)){
						String parent_class = class_name;
						while(!visitor1.classes.get(parent_class).inheritance.equals("")){
							parent_class = visitor1.classes.get(parent_class).inheritance;
							class_var_offsets.get(class_name).put(var_name, new Pair<String, String>(owner_name,offset.owner_var_offsets.get(owner_name).get(var_name)));
						}
					}
		}
		//add my variables
		for(String class_name: class_var_offsets_tmp.keySet())
			for(String var_name : offset.owner_var_offsets.get(class_name).keySet())
				class_var_offsets.get(class_name).put(var_name, new Pair<String, String>(class_name,offset.owner_var_offsets.get(class_name).get(var_name)));

	}

	//fills class_sz
	public static void get_class_sz(){
		int sz=8;

		for (String class_name : class_var_offsets.keySet()){
			sz=8;
			for (String var_name : class_var_offsets.get(class_name).keySet())
				if(visitor1.classes.get(class_var_offsets.get(class_name).get(var_name).getLeft()).vars.get(var_name).equals("int"))
					sz+=4;
				else if(visitor1.classes.get(class_var_offsets.get(class_name).get(var_name).getLeft()).vars.get(var_name).equals("boolean"))
					sz+=1;
				else//int[] class[]
					sz+=8;
			class_sz.put(class_name,String.valueOf(sz));
		}
	}

	public static String get_type(String java_type){
		if(java_type.equals("int"))
			return "i32";
		else if(java_type.equals("boolean"))
			return "i1";
		else if(java_type.equals("int[]"))
			return "i32*";
		else
			return "i8*";
	}

}
