import java.util.*;

public class class_info{
  //variable names, variable types
  public LinkedHashMap<String, String> vars = new LinkedHashMap<String, String>();
  //function name, function info
  public LinkedHashMap<String, class_func_info> funcs = new LinkedHashMap<String, class_func_info>();
  public String inheritance = "";
  public int var_offset = 8;
  public int func_offset = 0;
}
