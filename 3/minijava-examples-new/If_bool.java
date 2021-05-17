class If_bool {
	public static void main(String[] a) {
	    boolean x;
		boolean y;

        x = true;
y = false;
	
	if(x){
	    System.out.println(0);}
	else if(y){
		System.out.println(10);}
	else{System.out.println(1);}

	if(x && y){
	    System.out.println(11);}
	else{System.out.println(22);}

	if(y && x){
	    System.out.println(1);}
	else{System.out.println(2);}

	if(x && !y){
	    System.out.println(15);}
	else{System.out.println(25);}

	if(!y && !y){
	    System.out.println(115);}
	else{System.out.println(215);}

	if(x && x){
	    System.out.println(0);}
	else{System.out.println(5);}


	}
}
