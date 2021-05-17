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
%x = alloca i1
store i1 0, i1* %x
%y = alloca i1
store i1 0, i1* %y
store i1 1, i1* %x
store i1 0, i1* %y
%_0 = load i1, i1* %x
;IfStatement
br i1 %_0, label %tag_0, label %tag_1
tag_0:
call void (i32) @print_int(i32 0)
br label %tag_2
tag_1:
%_1 = load i1, i1* %y
;IfStatement
br i1 %_1, label %tag_3, label %tag_4
tag_3:
call void (i32) @print_int(i32 10)
br label %tag_5
tag_4:
call void (i32) @print_int(i32 1)
br label %tag_5
tag_5:
br label %tag_2
tag_2:
;AndExpression
%_2 = load i1, i1* %x
br i1 %_2, label %tag_7, label %tag_6
tag_6:
br label %tag_9
tag_7:
%_3 = load i1, i1* %y
br label %tag_8
tag_8:
br label %tag_9
tag_9:
%_4 = phi i1  [ 0, %tag_6 ], [ %_3, %tag_8 ]
;IfStatement
br i1 %_4, label %tag_10, label %tag_11
tag_10:
call void (i32) @print_int(i32 11)
br label %tag_12
tag_11:
call void (i32) @print_int(i32 22)
br label %tag_12
tag_12:
;AndExpression
%_5 = load i1, i1* %y
br i1 %_5, label %tag_14, label %tag_13
tag_13:
br label %tag_16
tag_14:
%_6 = load i1, i1* %x
br label %tag_15
tag_15:
br label %tag_16
tag_16:
%_7 = phi i1  [ 0, %tag_13 ], [ %_6, %tag_15 ]
;IfStatement
br i1 %_7, label %tag_17, label %tag_18
tag_17:
call void (i32) @print_int(i32 1)
br label %tag_19
tag_18:
call void (i32) @print_int(i32 2)
br label %tag_19
tag_19:
;AndExpression
%_8 = load i1, i1* %x
br i1 %_8, label %tag_21, label %tag_20
tag_20:
br label %tag_23
tag_21:
%_9 = load i1, i1* %y
%_10 = xor i1 1, %_9
br label %tag_22
tag_22:
br label %tag_23
tag_23:
%_11 = phi i1  [ 0, %tag_20 ], [ %_10, %tag_22 ]
;IfStatement
br i1 %_11, label %tag_24, label %tag_25
tag_24:
call void (i32) @print_int(i32 15)
br label %tag_26
tag_25:
call void (i32) @print_int(i32 25)
br label %tag_26
tag_26:
;AndExpression
%_12 = load i1, i1* %y
%_13 = xor i1 1, %_12
br i1 %_13, label %tag_28, label %tag_27
tag_27:
br label %tag_30
tag_28:
%_14 = load i1, i1* %y
%_15 = xor i1 1, %_14
br label %tag_29
tag_29:
br label %tag_30
tag_30:
%_16 = phi i1  [ 0, %tag_27 ], [ %_15, %tag_29 ]
;IfStatement
br i1 %_16, label %tag_31, label %tag_32
tag_31:
call void (i32) @print_int(i32 115)
br label %tag_33
tag_32:
call void (i32) @print_int(i32 215)
br label %tag_33
tag_33:
;AndExpression
%_17 = load i1, i1* %x
br i1 %_17, label %tag_35, label %tag_34
tag_34:
br label %tag_37
tag_35:
%_18 = load i1, i1* %x
br label %tag_36
tag_36:
br label %tag_37
tag_37:
%_19 = phi i1  [ 0, %tag_34 ], [ %_18, %tag_36 ]
;IfStatement
br i1 %_19, label %tag_38, label %tag_39
tag_38:
call void (i32) @print_int(i32 0)
br label %tag_40
tag_39:
call void (i32) @print_int(i32 5)
br label %tag_40
tag_40:
ret i32 0
}


