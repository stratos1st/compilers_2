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
%i = alloca i32
store i32 0, i32* %i
%j = alloca i32
store i32 0, i32* %j
%z = alloca i32
store i32 0, i32* %z
%x = alloca i32
store i32 0, i32* %x
%sum = alloca i32
store i32 0, i32* %sum
%flag = alloca i1
store i1 0, i1* %flag
store i32 0, i32* %sum
store i32 0, i32* %i
;WhileStatement
br label %tag_0
tag_0:
%_0 = load i32, i32* %i
%_1 = icmp slt i32 %_0, 6
br i1 %_1, label %tag_1, label %tag_2
tag_1:
store i32 0, i32* %j
;WhileStatement
br label %tag_3
tag_3:
%_2 = load i32, i32* %j
%_3 = icmp slt i32 %_2, 5
br i1 %_3, label %tag_4, label %tag_5
tag_4:
store i32 0, i32* %z
;WhileStatement
br label %tag_6
tag_6:
%_4 = load i32, i32* %z
%_5 = icmp slt i32 %_4, 4
br i1 %_5, label %tag_7, label %tag_8
tag_7:
store i32 0, i32* %x
;WhileStatement
br label %tag_9
tag_9:
%_6 = load i32, i32* %x
%_7 = icmp slt i32 %_6, 4
br i1 %_7, label %tag_10, label %tag_11
tag_10:
%_9 = load i32, i32* %sum
%_13 = load i32, i32* %i
%_14 = load i32, i32* %j
%_12 = add i32 %_13, %_14
%_15 = load i32, i32* %z
%_11 = add i32 %_12, %_15
%_16 = load i32, i32* %x
%_10 = add i32 %_11, %_16
%_8 = add i32 %_9, %_10
store i32 %_8, i32* %sum
%_18 = load i32, i32* %x
%_17 = add i32 %_18, 1
store i32 %_17, i32* %x
br label %tag_9
tag_11:
%_20 = load i32, i32* %z
%_19 = add i32 %_20, 1
store i32 %_19, i32* %z
br label %tag_6
tag_8:
%_22 = load i32, i32* %j
%_21 = add i32 %_22, 1
store i32 %_21, i32* %j
br label %tag_3
tag_5:
%_24 = load i32, i32* %i
%_23 = add i32 %_24, 1
store i32 %_23, i32* %i
br label %tag_0
tag_2:
%_25 = load i32, i32* %sum
call void (i32) @print_int(i32 %_25)
store i32 0, i32* %sum
store i32 0, i32* %i
store i1 1, i1* %flag
;WhileStatement
br label %tag_12
tag_12:
%_26 = load i32, i32* %i
%_27 = icmp slt i32 %_26, 6
br i1 %_27, label %tag_13, label %tag_14
tag_13:
store i32 0, i32* %j
%_28 = load i1, i1* %flag
;IfStatement
br i1 %_28, label %tag_15, label %tag_16
tag_15:
;WhileStatement
br label %tag_18
tag_18:
%_29 = load i32, i32* %j
%_30 = icmp slt i32 %_29, 5
br i1 %_30, label %tag_19, label %tag_20
tag_19:
store i32 0, i32* %z
;WhileStatement
br label %tag_21
tag_21:
%_31 = load i32, i32* %z
%_32 = icmp slt i32 %_31, 4
br i1 %_32, label %tag_22, label %tag_23
tag_22:
store i32 0, i32* %x
;WhileStatement
br label %tag_24
tag_24:
%_33 = load i32, i32* %x
%_34 = icmp slt i32 %_33, 4
br i1 %_34, label %tag_25, label %tag_26
tag_25:
%_36 = load i32, i32* %sum
%_40 = load i32, i32* %i
%_41 = load i32, i32* %j
%_39 = add i32 %_40, %_41
%_42 = load i32, i32* %z
%_38 = add i32 %_39, %_42
%_43 = load i32, i32* %x
%_37 = add i32 %_38, %_43
%_35 = add i32 %_36, %_37
store i32 %_35, i32* %sum
%_45 = load i32, i32* %x
%_44 = add i32 %_45, 1
store i32 %_44, i32* %x
br label %tag_24
tag_26:
%_47 = load i32, i32* %z
%_46 = add i32 %_47, 1
store i32 %_46, i32* %z
br label %tag_21
tag_23:
%_49 = load i32, i32* %j
%_48 = add i32 %_49, 1
store i32 %_48, i32* %j
br label %tag_18
tag_20:
store i1 0, i1* %flag
br label %tag_17
tag_16:
;WhileStatement
br label %tag_27
tag_27:
%_50 = load i32, i32* %j
%_51 = icmp slt i32 %_50, 4
br i1 %_51, label %tag_28, label %tag_29
tag_28:
store i32 0, i32* %z
;WhileStatement
br label %tag_30
tag_30:
%_52 = load i32, i32* %z
%_53 = icmp slt i32 %_52, 10
br i1 %_53, label %tag_31, label %tag_32
tag_31:
store i32 0, i32* %x
;WhileStatement
br label %tag_33
tag_33:
%_54 = load i32, i32* %x
%_55 = icmp slt i32 %_54, 4
br i1 %_55, label %tag_34, label %tag_35
tag_34:
%_57 = load i32, i32* %sum
%_61 = load i32, i32* %i
%_62 = load i32, i32* %j
%_60 = mul i32 %_61, %_62
%_63 = load i32, i32* %z
%_59 = add i32 %_60, %_63
%_64 = load i32, i32* %x
%_58 = add i32 %_59, %_64
%_56 = add i32 %_57, %_58
store i32 %_56, i32* %sum
%_66 = load i32, i32* %x
%_65 = add i32 %_66, 1
store i32 %_65, i32* %x
br label %tag_33
tag_35:
%_68 = load i32, i32* %z
%_67 = add i32 %_68, 1
store i32 %_67, i32* %z
br label %tag_30
tag_32:
%_70 = load i32, i32* %j
%_69 = add i32 %_70, 1
store i32 %_69, i32* %j
br label %tag_27
tag_29:
store i1 0, i1* %flag
br label %tag_17
tag_17:
%_72 = load i32, i32* %i
%_71 = add i32 %_72, 1
store i32 %_71, i32* %i
br label %tag_12
tag_14:
%_73 = load i32, i32* %sum
call void (i32) @print_int(i32 %_73)
ret i32 0
}


