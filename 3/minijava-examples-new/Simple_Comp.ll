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
%y = alloca i32
store i32 0, i32* %y
%z = alloca i32
store i32 0, i32* %z
%xi = alloca i1
store i1 0, i1* %xi
%yi = alloca i1
store i1 0, i1* %yi
%x = alloca i32*
store i32* null, i32** %x
%_0 = add i32 1, 2
%_1 = icmp sge i32 %_0, 1
br i1 %_1, label %tag_1, label %tag_0
tag_0:
call void @throw_nsz()
br label %tag_1
tag_1:
%_2 = call i8* @calloc(i32 %_0, i32 4)
%_3 = bitcast i8* %_2 to i32*
store i32 2, i32* %_3
store i32* %_3, i32** %x
store i32 10, i32* %y
%_4 = load i32*, i32** %x
%_5 = load i32, i32* %_4
%_6 = icmp sge i32 0, 0
%_7 = icmp slt i32 0, %_5
%_8 = and i1 %_6, %_7
br i1 %_8, label %tag_3, label %tag_2
tag_2:
call void @throw_oob()
br label %tag_3
tag_3:
%_9 = add i32 1, 0
%_10 = getelementptr i32, i32* %_4, i32 %_9
store i32 1, i32* %_10
%_11 = load i32*, i32** %x
%_12 = load i32, i32* %_11
%_13 = icmp sge i32 1, 0
%_14 = icmp slt i32 1, %_12
%_15 = and i1 %_13, %_14
br i1 %_15, label %tag_5, label %tag_4
tag_4:
call void @throw_oob()
br label %tag_5
tag_5:
%_16 = add i32 1, 1
%_17 = getelementptr i32, i32* %_11, i32 %_16
store i32 2, i32* %_17
%_18 = load i32*, i32** %x
%_19 = load i32, i32* %_18
%_20 = icmp sge i32 0, 0
%_21 = icmp slt i32 0, %_19
%_22 = and i1 %_20, %_21
br i1 %_22, label %tag_7, label %tag_6
tag_6:
call void @throw_oob()
br label %tag_7
tag_7:
%_23 = add i32 1, 0
%_24 = getelementptr i32, i32* %_18, i32 %_23
%_25 = load i32, i32* %_24
store i32 %_25, i32* %y
%_26 = load i32, i32* %y
call void (i32) @print_int(i32 %_26)
%_27 = load i32, i32* %y
%_28 = load i32*, i32** %x
%_29 = load i32, i32* %_28
%_30 = icmp sge i32 %_27, 0
%_31 = icmp slt i32 %_27, %_29
%_32 = and i1 %_30, %_31
br i1 %_32, label %tag_9, label %tag_8
tag_8:
call void @throw_oob()
br label %tag_9
tag_9:
%_33 = add i32 1, %_27
%_34 = getelementptr i32, i32* %_28, i32 %_33
%_35 = load i32, i32* %_34
store i32 %_35, i32* %y
%_36 = load i32, i32* %y
call void (i32) @print_int(i32 %_36)
%_38 = load i32*, i32** %x
%_37 = load i32, i32* %_38
store i32 %_37, i32* %z
%_39 = load i32, i32* %z
call void (i32) @print_int(i32 %_39)
store i1 1, i1* %xi
store i1 0, i1* %yi
%_40 = load i32, i32* %y
%_41 = icmp slt i32 %_40, 1
;IfStatement
br i1 %_41, label %tag_10, label %tag_11
tag_10:
call void (i32) @print_int(i32 0)
br label %tag_12
tag_11:
;AndExpression
%_42 = load i1, i1* %xi
br i1 %_42, label %tag_14, label %tag_13
tag_13:
br label %tag_16
tag_14:
%_43 = load i1, i1* %yi
br label %tag_15
tag_15:
br label %tag_16
tag_16:
%_44 = phi i1  [ 0, %tag_13 ], [ %_43, %tag_15 ]
;IfStatement
br i1 %_44, label %tag_17, label %tag_18
tag_17:
call void (i32) @print_int(i32 0)
br label %tag_19
tag_18:
%_46 = load i32, i32* %y
%_47 = load i32, i32* %z
%_45 = add i32 %_46, %_47
call void (i32) @print_int(i32 %_45)
br label %tag_19
tag_19:
br label %tag_12
tag_12:
ret i32 0
}


