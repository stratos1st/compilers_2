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

define i32 @main() {
%j = alloca i32
store i32 0, i32* %j
store i32 0, i32* %j
;WhileStatement
br label %tag_0
tag_0:
%_0 = load i32, i32* %j
%_1 = icmp slt i32 %_0, 5
br i1 %_1, label %tag_1, label %tag_2
tag_1:
%_4 = load i32, i32* %j
%_3 = sub i32 %_4, 1
%_2 = mul i32 %_3, 2
call void (i32) @print_int(i32 %_2)
%_6 = load i32, i32* %j
%_5 = add i32 %_6, 1
store i32 %_5, i32* %j
br label %tag_0
tag_2:
ret i32 0
}


