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
%x = alloca i32
store i32 0, i32* %x
%y = alloca i1
store i1 0, i1* %y
store i1 1, i1* %y
store i32 10, i32* %x
;AndExpression
%_1 = load i32, i32* %x
%_0 = sub i32 %_1, 5
%_2 = icmp slt i32 %_0, 2
%_3 = xor i1 1, %_2
br i1 %_3, label %tag_1, label %tag_0
tag_0:
br label %tag_3
tag_1:
%_4 = load i1, i1* %y
%_5 = xor i1 1, %_4
br label %tag_2
tag_2:
br label %tag_3
tag_3:
%_6 = phi i1  [ 0, %tag_0 ], [ %_5, %tag_2 ]
%_7 = xor i1 1, %_6
;IfStatement
br i1 %_7, label %tag_4, label %tag_5
tag_4:
call void (i32) @print_int(i32 0)
br label %tag_6
tag_5:
call void (i32) @print_int(i32 1)
br label %tag_6
tag_6:
store i32 1, i32* %x
;IfStatement
br i1 0, label %tag_7, label %tag_8
tag_7:
call void (i32) @print_int(i32 0)
br label %tag_9
tag_8:
;AndExpression
%_8 = load i32, i32* %x
%_9 = icmp slt i32 %_8, 10
br i1 %_9, label %tag_11, label %tag_10
tag_10:
br label %tag_13
tag_11:
%_10 = load i1, i1* %y
br label %tag_12
tag_12:
br label %tag_13
tag_13:
%_11 = phi i1  [ 0, %tag_10 ], [ %_10, %tag_12 ]
;IfStatement
br i1 %_11, label %tag_14, label %tag_15
tag_14:
call void (i32) @print_int(i32 1)
br label %tag_16
tag_15:
call void (i32) @print_int(i32 3)
br label %tag_16
tag_16:
br label %tag_9
tag_9:
;IfStatement
br i1 0, label %tag_17, label %tag_18
tag_17:
call void (i32) @print_int(i32 0)
br label %tag_19
tag_18:
;AndExpression
%_12 = load i32, i32* %x
%_13 = icmp slt i32 %_12, 10
%_14 = xor i1 1, %_13
br i1 %_14, label %tag_21, label %tag_20
tag_20:
br label %tag_23
tag_21:
%_15 = load i1, i1* %y
br label %tag_22
tag_22:
br label %tag_23
tag_23:
%_16 = phi i1  [ 0, %tag_20 ], [ %_15, %tag_22 ]
;IfStatement
br i1 %_16, label %tag_24, label %tag_25
tag_24:
call void (i32) @print_int(i32 1)
br label %tag_26
tag_25:
call void (i32) @print_int(i32 3)
br label %tag_26
tag_26:
br label %tag_19
tag_19:
ret i32 0
}


