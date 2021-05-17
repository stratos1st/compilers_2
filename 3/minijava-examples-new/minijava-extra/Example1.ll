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

@.Test1_vtable = global [1 x i8*] [ 
	i8* bitcast (i32 (i8*,i32,i1)* @Test1.Start to i8*)
]

define i32 @main() {
%_0 = call i8* @calloc(i32 1, i32 12)
%_1 = bitcast i8* %_0 to i8***
%_2 = getelementptr [1 x i8*], [1 x i8*]* @.Test1_vtable, i32 0, i32 0
store i8** %_2, i8*** %_1
%_3 = bitcast i8* %_0 to i8***
%_4 = load i8**, i8*** %_3
%_5 = getelementptr i8*, i8** %_4, i32 0
%_6 = load i8*, i8** %_5
%_7 = bitcast i8* %_6 to i32 (i8*,i32,i1)*
%_8 = call i32 %_7(i8* %_0, i32 5, i1 1)
call void (i32) @print_int(i32 %_8)
ret i32 0
}

define i32 @Test1.Start(i8* %this, i32 %.b, i1 %.c){
%b = alloca i32
store i32 %.b, i32* %b
%c = alloca i1
store i1 %.c, i1* %c
%ntb = alloca i1
store i1 0, i1* %ntb
%nti = alloca i32*
store i32* null, i32** %nti
%ourint = alloca i32
store i32 0, i32* %ourint
%_9 = load i32, i32* %b
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
store i32* %_13, i32** %nti
%_14 = load i32*, i32** %nti
%_15 = load i32, i32* %_14
%_16 = icmp sge i32 0, 0
%_17 = icmp slt i32 0, %_15
%_18 = and i1 %_16, %_17
br i1 %_18, label %tag_3, label %tag_2
tag_2:
call void @throw_oob()
br label %tag_3
tag_3:
%_19 = add i32 1, 0
%_20 = getelementptr i32, i32* %_14, i32 %_19
%_21 = load i32, i32* %_20
store i32 %_21, i32* %ourint
%_22 = load i32, i32* %ourint
call void (i32) @print_int(i32 %_22)
%_23 = load i32*, i32** %nti
%_24 = load i32, i32* %_23
%_25 = icmp sge i32 0, 0
%_26 = icmp slt i32 0, %_24
%_27 = and i1 %_25, %_26
br i1 %_27, label %tag_5, label %tag_4
tag_4:
call void @throw_oob()
br label %tag_5
tag_5:
%_28 = add i32 1, 0
%_29 = getelementptr i32, i32* %_23, i32 %_28
%_30 = load i32, i32* %_29
ret i32 %_30
}


