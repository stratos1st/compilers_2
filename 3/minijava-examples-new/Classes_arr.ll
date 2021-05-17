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

@.A_vtable = global [1 x i8*] [ 
	i8* bitcast (i32 (i8*,i32*)* @A.foo to i8*)
]

define i32 @main() {
%alfa = alloca i8*
store i8* null, i8** %alfa
%array = alloca i32*
store i32* null, i32** %array
%_0 = call i8* @calloc(i32 1, i32 8)
%_1 = bitcast i8* %_0 to i8***
%_2 = getelementptr [1 x i8*], [1 x i8*]* @.A_vtable, i32 0, i32 0
store i8** %_2, i8*** %_1
store i8* %_0, i8** %alfa
%_3 = add i32 1, 2
%_4 = icmp sge i32 %_3, 1
br i1 %_4, label %tag_1, label %tag_0
tag_0:
call void @throw_nsz()
br label %tag_1
tag_1:
%_5 = call i8* @calloc(i32 %_3, i32 4)
%_6 = bitcast i8* %_5 to i32*
store i32 2, i32* %_6
store i32* %_6, i32** %array
%_7 = load i32*, i32** %array
%_8 = load i32, i32* %_7
%_9 = icmp sge i32 0, 0
%_10 = icmp slt i32 0, %_8
%_11 = and i1 %_9, %_10
br i1 %_11, label %tag_3, label %tag_2
tag_2:
call void @throw_oob()
br label %tag_3
tag_3:
%_12 = add i32 1, 0
%_13 = getelementptr i32, i32* %_7, i32 %_12
store i32 2, i32* %_13
%_14 = load i32*, i32** %array
%_15 = load i32, i32* %_14
%_16 = icmp sge i32 1, 0
%_17 = icmp slt i32 1, %_15
%_18 = and i1 %_16, %_17
br i1 %_18, label %tag_5, label %tag_4
tag_4:
call void @throw_oob()
br label %tag_5
tag_5:
%_19 = add i32 1, 1
%_20 = getelementptr i32, i32* %_14, i32 %_19
store i32 1, i32* %_20
%_21 = load i8*, i8** %alfa
%_22 = bitcast i8* %_21 to i8***
%_23 = load i8**, i8*** %_22
%_24 = getelementptr i8*, i8** %_23, i32 0
%_25 = load i8*, i8** %_24
%_26 = bitcast i8* %_25 to i32 (i8*,i32*)*
%_27 = load i32*, i32** %array
%_28 = call i32 %_26(i8* %_21, i32* %_27)
call void (i32) @print_int(i32 %_28)
ret i32 0
}

define i32 @A.foo(i8* %this, i32* %.a){
%a = alloca i32*
store i32* %.a, i32** %a
%_29 = load i32*, i32** %a
%_30 = load i32, i32* %_29
%_31 = icmp sge i32 1, 0
%_32 = icmp slt i32 1, %_30
%_33 = and i1 %_31, %_32
br i1 %_33, label %tag_7, label %tag_6
tag_6:
call void @throw_oob()
br label %tag_7
tag_7:
%_34 = add i32 1, 1
%_35 = getelementptr i32, i32* %_29, i32 %_34
%_36 = load i32, i32* %_35
ret i32 %_36
}


