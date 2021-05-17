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

@.aa_vtable = global [1 x i8*] [ 
	i8* bitcast (i32 (i8*)* @aa.bb to i8*)
]

define i32 @main() {
%x = alloca i32*
store i32* null, i32** %x
%k = alloca i8*
store i8* null, i8** %k
%_0 = call i8* @calloc(i32 1, i32 8)
%_1 = bitcast i8* %_0 to i8***
%_2 = getelementptr [1 x i8*], [1 x i8*]* @.aa_vtable, i32 0, i32 0
store i8** %_2, i8*** %_1
store i8* %_0, i8** %k
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
store i32* %_6, i32** %x
%_8 = load i32*, i32** %x
%_7 = load i32, i32* %_8
call void (i32) @print_int(i32 %_7)
%_9 = load i8*, i8** %k
%_10 = bitcast i8* %_9 to i8***
%_11 = load i8**, i8*** %_10
%_12 = getelementptr i8*, i8** %_11, i32 0
%_13 = load i8*, i8** %_12
%_14 = bitcast i8* %_13 to i32 (i8*)*
%_15 = call i32 %_14(i8* %_9)
call void (i32) @print_int(i32 %_15)
ret i32 0
}

define i32 @aa.bb(i8* %this){
%x = alloca i32*
store i32* null, i32** %x
%_16 = add i32 1, 10
%_17 = icmp sge i32 %_16, 1
br i1 %_17, label %tag_3, label %tag_2
tag_2:
call void @throw_nsz()
br label %tag_3
tag_3:
%_18 = call i8* @calloc(i32 %_16, i32 4)
%_19 = bitcast i8* %_18 to i32*
store i32 10, i32* %_19
store i32* %_19, i32** %x
%_21 = load i32*, i32** %x
%_20 = load i32, i32* %_21
ret i32 %_20
}


