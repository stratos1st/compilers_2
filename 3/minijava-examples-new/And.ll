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
%b = alloca i1
store i1 0, i1* %b
%c = alloca i1
store i1 0, i1* %c
%x = alloca i32
store i32 0, i32* %x
store i1 0, i1* %b
store i1 1, i1* %c
;AndExpression
%_0 = load i1, i1* %b
br i1 %_0, label %tag_1, label %tag_0
tag_0:
br label %tag_3
tag_1:
%_1 = load i1, i1* %c
br label %tag_2
tag_2:
br label %tag_3
tag_3:
%_2 = phi i1  [ 0, %tag_0 ], [ %_1, %tag_2 ]
;IfStatement
br i1 %_2, label %tag_4, label %tag_5
tag_4:
store i32 0, i32* %x
br label %tag_6
tag_5:
store i32 1, i32* %x
br label %tag_6
tag_6:
%_3 = load i32, i32* %x
call void (i32) @print_int(i32 %_3)
ret i32 0
}


