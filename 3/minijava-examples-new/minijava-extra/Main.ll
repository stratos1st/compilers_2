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

@.ArrayTest_vtable = global [1 x i8*] [ 
	i8* bitcast (i32 (i8*,i32)* @ArrayTest.test to i8*)
]

@.B_vtable = global [1 x i8*] [ 
	i8* bitcast (i32 (i8*,i32)* @B.test to i8*)
]

define i32 @main() {
%ab = alloca i8*
store i8* null, i8** %ab
%_0 = call i8* @calloc(i32 1, i32 20)
%_1 = bitcast i8* %_0 to i8***
%_2 = getelementptr [1 x i8*], [1 x i8*]* @.ArrayTest_vtable, i32 0, i32 0
store i8** %_2, i8*** %_1
store i8* %_0, i8** %ab
%_3 = load i8*, i8** %ab
%_4 = bitcast i8* %_3 to i8***
%_5 = load i8**, i8*** %_4
%_6 = getelementptr i8*, i8** %_5, i32 0
%_7 = load i8*, i8** %_6
%_8 = bitcast i8* %_7 to i32 (i8*,i32)*
%_9 = call i32 %_8(i8* %_3, i32 3)
call void (i32) @print_int(i32 %_9)
ret i32 0
}

define i32 @ArrayTest.test(i8* %this, i32 %.num){
%num = alloca i32
store i32 %.num, i32* %num
%i = alloca i32
store i32 0, i32* %i
%intArray = alloca i32*
store i32* null, i32** %intArray
%_10 = load i32, i32* %num
%_11 = add i32 1, %_10
%_12 = icmp sge i32 %_11, 1
br i1 %_12, label %tag_1, label %tag_0
tag_0:
call void @throw_nsz()
br label %tag_1
tag_1:
%_13 = call i8* @calloc(i32 %_11, i32 4)
%_14 = bitcast i8* %_13 to i32*
store i32 %_10, i32* %_14
store i32* %_14, i32** %intArray
%_15 = getelementptr i8, i8* %this, i32 16
%_16 = bitcast i8* %_15 to i32*
store i32 0, i32* %_16
%_17 = getelementptr i8, i8* %this, i32 16
%_18 = bitcast i8* %_17 to i32*
%_19 = load i32, i32* %_18
call void (i32) @print_int(i32 %_19)
%_21 = load i32*, i32** %intArray
%_20 = load i32, i32* %_21
call void (i32) @print_int(i32 %_20)
store i32 0, i32* %i
call void (i32) @print_int(i32 111)
;WhileStatement
br label %tag_2
tag_2:
%_22 = load i32, i32* %i
%_24 = load i32*, i32** %intArray
%_23 = load i32, i32* %_24
%_25 = icmp slt i32 %_22, %_23
br i1 %_25, label %tag_3, label %tag_4
tag_3:
%_27 = load i32, i32* %i
%_26 = add i32 %_27, 1
call void (i32) @print_int(i32 %_26)
%_28 = load i32, i32* %i
%_30 = load i32, i32* %i
%_29 = add i32 %_30, 1
%_31 = load i32*, i32** %intArray
%_32 = load i32, i32* %_31
%_33 = icmp sge i32 %_28, 0
%_34 = icmp slt i32 %_28, %_32
%_35 = and i1 %_33, %_34
br i1 %_35, label %tag_6, label %tag_5
tag_5:
call void @throw_oob()
br label %tag_6
tag_6:
%_36 = add i32 1, %_28
%_37 = getelementptr i32, i32* %_31, i32 %_36
store i32 %_29, i32* %_37
%_39 = load i32, i32* %i
%_38 = add i32 %_39, 1
store i32 %_38, i32* %i
br label %tag_2
tag_4:
call void (i32) @print_int(i32 222)
store i32 0, i32* %i
;WhileStatement
br label %tag_7
tag_7:
%_40 = load i32, i32* %i
%_42 = load i32*, i32** %intArray
%_41 = load i32, i32* %_42
%_43 = icmp slt i32 %_40, %_41
br i1 %_43, label %tag_8, label %tag_9
tag_8:
%_44 = load i32, i32* %i
%_45 = load i32*, i32** %intArray
%_46 = load i32, i32* %_45
%_47 = icmp sge i32 %_44, 0
%_48 = icmp slt i32 %_44, %_46
%_49 = and i1 %_47, %_48
br i1 %_49, label %tag_11, label %tag_10
tag_10:
call void @throw_oob()
br label %tag_11
tag_11:
%_50 = add i32 1, %_44
%_51 = getelementptr i32, i32* %_45, i32 %_50
%_52 = load i32, i32* %_51
call void (i32) @print_int(i32 %_52)
%_54 = load i32, i32* %i
%_53 = add i32 %_54, 1
store i32 %_53, i32* %i
br label %tag_7
tag_9:
call void (i32) @print_int(i32 333)
%_56 = load i32*, i32** %intArray
%_55 = load i32, i32* %_56
ret i32 %_55
}

define i32 @B.test(i8* %this, i32 %.num){
%num = alloca i32
store i32 %.num, i32* %num
%i = alloca i32
store i32 0, i32* %i
%intArray = alloca i32*
store i32* null, i32** %intArray
%_57 = load i32, i32* %num
%_58 = add i32 1, %_57
%_59 = icmp sge i32 %_58, 1
br i1 %_59, label %tag_13, label %tag_12
tag_12:
call void @throw_nsz()
br label %tag_13
tag_13:
%_60 = call i8* @calloc(i32 %_58, i32 4)
%_61 = bitcast i8* %_60 to i32*
store i32 %_57, i32* %_61
store i32* %_61, i32** %intArray
%_62 = getelementptr i8, i8* %this, i32 8
%_63 = bitcast i8* %_62 to i32*
store i32 12, i32* %_63
%_64 = getelementptr i8, i8* %this, i32 8
%_65 = bitcast i8* %_64 to i32*
%_66 = load i32, i32* %_65
call void (i32) @print_int(i32 %_66)
%_68 = load i32*, i32** %intArray
%_67 = load i32, i32* %_68
call void (i32) @print_int(i32 %_67)
store i32 0, i32* %i
call void (i32) @print_int(i32 111)
;WhileStatement
br label %tag_14
tag_14:
%_69 = load i32, i32* %i
%_71 = load i32*, i32** %intArray
%_70 = load i32, i32* %_71
%_72 = icmp slt i32 %_69, %_70
br i1 %_72, label %tag_15, label %tag_16
tag_15:
%_74 = load i32, i32* %i
%_73 = add i32 %_74, 1
call void (i32) @print_int(i32 %_73)
%_75 = load i32, i32* %i
%_77 = load i32, i32* %i
%_76 = add i32 %_77, 1
%_78 = load i32*, i32** %intArray
%_79 = load i32, i32* %_78
%_80 = icmp sge i32 %_75, 0
%_81 = icmp slt i32 %_75, %_79
%_82 = and i1 %_80, %_81
br i1 %_82, label %tag_18, label %tag_17
tag_17:
call void @throw_oob()
br label %tag_18
tag_18:
%_83 = add i32 1, %_75
%_84 = getelementptr i32, i32* %_78, i32 %_83
store i32 %_76, i32* %_84
%_86 = load i32, i32* %i
%_85 = add i32 %_86, 1
store i32 %_85, i32* %i
br label %tag_14
tag_16:
call void (i32) @print_int(i32 222)
store i32 0, i32* %i
;WhileStatement
br label %tag_19
tag_19:
%_87 = load i32, i32* %i
%_89 = load i32*, i32** %intArray
%_88 = load i32, i32* %_89
%_90 = icmp slt i32 %_87, %_88
br i1 %_90, label %tag_20, label %tag_21
tag_20:
%_91 = load i32, i32* %i
%_92 = load i32*, i32** %intArray
%_93 = load i32, i32* %_92
%_94 = icmp sge i32 %_91, 0
%_95 = icmp slt i32 %_91, %_93
%_96 = and i1 %_94, %_95
br i1 %_96, label %tag_23, label %tag_22
tag_22:
call void @throw_oob()
br label %tag_23
tag_23:
%_97 = add i32 1, %_91
%_98 = getelementptr i32, i32* %_92, i32 %_97
%_99 = load i32, i32* %_98
call void (i32) @print_int(i32 %_99)
%_101 = load i32, i32* %i
%_100 = add i32 %_101, 1
store i32 %_100, i32* %i
br label %tag_19
tag_21:
call void (i32) @print_int(i32 333)
%_103 = load i32*, i32** %intArray
%_102 = load i32, i32* %_103
ret i32 %_102
}


