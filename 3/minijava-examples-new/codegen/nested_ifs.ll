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
%flag = alloca i1
store i1 0, i1* %flag
;IfStatement
br i1 1, label %tag_0, label %tag_1
tag_0:
;IfStatement
br i1 1, label %tag_3, label %tag_4
tag_3:
;IfStatement
br i1 1, label %tag_6, label %tag_7
tag_6:
;IfStatement
br i1 1, label %tag_9, label %tag_10
tag_9:
;IfStatement
br i1 1, label %tag_12, label %tag_13
tag_12:
call void (i32) @print_int(i32 1)
br label %tag_14
tag_13:
call void (i32) @print_int(i32 0)
br label %tag_14
tag_14:
call void (i32) @print_int(i32 2)
br label %tag_11
tag_10:
call void (i32) @print_int(i32 0)
br label %tag_11
tag_11:
call void (i32) @print_int(i32 3)
br label %tag_8
tag_7:
call void (i32) @print_int(i32 0)
br label %tag_8
tag_8:
call void (i32) @print_int(i32 4)
br label %tag_5
tag_4:
call void (i32) @print_int(i32 0)
br label %tag_5
tag_5:
call void (i32) @print_int(i32 5)
br label %tag_2
tag_1:
call void (i32) @print_int(i32 0)
br label %tag_2
tag_2:
;AndExpression
;AndExpression
;AndExpression
br i1 1, label %tag_16, label %tag_15
tag_15:
br label %tag_18
tag_16:
br label %tag_17
tag_17:
br label %tag_18
tag_18:
%_0 = phi i1  [ 0, %tag_15 ], [ 1, %tag_17 ]
br i1 %_0, label %tag_20, label %tag_19
tag_19:
br label %tag_22
tag_20:
;AndExpression
%_1 = xor i1 1, 0
br i1 %_1, label %tag_24, label %tag_23
tag_23:
br label %tag_26
tag_24:
%_2 = xor i1 1, 0
br label %tag_25
tag_25:
br label %tag_26
tag_26:
%_3 = phi i1  [ 0, %tag_23 ], [ %_2, %tag_25 ]
br label %tag_21
tag_21:
br label %tag_22
tag_22:
%_4 = phi i1  [ 0, %tag_19 ], [ %_3, %tag_21 ]
br i1 %_4, label %tag_28, label %tag_27
tag_27:
br label %tag_30
tag_28:
%_5 = icmp slt i32 100, 1000
br label %tag_29
tag_29:
br label %tag_30
tag_30:
%_6 = phi i1  [ 0, %tag_27 ], [ %_5, %tag_29 ]
store i1 %_6, i1* %flag
;AndExpression
;AndExpression
br i1 1, label %tag_32, label %tag_31
tag_31:
br label %tag_34
tag_32:
%_7 = load i1, i1* %flag
br label %tag_33
tag_33:
br label %tag_34
tag_34:
%_8 = phi i1  [ 0, %tag_31 ], [ %_7, %tag_33 ]
br i1 %_8, label %tag_36, label %tag_35
tag_35:
br label %tag_38
tag_36:
;AndExpression
%_9 = xor i1 1, 0
br i1 %_9, label %tag_40, label %tag_39
tag_39:
br label %tag_42
tag_40:
%_10 = xor i1 1, 0
br label %tag_41
tag_41:
br label %tag_42
tag_42:
%_11 = phi i1  [ 0, %tag_39 ], [ %_10, %tag_41 ]
br label %tag_37
tag_37:
br label %tag_38
tag_38:
%_12 = phi i1  [ 0, %tag_35 ], [ %_11, %tag_37 ]
;IfStatement
br i1 %_12, label %tag_43, label %tag_44
tag_43:
;AndExpression
;AndExpression
br i1 1, label %tag_47, label %tag_46
tag_46:
br label %tag_49
tag_47:
%_13 = load i1, i1* %flag
br label %tag_48
tag_48:
br label %tag_49
tag_49:
%_14 = phi i1  [ 0, %tag_46 ], [ %_13, %tag_48 ]
br i1 %_14, label %tag_51, label %tag_50
tag_50:
br label %tag_53
tag_51:
;AndExpression
%_15 = xor i1 1, 0
br i1 %_15, label %tag_55, label %tag_54
tag_54:
br label %tag_57
tag_55:
%_16 = xor i1 1, 0
br label %tag_56
tag_56:
br label %tag_57
tag_57:
%_17 = phi i1  [ 0, %tag_54 ], [ %_16, %tag_56 ]
br label %tag_52
tag_52:
br label %tag_53
tag_53:
%_18 = phi i1  [ 0, %tag_50 ], [ %_17, %tag_52 ]
;IfStatement
br i1 %_18, label %tag_58, label %tag_59
tag_58:
;AndExpression
;AndExpression
br i1 1, label %tag_62, label %tag_61
tag_61:
br label %tag_64
tag_62:
%_19 = load i1, i1* %flag
br label %tag_63
tag_63:
br label %tag_64
tag_64:
%_20 = phi i1  [ 0, %tag_61 ], [ %_19, %tag_63 ]
br i1 %_20, label %tag_66, label %tag_65
tag_65:
br label %tag_68
tag_66:
;AndExpression
%_21 = xor i1 1, 0
br i1 %_21, label %tag_70, label %tag_69
tag_69:
br label %tag_72
tag_70:
%_22 = xor i1 1, 0
br label %tag_71
tag_71:
br label %tag_72
tag_72:
%_23 = phi i1  [ 0, %tag_69 ], [ %_22, %tag_71 ]
br label %tag_67
tag_67:
br label %tag_68
tag_68:
%_24 = phi i1  [ 0, %tag_65 ], [ %_23, %tag_67 ]
;IfStatement
br i1 %_24, label %tag_73, label %tag_74
tag_73:
;AndExpression
;AndExpression
br i1 1, label %tag_77, label %tag_76
tag_76:
br label %tag_79
tag_77:
%_25 = load i1, i1* %flag
br label %tag_78
tag_78:
br label %tag_79
tag_79:
%_26 = phi i1  [ 0, %tag_76 ], [ %_25, %tag_78 ]
br i1 %_26, label %tag_81, label %tag_80
tag_80:
br label %tag_83
tag_81:
;AndExpression
%_27 = xor i1 1, 0
br i1 %_27, label %tag_85, label %tag_84
tag_84:
br label %tag_87
tag_85:
%_28 = xor i1 1, 0
br label %tag_86
tag_86:
br label %tag_87
tag_87:
%_29 = phi i1  [ 0, %tag_84 ], [ %_28, %tag_86 ]
br label %tag_82
tag_82:
br label %tag_83
tag_83:
%_30 = phi i1  [ 0, %tag_80 ], [ %_29, %tag_82 ]
;IfStatement
br i1 %_30, label %tag_88, label %tag_89
tag_88:
;AndExpression
;AndExpression
%_31 = load i1, i1* %flag
br i1 %_31, label %tag_92, label %tag_91
tag_91:
br label %tag_94
tag_92:
%_32 = load i1, i1* %flag
br label %tag_93
tag_93:
br label %tag_94
tag_94:
%_33 = phi i1  [ 0, %tag_91 ], [ %_32, %tag_93 ]
br i1 %_33, label %tag_96, label %tag_95
tag_95:
br label %tag_98
tag_96:
;AndExpression
%_34 = xor i1 1, 0
br i1 %_34, label %tag_100, label %tag_99
tag_99:
br label %tag_102
tag_100:
%_35 = xor i1 1, 0
br label %tag_101
tag_101:
br label %tag_102
tag_102:
%_36 = phi i1  [ 0, %tag_99 ], [ %_35, %tag_101 ]
br label %tag_97
tag_97:
br label %tag_98
tag_98:
%_37 = phi i1  [ 0, %tag_95 ], [ %_36, %tag_97 ]
;IfStatement
br i1 %_37, label %tag_103, label %tag_104
tag_103:
call void (i32) @print_int(i32 1)
br label %tag_105
tag_104:
call void (i32) @print_int(i32 0)
br label %tag_105
tag_105:
call void (i32) @print_int(i32 2)
br label %tag_90
tag_89:
call void (i32) @print_int(i32 0)
br label %tag_90
tag_90:
call void (i32) @print_int(i32 3)
br label %tag_75
tag_74:
call void (i32) @print_int(i32 0)
br label %tag_75
tag_75:
call void (i32) @print_int(i32 4)
br label %tag_60
tag_59:
call void (i32) @print_int(i32 0)
br label %tag_60
tag_60:
call void (i32) @print_int(i32 5)
br label %tag_45
tag_44:
call void (i32) @print_int(i32 0)
br label %tag_45
tag_45:
ret i32 0
}


