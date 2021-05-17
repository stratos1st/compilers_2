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
	i8* bitcast (i32 (i8*,i32)* @A.foo to i8*)
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
%_7 = bitcast i8* %_6 to i32 (i8*,i32)*
%_8 = call i32 %_7(i8* %_0, i32 1)
call void (i32) @print_int(i32 %_8)
%_9 = call i8* @calloc(i32 1, i32 8)
%_10 = bitcast i8* %_9 to i8***
%_11 = getelementptr [1 x i8*], [1 x i8*]* @.A_vtable, i32 0, i32 0
store i8** %_11, i8*** %_10
%_12 = bitcast i8* %_9 to i8***
%_13 = load i8**, i8*** %_12
%_14 = getelementptr i8*, i8** %_13, i32 0
%_15 = load i8*, i8** %_14
%_16 = bitcast i8* %_15 to i32 (i8*,i32)*
%_17 = call i32 %_16(i8* %_9, i32 2)
call void (i32) @print_int(i32 %_17)
ret i32 0
}

define i32 @A.foo(i8* %this, i32 %.a){
%a = alloca i32
store i32 %.a, i32* %a
%_18 = load i32, i32* %a
%_19 = icmp slt i32 %_18, 2
;IfStatement
br i1 %_19, label %tag_0, label %tag_1
tag_0:
store i32 3, i32* %a
br label %tag_2
tag_1:
store i32 4, i32* %a
br label %tag_2
tag_2:
%_20 = load i32, i32* %a
ret i32 %_20
}


