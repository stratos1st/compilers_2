class Simple_Comp {
    public static void main(String[] a) {
        int y;
        int z;
        boolean xi;
        boolean yi;
        int[] x;
        x = new int[2];

        y = 10;

        x[0] = 1;
        x[1] = 2;

        y = x[0];
        System.out.println(y);
        y = x[y];
        System.out.println(y);
        z = x.length;
        System.out.println(z);

        xi = true;
        yi = false;

        if (y < 1)
            System.out.println(0);
        else
            if (xi && yi)
                System.out.println(0);
            else
                System.out.println(y + z);
    }
}