declare i8* @calloc(i32, i32)
declare i32 @printf(i8*, ...)
declare void @exit(i32)

@_cint = constant [4 x i8] c"%d\0a\00"
@_cOOB = constant [15 x i8] c"Out of bounds\0a\00"
@_cNSZ = constant [15 x i8] c"Negative size\0a\00"

define void @throw_nsz() {
	%_str = bitcast [15 x i8]* @_cNSZ to i8*
	call i32 (i8*, ...) @printf(i8* %_str)
	call void @exit(i32 1)
	ret void
}

define void @print_int(i32 %i) {
	%_str = bitcast [4 x i8]* @_cint to i8*
	call i32 (i8*, ...) @printf(i8* %_str, i32 %i)
	ret void
}

define void @throw_oob() {
	%_str = bitcast [15 x i8]* @_cOOB to i8*
	call i32 (i8*, ...) @printf(i8* %_str)
	call void @exit(i32 1)
	ret void
}
;----------------------------------------------------------------------------

@.A_vtable = global [2 x i8*] [ 
	i8* bitcast (i32 (i8*)* @A.InitA to i8*),
	i8* bitcast (i32 (i8*)* @A.f1 to i8*)
]

@.B_vtable = global [4 x i8*] [ 
	i8* bitcast (i32 (i8*)* @A.InitA to i8*),
	i8* bitcast (i32 (i8*)* @A.f1 to i8*),
	i8* bitcast (i32 (i8*)* @B.InitB to i8*),
	i8* bitcast (i32 (i8*)* @B.f2 to i8*)
]

@.C_vtable = global [6 x i8*] [ 
	i8* bitcast (i32 (i8*)* @A.InitA to i8*),
	i8* bitcast (i32 (i8*)* @A.f1 to i8*),
	i8* bitcast (i32 (i8*)* @B.InitB to i8*),
	i8* bitcast (i32 (i8*)* @B.f2 to i8*),
	i8* bitcast (i32 (i8*)* @C.InitC to i8*),
	i8* bitcast (i32 (i8*)* @C.f3 to i8*)
]

@.D_vtable = global [8 x i8*] [ 
	i8* bitcast (i32 (i8*)* @A.InitA to i8*),
	i8* bitcast (i32 (i8*)* @A.f1 to i8*),
	i8* bitcast (i32 (i8*)* @B.InitB to i8*),
	i8* bitcast (i32 (i8*)* @B.f2 to i8*),
	i8* bitcast (i32 (i8*)* @C.InitC to i8*),
	i8* bitcast (i32 (i8*)* @C.f3 to i8*),
	i8* bitcast (i32 (i8*)* @D.InitD to i8*),
	i8* bitcast (i32 (i8*)* @D.f4 to i8*)
]

@.E_vtable = global [10 x i8*] [ 
	i8* bitcast (i32 (i8*)* @A.InitA to i8*),
	i8* bitcast (i32 (i8*)* @A.f1 to i8*),
	i8* bitcast (i32 (i8*)* @B.InitB to i8*),
	i8* bitcast (i32 (i8*)* @B.f2 to i8*),
	i8* bitcast (i32 (i8*)* @C.InitC to i8*),
	i8* bitcast (i32 (i8*)* @C.f3 to i8*),
	i8* bitcast (i32 (i8*)* @D.InitD to i8*),
	i8* bitcast (i32 (i8*)* @D.f4 to i8*),
	i8* bitcast (i32 (i8*)* @E.InitE to i8*),
	i8* bitcast (i32 (i8*)* @E.f5 to i8*)
]

@.F_vtable = global [1 x i8*] [ 
	i8* bitcast (i32 (i8*,i8*)* @F.InitF to i8*)
]

define i32 @main() {
%e = alloca i8*
store i8* null, i8** %e
%f = alloca i8*
store i8* null, i8** %f
%_0 = call i8* @calloc(i32 1, i32 28)
%_1 = bitcast i8* %_0 to i8***
%_2 = getelementptr [10 x i8*], [10 x i8*]* @.E_vtable, i32 0, i32 0
store i8** %_2, i8*** %_1
store i8* %_0, i8** %e
%_3 = call i8* @calloc(i32 1, i32 16)
%_4 = bitcast i8* %_3 to i8***
%_5 = getelementptr [1 x i8*], [1 x i8*]* @.F_vtable, i32 0, i32 0
store i8** %_5, i8*** %_4
store i8* %_3, i8** %f
%_6 = load i8*, i8** %e
%_7 = bitcast i8* %_6 to i8***
%_8 = load i8**, i8*** %_7
%_9 = getelementptr i8*, i8** %_8, i32 8
%_10 = load i8*, i8** %_9
%_11 = bitcast i8* %_10 to i32 (i8*)*
%_12 = call i32 %_11(i8* %_6)
call void (i32) @print_int(i32 %_12)
%_13 = load i8*, i8** %e
%_14 = bitcast i8* %_13 to i8***
%_15 = load i8**, i8*** %_14
%_16 = getelementptr i8*, i8** %_15, i32 9
%_17 = load i8*, i8** %_16
%_18 = bitcast i8* %_17 to i32 (i8*)*
%_19 = call i32 %_18(i8* %_13)
call void (i32) @print_int(i32 %_19)
%_20 = load i8*, i8** %f
%_21 = bitcast i8* %_20 to i8***
%_22 = load i8**, i8*** %_21
%_23 = getelementptr i8*, i8** %_22, i32 0
%_24 = load i8*, i8** %_23
%_25 = bitcast i8* %_24 to i32 (i8*,i8*)*
%_26 = load i8*, i8** %e
%_27 = call i32 %_25(i8* %_20, i8* %_26)
call void (i32) @print_int(i32 %_27)
ret i32 0
}

define i32 @A.InitA(i8* %this){
%_28 = getelementptr i8, i8* %this, i32 8
%_29 = bitcast i8* %_28 to i32*
store i32 1024, i32* %_29
%_30 = getelementptr i8, i8* %this, i32 8
%_31 = bitcast i8* %_30 to i32*
%_32 = load i32, i32* %_31
ret i32 %_32
}

define i32 @A.f1(i8* %this){
ret i32 1
}

define i32 @B.InitB(i8* %this){
%_33 = getelementptr i8, i8* %this, i32 8
%_34 = bitcast i8* %_33 to i32*
store i32 2048, i32* %_34
%_36 = getelementptr i8, i8* %this, i32 8
%_37 = bitcast i8* %_36 to i32*
%_38 = load i32, i32* %_37
%_39 = bitcast i8* %this to i8***
%_40 = load i8**, i8*** %_39
%_41 = getelementptr i8*, i8** %_40, i32 0
%_42 = load i8*, i8** %_41
%_43 = bitcast i8* %_42 to i32 (i8*)*
%_44 = call i32 %_43(i8* %this)
%_35 = add i32 %_38, %_44
ret i32 %_35
}

define i32 @B.f2(i8* %this){
%_46 = bitcast i8* %this to i8***
%_47 = load i8**, i8*** %_46
%_48 = getelementptr i8*, i8** %_47, i32 1
%_49 = load i8*, i8** %_48
%_50 = bitcast i8* %_49 to i32 (i8*)*
%_51 = call i32 %_50(i8* %this)
%_45 = add i32 2, %_51
ret i32 %_45
}

define i32 @C.InitC(i8* %this){
%_52 = getelementptr i8, i8* %this, i32 8
%_53 = bitcast i8* %_52 to i32*
store i32 4096, i32* %_53
%_55 = getelementptr i8, i8* %this, i32 8
%_56 = bitcast i8* %_55 to i32*
%_57 = load i32, i32* %_56
%_58 = bitcast i8* %this to i8***
%_59 = load i8**, i8*** %_58
%_60 = getelementptr i8*, i8** %_59, i32 2
%_61 = load i8*, i8** %_60
%_62 = bitcast i8* %_61 to i32 (i8*)*
%_63 = call i32 %_62(i8* %this)
%_54 = add i32 %_57, %_63
ret i32 %_54
}

define i32 @C.f3(i8* %this){
%_65 = bitcast i8* %this to i8***
%_66 = load i8**, i8*** %_65
%_67 = getelementptr i8*, i8** %_66, i32 3
%_68 = load i8*, i8** %_67
%_69 = bitcast i8* %_68 to i32 (i8*)*
%_70 = call i32 %_69(i8* %this)
%_64 = add i32 3, %_70
ret i32 %_64
}

define i32 @D.InitD(i8* %this){
%_71 = getelementptr i8, i8* %this, i32 8
%_72 = bitcast i8* %_71 to i32*
store i32 8192, i32* %_72
%_74 = getelementptr i8, i8* %this, i32 8
%_75 = bitcast i8* %_74 to i32*
%_76 = load i32, i32* %_75
%_77 = bitcast i8* %this to i8***
%_78 = load i8**, i8*** %_77
%_79 = getelementptr i8*, i8** %_78, i32 4
%_80 = load i8*, i8** %_79
%_81 = bitcast i8* %_80 to i32 (i8*)*
%_82 = call i32 %_81(i8* %this)
%_73 = add i32 %_76, %_82
ret i32 %_73
}

define i32 @D.f4(i8* %this){
%_84 = bitcast i8* %this to i8***
%_85 = load i8**, i8*** %_84
%_86 = getelementptr i8*, i8** %_85, i32 5
%_87 = load i8*, i8** %_86
%_88 = bitcast i8* %_87 to i32 (i8*)*
%_89 = call i32 %_88(i8* %this)
%_83 = add i32 4, %_89
ret i32 %_83
}

define i32 @E.InitE(i8* %this){
%_90 = getelementptr i8, i8* %this, i32 8
%_91 = bitcast i8* %_90 to i32*
store i32 16384, i32* %_91
%_93 = getelementptr i8, i8* %this, i32 8
%_94 = bitcast i8* %_93 to i32*
%_95 = load i32, i32* %_94
%_96 = bitcast i8* %this to i8***
%_97 = load i8**, i8*** %_96
%_98 = getelementptr i8*, i8** %_97, i32 6
%_99 = load i8*, i8** %_98
%_100 = bitcast i8* %_99 to i32 (i8*)*
%_101 = call i32 %_100(i8* %this)
%_92 = add i32 %_95, %_101
ret i32 %_92
}

define i32 @E.f5(i8* %this){
%_103 = bitcast i8* %this to i8***
%_104 = load i8**, i8*** %_103
%_105 = getelementptr i8*, i8** %_104, i32 7
%_106 = load i8*, i8** %_105
%_107 = bitcast i8* %_106 to i32 (i8*)*
%_108 = call i32 %_107(i8* %this)
%_102 = add i32 5, %_108
ret i32 %_102
}

define i32 @F.InitF(i8* %this, i8* %.e){
%e = alloca i8*
store i8* %.e, i8** %e
%_109 = getelementptr i8, i8* %this, i32 8
%_110 = bitcast i8* %_109 to i8**
%_111 = load i8*, i8** %e
store i8* %_111, i8** %_110
%_112 = load i8*, i8** %e
%_113 = bitcast i8* %_112 to i8***
%_114 = load i8**, i8*** %_113
%_115 = getelementptr i8*, i8** %_114, i32 9
%_116 = load i8*, i8** %_115
%_117 = bitcast i8* %_116 to i32 (i8*)*
%_118 = call i32 %_117(i8* %_112)
ret i32 %_118
}


