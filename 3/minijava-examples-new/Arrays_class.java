class Arrays_class {
	public static void main(String[] a) {
	    System.out.println(new aa().Start(5));
	}
}

class aa{
    int[] number ;
    int size ;

    public int Start(int sz){
			int aux01 ;
	size = sz-1 ;
	number = new int[sz] ;

	number[0] = 20 ;
	number[1] = number[0]  ;
	number[2] = 9  ;
	number[size-1] = 19 ;
	number[size] = number[(size-1)]  ;

System.out.println(number[0]);
System.out.println(number[1]);
System.out.println(number[2]);
System.out.println(number[3]);
System.out.println(number[4]);
aux01 = this.bbb();
	return 0 ;

}
public int bbb(){

number[0] = 201 ;
number[1] = number[0]  ;
number[size-1] = 191 ;
number[size] = number[(size-1)]  ;

System.out.println(number[0]);
System.out.println(number[1]);
System.out.println(number[3]);
System.out.println(number[4]);
return 0 ;

}


}
