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

@.LS_vtable = global [4 x i8*] [ 
	i8* bitcast (i32 (i8*,i32)* @LS.Start to i8*),
	i8* bitcast (i32 (i8*)* @LS.Print to i8*),
	i8* bitcast (i32 (i8*,i32)* @LS.Search to i8*),
	i8* bitcast (i32 (i8*,i32)* @LS.Init to i8*)
]

define i32 @main() {
%_0 = call i8* @calloc(i32 1, i32 20)
%_1 = bitcast i8* %_0 to i8***
%_2 = getelementptr [4 x i8*], [4 x i8*]* @.LS_vtable, i32 0, i32 0
store i8** %_2, i8*** %_1
%_3 = bitcast i8* %_0 to i8***
%_4 = load i8**, i8*** %_3
%_5 = getelementptr i8*, i8** %_4, i32 0
%_6 = load i8*, i8** %_5
%_7 = bitcast i8* %_6 to i32 (i8*,i32)*
%_8 = call i32 %_7(i8* %_0, i32 10)
call void (i32) @print_int(i32 %_8)
ret i32 0
}

define i32 @LS.Start(i8* %this, i32 %.sz){
%sz = alloca i32
store i32 %.sz, i32* %sz
%aux01 = alloca i32
store i32 0, i32* %aux01
%aux02 = alloca i32
store i32 0, i32* %aux02
%_9 = bitcast i8* %this to i8***
%_10 = load i8**, i8*** %_9
%_11 = getelementptr i8*, i8** %_10, i32 3
%_12 = load i8*, i8** %_11
%_13 = bitcast i8* %_12 to i32 (i8*,i32)*
%_14 = load i32, i32* %sz
%_15 = call i32 %_13(i8* %this, i32 %_14)
store i32 %_15, i32* %aux01
%_16 = bitcast i8* %this to i8***
%_17 = load i8**, i8*** %_16
%_18 = getelementptr i8*, i8** %_17, i32 1
%_19 = load i8*, i8** %_18
%_20 = bitcast i8* %_19 to i32 (i8*)*
%_21 = call i32 %_20(i8* %this)
store i32 %_21, i32* %aux02
call void (i32) @print_int(i32 9999)
%_22 = bitcast i8* %this to i8***
%_23 = load i8**, i8*** %_22
%_24 = getelementptr i8*, i8** %_23, i32 2
%_25 = load i8*, i8** %_24
%_26 = bitcast i8* %_25 to i32 (i8*,i32)*
%_27 = call i32 %_26(i8* %this, i32 8)
call void (i32) @print_int(i32 %_27)
%_28 = bitcast i8* %this to i8***
%_29 = load i8**, i8*** %_28
%_30 = getelementptr i8*, i8** %_29, i32 2
%_31 = load i8*, i8** %_30
%_32 = bitcast i8* %_31 to i32 (i8*,i32)*
%_33 = call i32 %_32(i8* %this, i32 12)
call void (i32) @print_int(i32 %_33)
%_34 = bitcast i8* %this to i8***
%_35 = load i8**, i8*** %_34
%_36 = getelementptr i8*, i8** %_35, i32 2
%_37 = load i8*, i8** %_36
%_38 = bitcast i8* %_37 to i32 (i8*,i32)*
%_39 = call i32 %_38(i8* %this, i32 17)
call void (i32) @print_int(i32 %_39)
%_40 = bitcast i8* %this to i8***
%_41 = load i8**, i8*** %_40
%_42 = getelementptr i8*, i8** %_41, i32 2
%_43 = load i8*, i8** %_42
%_44 = bitcast i8* %_43 to i32 (i8*,i32)*
%_45 = call i32 %_44(i8* %this, i32 50)
call void (i32) @print_int(i32 %_45)
ret i32 55
}

define i32 @LS.Print(i8* %this){
%j = alloca i32
store i32 0, i32* %j
store i32 1, i32* %j
;WhileStatement
br label %tag_0
tag_0:
%_46 = load i32, i32* %j
%_47 = getelementptr i8, i8* %this, i32 16
%_48 = bitcast i8* %_47 to i32*
%_49 = load i32, i32* %_48
%_50 = icmp slt i32 %_46, %_49
br i1 %_50, label %tag_1, label %tag_2
tag_1:
%_51 = load i32, i32* %j
%_52 = getelementptr i8, i8* %this, i32 8
%_53 = bitcast i8* %_52 to i32**
%_54 = load i32*, i32** %_53
%_55 = load i32, i32* %_54
%_56 = icmp sge i32 %_51, 0
%_57 = icmp slt i32 %_51, %_55
%_58 = and i1 %_56, %_57
br i1 %_58, label %tag_4, label %tag_3
tag_3:
call void @throw_oob()
br label %tag_4
tag_4:
%_59 = add i32 1, %_51
%_60 = getelementptr i32, i32* %_54, i32 %_59
%_61 = load i32, i32* %_60
call void (i32) @print_int(i32 %_61)
%_63 = load i32, i32* %j
%_62 = add i32 %_63, 1
store i32 %_62, i32* %j
br label %tag_0
tag_2:
ret i32 0
}

define i32 @LS.Search(i8* %this, i32 %.num){
%num = alloca i32
store i32 %.num, i32* %num
%j = alloca i32
store i32 0, i32* %j
%ls01 = alloca i1
store i1 0, i1* %ls01
%ifound = alloca i32
store i32 0, i32* %ifound
%aux01 = alloca i32
store i32 0, i32* %aux01
%aux02 = alloca i32
store i32 0, i32* %aux02
%nt = alloca i32
store i32 0, i32* %nt
store i32 1, i32* %j
store i1 0, i1* %ls01
store i32 0, i32* %ifound
;WhileStatement
br label %tag_5
tag_5:
%_64 = load i32, i32* %j
%_65 = getelementptr i8, i8* %this, i32 16
%_66 = bitcast i8* %_65 to i32*
%_67 = load i32, i32* %_66
%_68 = icmp slt i32 %_64, %_67
br i1 %_68, label %tag_6, label %tag_7
tag_6:
%_69 = load i32, i32* %j
%_70 = getelementptr i8, i8* %this, i32 8
%_71 = bitcast i8* %_70 to i32**
%_72 = load i32*, i32** %_71
%_73 = load i32, i32* %_72
%_74 = icmp sge i32 %_69, 0
%_75 = icmp slt i32 %_69, %_73
%_76 = and i1 %_74, %_75
br i1 %_76, label %tag_9, label %tag_8
tag_8:
call void @throw_oob()
br label %tag_9
tag_9:
%_77 = add i32 1, %_69
%_78 = getelementptr i32, i32* %_72, i32 %_77
%_79 = load i32, i32* %_78
store i32 %_79, i32* %aux01
%_81 = load i32, i32* %num
%_80 = add i32 %_81, 1
store i32 %_80, i32* %aux02
%_82 = load i32, i32* %aux01
%_83 = load i32, i32* %num
%_84 = icmp slt i32 %_82, %_83
;IfStatement
br i1 %_84, label %tag_10, label %tag_11
tag_10:
store i32 0, i32* %nt
br label %tag_12
tag_11:
%_85 = load i32, i32* %aux01
%_86 = load i32, i32* %aux02
%_87 = icmp slt i32 %_85, %_86
%_88 = xor i1 1, %_87
;IfStatement
br i1 %_88, label %tag_13, label %tag_14
tag_13:
store i32 0, i32* %nt
br label %tag_15
tag_14:
store i1 1, i1* %ls01
store i32 1, i32* %ifound
%_89 = getelementptr i8, i8* %this, i32 16
%_90 = bitcast i8* %_89 to i32*
%_91 = load i32, i32* %_90
store i32 %_91, i32* %j
br label %tag_15
tag_15:
br label %tag_12
tag_12:
%_93 = load i32, i32* %j
%_92 = add i32 %_93, 1
store i32 %_92, i32* %j
br label %tag_5
tag_7:
%_94 = load i32, i32* %ifound
ret i32 %_94
}

define i32 @LS.Init(i8* %this, i32 %.sz){
%sz = alloca i32
store i32 %.sz, i32* %sz
%j = alloca i32
store i32 0, i32* %j
%k = alloca i32
store i32 0, i32* %k
%aux01 = alloca i32
store i32 0, i32* %aux01
%aux02 = alloca i32
store i32 0, i32* %aux02
%_95 = getelementptr i8, i8* %this, i32 16
%_96 = bitcast i8* %_95 to i32*
%_97 = load i32, i32* %sz
store i32 %_97, i32* %_96
%_98 = getelementptr i8, i8* %this, i32 8
%_99 = bitcast i8* %_98 to i32**
%_100 = load i32, i32* %sz
%_101 = add i32 1, %_100
%_102 = icmp sge i32 %_101, 1
br i1 %_102, label %tag_17, label %tag_16
tag_16:
call void @throw_nsz()
br label %tag_17
tag_17:
%_103 = call i8* @calloc(i32 %_101, i32 4)
%_104 = bitcast i8* %_103 to i32*
store i32 %_100, i32* %_104
store i32* %_104, i32** %_99
store i32 1, i32* %j
%_106 = getelementptr i8, i8* %this, i32 16
%_107 = bitcast i8* %_106 to i32*
%_108 = load i32, i32* %_107
%_105 = add i32 %_108, 1
store i32 %_105, i32* %k
;WhileStatement
br label %tag_18
tag_18:
%_109 = load i32, i32* %j
%_110 = getelementptr i8, i8* %this, i32 16
%_111 = bitcast i8* %_110 to i32*
%_112 = load i32, i32* %_111
%_113 = icmp slt i32 %_109, %_112
br i1 %_113, label %tag_19, label %tag_20
tag_19:
%_115 = load i32, i32* %j
%_114 = mul i32 2, %_115
store i32 %_114, i32* %aux01
%_117 = load i32, i32* %k
%_116 = sub i32 %_117, 3
store i32 %_116, i32* %aux02
%_118 = load i32, i32* %j
%_120 = load i32, i32* %aux01
%_121 = load i32, i32* %aux02
%_119 = add i32 %_120, %_121
%_122 = getelementptr i8, i8* %this, i32 8
%_123 = bitcast i8* %_122 to i32**
%_124 = load i32*, i32** %_123
%_125 = load i32, i32* %_124
%_126 = icmp sge i32 %_118, 0
%_127 = icmp slt i32 %_118, %_125
%_128 = and i1 %_126, %_127
br i1 %_128, label %tag_22, label %tag_21
tag_21:
call void @throw_oob()
br label %tag_22
tag_22:
%_129 = add i32 1, %_118
%_130 = getelementptr i32, i32* %_124, i32 %_129
store i32 %_119, i32* %_130
%_132 = load i32, i32* %j
%_131 = add i32 %_132, 1
store i32 %_131, i32* %j
%_134 = load i32, i32* %k
%_133 = sub i32 %_134, 1
store i32 %_133, i32* %k
br label %tag_18
tag_20:
ret i32 0
}


