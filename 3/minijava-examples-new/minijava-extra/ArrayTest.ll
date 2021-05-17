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

@.Test_vtable = global [1 x i8*] [ 
	i8* bitcast (i1 (i8*,i32)* @Test.start to i8*)
]

define i32 @main() {
%n = alloca i1
store i1 0, i1* %n
%_0 = call i8* @calloc(i32 1, i32 8)
%_1 = bitcast i8* %_0 to i8***
%_2 = getelementptr [1 x i8*], [1 x i8*]* @.Test_vtable, i32 0, i32 0
store i8** %_2, i8*** %_1
%_3 = bitcast i8* %_0 to i8***
%_4 = load i8**, i8*** %_3
%_5 = getelementptr i8*, i8** %_4, i32 0
%_6 = load i8*, i8** %_5
%_7 = bitcast i8* %_6 to i1 (i8*,i32)*
%_8 = call i1 %_7(i8* %_0, i32 10)
store i1 %_8, i1* %n
ret i32 0
}

define i1 @Test.start(i8* %this, i32 %.sz){
%sz = alloca i32
store i32 %.sz, i32* %sz
%b = alloca i32*
store i32* null, i32** %b
%l = alloca i32
store i32 0, i32* %l
%i = alloca i32
store i32 0, i32* %i
%_9 = load i32, i32* %sz
%_10 = add i32 1, %_9
%_11 = icmp sge i32 %_10, 1
br i1 %_11, label %tag_1, label %tag_0
tag_0:
call void @throw_nsz()
br label %tag_1
tag_1:
%_12 = call i8* @calloc(i32 %_10, i32 4)
%_13 = bitcast i8* %_12 to i32*
store i32 %_9, i32* %_13
store i32* %_13, i32** %b
%_15 = load i32*, i32** %b
%_14 = load i32, i32* %_15
store i32 %_14, i32* %l
store i32 0, i32* %i
;WhileStatement
br label %tag_2
tag_2:
%_16 = load i32, i32* %i
%_17 = load i32, i32* %l
%_18 = icmp slt i32 %_16, %_17
br i1 %_18, label %tag_3, label %tag_4
tag_3:
%_19 = load i32, i32* %i
%_20 = load i32, i32* %i
%_21 = load i32*, i32** %b
%_22 = load i32, i32* %_21
%_23 = icmp sge i32 %_19, 0
%_24 = icmp slt i32 %_19, %_22
%_25 = and i1 %_23, %_24
br i1 %_25, label %tag_6, label %tag_5
tag_5:
call void @throw_oob()
br label %tag_6
tag_6:
%_26 = add i32 1, %_19
%_27 = getelementptr i32, i32* %_21, i32 %_26
store i32 %_20, i32* %_27
%_28 = load i32, i32* %i
%_29 = load i32*, i32** %b
%_30 = load i32, i32* %_29
%_31 = icmp sge i32 %_28, 0
%_32 = icmp slt i32 %_28, %_30
%_33 = and i1 %_31, %_32
br i1 %_33, label %tag_8, label %tag_7
tag_7:
call void @throw_oob()
br label %tag_8
tag_8:
%_34 = add i32 1, %_28
%_35 = getelementptr i32, i32* %_29, i32 %_34
%_36 = load i32, i32* %_35
call void (i32) @print_int(i32 %_36)
%_38 = load i32, i32* %i
%_37 = add i32 %_38, 1
store i32 %_37, i32* %i
br label %tag_2
tag_4:
ret i1 1
}


