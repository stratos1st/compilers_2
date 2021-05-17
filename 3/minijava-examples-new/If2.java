class If2 {
	public static void main(String[] a) {
	    int x;
boolean y;
	y=true;
        x = 10;

        if (!(!((x-5) < 2) && !y))
	        System.out.println(0);
	    else
	        System.out.println(1);
	

	x=1;	

	if (false)
	        System.out.println(0);
	    else if((x<10) && y)
	        System.out.println(1);
	else
	        System.out.println(3);

	if (false)
	        System.out.println(0);
	    else if(!(x<10) && y)
	        System.out.println(1);
	else
	        System.out.println(3);
	}

}
