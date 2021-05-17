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
	i8* bitcast (i32 (i8*)* @A.run to i8*)
]

define i32 @main() {
%_0 = call i8* @calloc(i32 1, i32 8)
%_1 = bitcast i8* %_0 to i8***
%_2 = getelementptr [1 x i8*], [1 x i8*]* @.A_vtable, i32 0, i32 0
store i8** %_2, i8*** %_1
%_3 = bitcast i8* %_0 to i8***
%_4 = load i8**, i8*** %_3
%_5 = getelementptr i8*, i8** %_4, i32 0
%_6 = load i8*, i8** %_5
%_7 = bitcast i8* %_6 to i32 (i8*)*
%_8 = call i32 %_7(i8* %_0)
call void (i32) @print_int(i32 %_8)
ret i32 0
}

define i32 @A.run(i8* %this){
%a = alloca i32*
store i32* null, i32** %a
%_9 = add i32 1, 20
%_10 = icmp sge i32 %_9, 1
br i1 %_10, label %tag_1, label %tag_0
tag_0:
call void @throw_nsz()
br label %tag_1
tag_1:
%_11 = call i8* @calloc(i32 %_9, i32 4)
%_12 = bitcast i8* %_11 to i32*
store i32 20, i32* %_12
store i32* %_12, i32** %a
%_13 = load i32*, i32** %a
%_14 = load i32, i32* %_13
%_15 = icmp sge i32 10, 0
%_16 = icmp slt i32 10, %_14
%_17 = and i1 %_15, %_16
br i1 %_17, label %tag_3, label %tag_2
tag_2:
call void @throw_oob()
br label %tag_3
tag_3:
%_18 = add i32 1, 10
%_19 = getelementptr i32, i32* %_13, i32 %_18
%_20 = load i32, i32* %_19
call void (i32) @print_int(i32 %_20)
%_21 = load i32*, i32** %a
%_22 = load i32, i32* %_21
%_23 = icmp sge i32 40, 0
%_24 = icmp slt i32 40, %_22
%_25 = and i1 %_23, %_24
br i1 %_25, label %tag_5, label %tag_4
tag_4:
call void @throw_oob()
br label %tag_5
tag_5:
%_26 = add i32 1, 40
%_27 = getelementptr i32, i32* %_21, i32 %_26
%_28 = load i32, i32* %_27
ret i32 %_28
}


