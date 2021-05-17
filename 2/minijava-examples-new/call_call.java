class Classes {
	public static void main(String[] a) {
		Base b;
		Derived d;
  		b = new Base();
 		d = new Derived();
 		System.out.println(b.get(2,2,3));
		System.out.println(b.set(d.sett(3),d.sett(3)));
		System.out.println(b.set(0,d.sett(3)));
		
	}
}

class Base {
	int data;
	public int set(int x, int y) {
		data = x;
		return data;
	}
	public int get(int y,int z, int d) {
		int x;
		x = this.set(y,z);
		return data;
	}
}

class Derived extends Base {
	public int sett(int x) {
		data = x * 2;
		return data;
	}
}
