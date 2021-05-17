import syntaxtree.*;
import java.util.*;
import visitor.GJDepthFirst;

public class visitor2 extends GJDepthFirst<String, String> {

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
    n.f14.accept(this, name + "#main");
    n.f15.accept(this, name + "#main");
    return null;
  }

  /**
  * f0 -> "class"
  * f1 -> identifier()
  * f2 -> "{"
  * f3 -> ( VarDeclaration() )*
  * f4 -> ( MethodDeclaration() )*
  * f5 -> "}"
  */
  public String visit(ClassDeclaration n, String argu) throws Exception {
    String name=n.f1.accept(this, argu);
    n.f3.accept(this, name);
    n.f4.accept(this, name);
    return null;
  }

  /**
  * f0 -> "class"
  * f1 -> identifier()
  * f2 -> "extends"
  * f3 -> identifier()
  * f4 -> "{"
  * f5 -> ( VarDeclaration() )*
  * f6 -> ( MethodDeclaration() )*
  * f7 -> "}"
  */
  public String visit(ClassExtendsDeclaration n, String argu) throws Exception {
   String name=n.f1.accept(this, argu);
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
    if(!type.equals("int") && !type.equals("int[]") && !type.equals("boolean"))
      if(!visitor1.classes.containsKey(type.replace("*","")))
        throw new my_exception(var+": wrong type");
    return null;
  }

  /**
  * f0 -> "public"
  * f1 -> Type()
  * f2 -> identifier()
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
    String type = n.f1.accept(this, argu), name = n.f2.accept(this, argu);

    if (!type.equals("int") && !type.equals("int[]") && !type.equals("boolean")
          && !visitor1.classes.containsKey(type))
      throw new my_exception(argu+"."+name+": wrong return type ");

    n.f7.accept(this, argu + "#" + name);
    n.f8.accept(this, argu + "#" + name);
    String return_type = n.f10.accept(this, argu + "#" + name);

    if (return_type.contains("*")){
      return_type = return_type.replace("*","");
      if (return_type.equals(type))
        return null;
      else{
        boolean ok = false;
        String parent_class = return_type;
        while(!visitor1.classes.get(parent_class).inheritance.equals("")){
          parent_class = visitor1.classes.get(parent_class).inheritance;
          if(type.equals(parent_class))
              ok = true;
        }
        if(!ok)
          throw new my_exception(argu+"."+name+": wrong return type ");
        else
          return null;
      }

    }
    else{
      if(return_type.replace("*","").equals(type))
        return null;
      else
        throw new my_exception(argu+"."+name+": wrong return type ");
    }
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
  * f0 -> identifier()
  * f1 -> "="
  * f2 -> Expression()
  * f3 -> ";"
  */
  public String visit(AssignmentStatement n, String argu) throws Exception {
    String lhs = n.f0.accept(this, argu), lhs_type=null;

    //-------------------- lhs
    String [] parts = argu.split("#");
    String class_name = parts[0];
    String function_name = parts[1];
    boolean found = false;

    if(visitor1.classes.get(class_name).funcs.get(function_name).vars.containsKey(lhs)){
      found = true;
      lhs_type = visitor1.classes.get(class_name).funcs.get(function_name).vars.get(lhs);
    }
    else if(visitor1.classes.get(class_name).funcs.get(function_name).args.containsKey(lhs)){
      found = true;
      lhs_type = visitor1.classes.get(class_name).funcs.get(function_name).args.get(lhs);
    }
    else if(visitor1.classes.get(class_name).vars.containsKey(lhs)){
      found = true;
      lhs_type = visitor1.classes.get(class_name).vars.get(lhs);
    }
    else{
      String parent_class=class_name;
      while(!visitor1.classes.get(parent_class).inheritance.equals("")){
        parent_class = visitor1.classes.get(parent_class).inheritance;
        if (visitor1.classes.get(parent_class).vars.containsKey(lhs)){
          found = true;
          lhs_type = visitor1.classes.get(parent_class).vars.get(lhs);
          break;
        }
      }
    }

    if(!found)
      throw new my_exception(class_name+"."+function_name+"."+lhs+": undeclared variable");

    //-------------------- lhs_type == rhs_type ?
    String rhs_type = n.f2.accept(this, argu);
    rhs_type = rhs_type.replace("*", "");

    if(lhs_type.equals("int") || lhs_type.equals("boolean")){
      if (lhs_type.equals(rhs_type))
        return lhs_type;
      else
        throw new my_exception(class_name+"."+function_name+"."+lhs+": incompatible type assigment");
    }
    else{
      if(rhs_type.equals(lhs_type))
        return lhs_type;
      else{
        String parent_class=rhs_type;
        while (!visitor1.classes.get(parent_class).inheritance.equals("")){
          parent_class = visitor1.classes.get(parent_class).inheritance;
          if (parent_class.equals(lhs_type))
            return lhs_type;
        }
      }
    }
    throw new my_exception(class_name+"."+function_name+"."+rhs_type+": incompatible type assigment");
  }

  /**
  * f0 -> identifier()
  * f1 -> "["
  * f2 -> Expression()
  * f3 -> "]"
  * f4 -> "="
  * f5 -> Expression()
  * f6 -> ";"
  */
  public String visit(ArrayAssignmentStatement n, String argu) throws Exception {
   String lhs = n.f0.accept(this, argu), lhs_type=null;

   //-------------------- lhs
   String [] parts = argu.split("#");
   String class_name = parts[0];
   String function_name = parts[1];
   boolean found = false;

   if (visitor1.classes.get(class_name).funcs.get(function_name).vars.containsKey(lhs)){
     found = true;
     lhs_type = visitor1.classes.get(class_name).funcs.get(function_name).vars.get(lhs);
   }
   else if (visitor1.classes.get(class_name).funcs.get(function_name).args.containsKey(lhs)){
     found = true;
     lhs_type = visitor1.classes.get(class_name).funcs.get(function_name).args.get(lhs);
   }
   else if (visitor1.classes.get(class_name).vars.containsKey(lhs)){
     found = true;
     lhs_type = visitor1.classes.get(class_name).vars.get(lhs);
   }
   else{
     String parent_class=class_name;
     while (!visitor1.classes.get(parent_class).inheritance.equals("")){
       parent_class = visitor1.classes.get(parent_class).inheritance;
       if (visitor1.classes.get(parent_class).vars.containsKey(lhs)){
         found = true;
         lhs_type = visitor1.classes.get(parent_class).vars.get(lhs);
       }
     }
   }

  if (!found)
    throw new my_exception(class_name+"."+function_name+"."+lhs+": undeclared variable");

  //-------------------- indexing == int ?
  String index_type = n.f2.accept(this, argu);
  if(!index_type.equals("int"))
    throw new my_exception(class_name+"."+function_name+"."+lhs+"has incorect indexing");

  //-------------------- lhs_type == rhs_type ?
  String rhs_type = n.f5.accept(this, argu);

  rhs_type = rhs_type.replace("*", "");
  if (!lhs_type.replace("[]","").equals(rhs_type))
   throw new my_exception(class_name+"."+function_name+"."+lhs+":incompatible type assignment");

  return lhs_type;
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
  if (!n.f2.accept(this, argu).equals("boolean"))
   throw new my_exception("If expression not boolean");
  n.f4.accept(this, argu);
  n.f6.accept(this, argu);
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
    if (!n.f2.accept(this, argu).equals("boolean"))
      throw new my_exception("While expression not boolean");
    n.f4.accept(this, argu);
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
  String type=n.f2.accept(this, argu);
  type = type.replace("*", "");

  if (!type.equals("int"))
    throw new my_exception("print expression error");

  n.f4.accept(this, argu);
  return null;
  }

  /**
  * f0 -> AndExpression()
  *       | CompareExpression()
  *       | PlusExpression()
  *       | MinusExpression()
  *       | TimesExpression()
  *       | ArrayLofoundup()
  *       | ArrayLength()
  *       | MessageSend()
  *       | Clause()
  */
  public String visit(Expression n, String argu) throws Exception {
    return String.valueOf(n.f0.accept(this, argu));
  }

  /**
  * f0 -> Clause()
  * f1 -> "&&"
  * f2 -> Clause()
  */
  public String visit(AndExpression n, String argu) throws Exception {
   if (!n.f0.accept(this, argu).equals("boolean") || !n.f2.accept(this, argu).equals("boolean"))
     throw new my_exception("&& opperator used on non boolean");
   return "boolean";
  }

  /**
  * f0 -> PrimaryExpression()
  * f1 -> "<"
  * f2 -> PrimaryExpression()
  */
  public String visit(CompareExpression n, String argu) throws Exception {
  if (!n.f0.accept(this, argu).equals("int") || !n.f2.accept(this, argu).equals("int"))
    throw new my_exception("< opperator used on non boolean");
  return "boolean";
  }

  /**
  * f0 -> PrimaryExpression()
  * f1 -> "+"
  * f2 -> PrimaryExpression()
  */
  public String visit(PlusExpression n, String argu) throws Exception {
  if (!n.f0.accept(this, argu).equals("int") || !n.f2.accept(this, argu).equals("int"))
    throw new my_exception("+ opperator used on non int");
  return "int";
  }

  /**
  * f0 -> PrimaryExpression()
  * f1 -> "-"
  * f2 -> PrimaryExpression()
  */
  public String visit(MinusExpression n, String argu) throws Exception {
  if (!n.f0.accept(this, argu).equals("int") || !n.f2.accept(this, argu).equals("int"))
    throw new my_exception("+ opperator used on non int");
  return "int";
  }

  /**
  * f0 -> PrimaryExpression()
  * f1 -> "*"
  * f2 -> PrimaryExpression()
  */
  public String visit(TimesExpression n, String argu) throws Exception {
   if (!n.f0.accept(this, argu).equals("int") || !n.f2.accept(this, argu).equals("int"))
   throw new my_exception("* opperator used on non int");
   return "int";
  }

  /**
  * f0 -> PrimaryExpression()
  * f1 -> "["
  * f2 -> PrimaryExpression()
  * f3 -> "]"
  */
  public String visit(ArrayLookup n, String argu) throws Exception {
   String type = n.f0.accept(this, argu);
   if (!type.equals("int[]"))
     throw new my_exception(type+": not itterable");

   String index_type = n.f2.accept(this, argu);
   if(!index_type.equals("int"))
     throw new my_exception(index_type+": not int");
    return String.valueOf(type.replace("[]",""));
  }

  /**
  * f0 -> PrimaryExpression()
  * f1 -> "."
  * f2 -> "length"
  */
  public String visit(ArrayLength n, String argu) throws Exception {
  String type=n.f0.accept(this, argu);
  if (!type.equals("int[]"))
    throw new my_exception("length expression error");
  return "int";
  }

  /**
  * f0 -> PrimaryExpression()
  * f1 -> "."
  * f2 -> identifier()
  * f3 -> "("
  * f4 -> ( ExpressionList() )?
  * f5 -> ")"
  */
  public String visit(MessageSend n, String argu) throws Exception {
  String class_type = n.f0.accept(this, argu);

  if (class_type.equals("int") || class_type.equals("int[]") || class_type.equals("boolean"))
   throw new my_exception(class_type+": not class type");

  class_type = class_type.replace("*", "");
  String func_name = n.f2.accept(this, argu), tmp=n.f4.accept(this, argu);
  String[] expression_list;
  if (tmp!=null)
    expression_list = tmp.split("-");
  else
    expression_list=new String[0];

  String curr_class_name = class_type;
  do{// find function declaration
    if(visitor1.classes.get(curr_class_name).funcs.containsKey(func_name)) {// functions exists
      if(visitor1.classes.get(curr_class_name).funcs.get(func_name).args.size() == expression_list.length){// args are the same #
        String [] real_arg_types = visitor1.classes.get(curr_class_name).funcs.get(func_name).args.values().toArray(new String[0]);
        boolean ok = true;

        for(int i=0;i<expression_list.length;i++){
          if(expression_list[i].equals("int") || expression_list[i].equals("int[]")
              || expression_list[i].equals("boolean")){
            if(!expression_list[i].equals(real_arg_types[i])){// arg[i] is the same default type
              ok = false;
              break;
            }
            else
              continue;
          }
          else{
            String curr_class_type=expression_list[i];
            if(curr_class_type.equals(real_arg_types[i]))// arg[i] is the same class type
              continue;

            boolean found_father=false;
            while (!visitor1.classes.get(curr_class_type).inheritance.equals("")){// arg[i] is father type
              curr_class_type = visitor1.classes.get(curr_class_type).inheritance;
              if(curr_class_type.equals(real_arg_types[i])){
                found_father = true;
                break;
              }
            }
            if(found_father)
              continue;
          }
          ok = false;
          break;
        }

        if(ok){
          String func_return_type = visitor1.classes.get(curr_class_name).funcs.get(func_name).return_type;
          if (!func_return_type.equals("int") && !func_return_type.equals("boolean")
                && !func_return_type.equals("int[]"))
            return "*" + func_return_type;
          else
            return func_return_type;
        }
        else
          throw new my_exception(func_name+": call with wrong type of arguments");
      }
      else
        throw new my_exception(func_name+": call with wrong number of arguments "+func_name+" "+expression_list[0]+" "
        +visitor1.classes.get(curr_class_name).funcs.get(func_name).args.size()+"   "+ expression_list.length);
    }
    curr_class_name = visitor1.classes.get(curr_class_name).inheritance;//curr class=parent class
  }while (!curr_class_name.equals(""));

  //function decl not found
  throw new my_exception(func_name+": function not declared");
  }

  /**
  * f0 -> Expression()
  * f1 -> ExpressionRest()
  */
  public String visit(ExpressionList n, String argu) throws Exception {
    String arg1=n.f0.accept(this, argu), arg_list="";
    if(arg1!=null){
      arg_list += arg1.replace("*", "");
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
      return argn.replace("*", "");
    else
      return null;
  }

  /**
  * f0 -> IntegerLiteral()
  *       | TrueLiteral()
  *       | FalseLiteral()
  *       | identifier()
  *       | ThisExpression()
  *       | ArrayAllocationExpression()
  *       | AllocationExpression()
  *       | BracketExpression()
  */
  public String visit(PrimaryExpression n, String argu) throws Exception {
  String type = n.f0.accept(this, argu);

  if (type.equals("int") || type.equals("boolean") || type.equals("this") || type.equals("int[]"))
    return type;

  if (type.contains("*"))// AllocationExpression new
    return type;

  String var_name=type;
  String [] parts = argu.split("#");
  String class_name = parts[0];
  String func_name = parts[1];

  if(visitor1.classes.get(class_name).funcs.get(func_name).args.containsKey(var_name))
    return String.valueOf(visitor1.classes.get(class_name).funcs.get(func_name).args.get(var_name));
  if(visitor1.classes.get(class_name).funcs.get(func_name).vars.containsKey(var_name))
    return String.valueOf(visitor1.classes.get(class_name).funcs.get(func_name).vars.get(var_name));
  if(visitor1.classes.get(class_name).vars.containsKey(var_name))
    return String.valueOf(visitor1.classes.get(class_name).vars.get(var_name));

  String parent_class=class_name;
  while(!visitor1.classes.get(parent_class).inheritance.equals("")){
    parent_class=visitor1.classes.get(parent_class).inheritance;
    if(visitor1.classes.get(parent_class).vars.containsKey(var_name))
      return String.valueOf(visitor1.classes.get(parent_class).vars.get(var_name));
  }

  //variable decl not found
  throw new my_exception(class_name+"."+func_name+"."+var_name+": not declared");
  }

  /**
  * f0 -> <INTEGER_LITERAL>
  */
  public String visit(IntegerLiteral n, String argu) throws Exception {
   if(Long.parseLong(String.valueOf(n.f0), 10)<-2147483648 || Long.parseLong(String.valueOf(n.f0), 10)>214483647)
     throw new my_exception("Int literal is too big for int variable");
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

  /**
  * f0 -> <IDENTIFIER>
  */
  public String visit(Identifier n, String argu) throws Exception {
   return String.valueOf(n.f0);
  }

  /**
  * f0 -> "this"
  */
  public String visit(ThisExpression n, String argu) throws Exception {
   String [] parts = argu.split("#");
   return "*" + parts[0];
  }

  /**
  * f0 -> "new"
  * f1 -> "int"
  * f2 -> "["
  * f3 -> Expression()
  * f4 -> "]"
  */
  public String visit(ArrayAllocationExpression n, String argu) throws Exception {
   if (!n.f3.accept(this, argu).equals("int"))
  		throw new my_exception("New int array size not int");
  	return "int[]";
  }

  /**
  * f0 -> "new"
  * f1 -> identifier()
  * f2 -> "("
  * f3 -> ")"
  */
  public String visit(AllocationExpression n, String argu) throws Exception {
   String class_name = n.f1.accept(this, argu);
   if (!visitor1.classes.containsKey(class_name))
     throw new my_exception(class_name+": not defined");
   return "*" + class_name;
  }

  //! ine sosto afto ?! iparxi !new malakia[10] ?!
  /**
  * f0 -> "!"
  * f1 -> Clause()
  */
  public String visit(NotExpression n, String argu) throws Exception {
   n.f1.accept(this, argu);
   return "boolean";
  }

  /**
  * f0 -> "("
  * f1 -> Expression()
  * f2 -> ")"
  */
  public String visit(BracketExpression n, String argu) throws Exception{
   return n.f1.accept(this, argu);
  }

}
