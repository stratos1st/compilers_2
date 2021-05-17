class Classes {
	public static void main(String[] a) {
		Base b;
		Derived d;
	}
}

class A extends C {
	int data;
	public int set(int x) {
		data = x;
		return data;
	}
	public int get() {
		return data;
	}
}

class B extends A {
	public int set(int x) {
		data = x * 2;
		return data;
	}
}

class C extends B {
}
