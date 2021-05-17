class Classes_arr {
	public static void main(String[] a) {
		A alfa;
		int[] array;
		alfa=new A();
array=new int[2];
array[0]=2;
array[1]=1;
		System.out.println(alfa.foo(array));
	}
}

class A{
      public int foo(int[] a) {return a[1];}
  }

