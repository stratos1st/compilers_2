public class my_exception extends Exception{
	public my_exception(String errorMessage){
		super(errorMessage+'\n');
	}
}
