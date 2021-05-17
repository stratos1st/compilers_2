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

@.A_vtable = global [7 x i8*] [ 
	i8* bitcast (i1 (i8*)* @A.t to i8*),
	i8* bitcast (i32 (i8*)* @A.t2 to i8*),
	i8* bitcast (i32 (i8*,i32*)* @A.lispy to i8*),
	i8* bitcast (i1 (i8*)* @A.t3 to i8*),
	i8* bitcast (i1 (i8*,i32,i32*)* @A.t4 to i8*),
	i8* bitcast (i32 (i8*,i32*)* @A.t5 to i8*),
	i8* bitcast (i1 (i8*,i1,i32*)* @A.t6 to i8*)
]

@.C_vtable = global [1 x i8*] [ 
	i8* bitcast (i32* (i8*,i1)* @C.test to i8*)
]

@.B_vtable = global [2 x i8*] [ 
	i8* bitcast (i32* (i8*,i1)* @C.test to i8*),
	i8* bitcast (i32* (i8*,i32)* @B.test2 to i8*)
]

define i32 @main() {
ret i32 0
}

define i1 @A.t(i8* %this){
;AndExpression
%_0 = icmp slt i32 1, 2
%_1 = xor i1 1, %_0
br i1 %_1, label %tag_1, label %tag_0
tag_0:
br label %tag_3
tag_1:
;AndExpression
br i1 1, label %tag_5, label %tag_4
tag_4:
br label %tag_7
tag_5:
br label %tag_6
tag_6:
br label %tag_7
tag_7:
%_2 = phi i1  [ 0, %tag_4 ], [ 0, %tag_6 ]
br label %tag_2
tag_2:
br label %tag_3
tag_3:
%_3 = phi i1  [ 0, %tag_0 ], [ %_2, %tag_2 ]
ret i1 %_3
}

define i32 @A.t2(i8* %this){
%_6 = add i32 1, 2
%_5 = add i32 %_6, 3
%_4 = add i32 %_5, 4
ret i32 %_4
}

define i32 @A.lispy(i8* %this, i32* %.a){
%a = alloca i32*
store i32* %.a, i32** %a
%_8 = add i32 1, 2
%_9 = load i32*, i32** %a
%_10 = load i32, i32* %_9
%_11 = icmp sge i32 3, 0
%_12 = icmp slt i32 3, %_10
%_13 = and i1 %_11, %_12
br i1 %_13, label %tag_9, label %tag_8
tag_8:
call void @throw_oob()
br label %tag_9
tag_9:
%_14 = add i32 1, 3
%_15 = getelementptr i32, i32* %_9, i32 %_14
%_16 = load i32, i32* %_15
%_7 = add i32 %_8, %_16
ret i32 %_7
}

define i1 @A.t3(i8* %this){
%a = alloca i32
store i32 0, i32* %a
%b = alloca i32
store i32 0, i32* %b
store i32 2, i32* %a
store i32 2, i32* %b
%_17 = add i32 349, 908
%_20 = load i32, i32* %a
%_19 = mul i32 23, %_20
%_22 = load i32, i32* %b
%_21 = sub i32 %_22, 2
%_18 = sub i32 %_19, %_21
%_23 = icmp slt i32 %_17, %_18
ret i1 %_23
}

define i1 @A.t4(i8* %this, i32 %.a, i32* %.b){
%a = alloca i32
store i32 %.a, i32* %a
%b = alloca i32*
store i32* %.b, i32** %b
%arr = alloca i32*
store i32* null, i32** %arr
%_24 = add i32 1, 10
%_25 = icmp sge i32 %_24, 1
br i1 %_25, label %tag_11, label %tag_10
tag_10:
call void @throw_nsz()
br label %tag_11
tag_11:
%_26 = call i8* @calloc(i32 %_24, i32 4)
%_27 = bitcast i8* %_26 to i32*
store i32 10, i32* %_27
store i32* %_27, i32** %arr
;AndExpression
%_29 = bitcast i8* %this to i8***
%_30 = load i8**, i8*** %_29
%_31 = getelementptr i8*, i8** %_30, i32 1
%_32 = load i8*, i8** %_31
%_33 = bitcast i8* %_32 to i32 (i8*)*
%_34 = call i32 %_33(i8* %this)
%_28 = add i32 29347, %_34
%_35 = icmp slt i32 %_28, 12
br i1 %_35, label %tag_13, label %tag_12
tag_12:
br label %tag_15
tag_13:
;AndExpression
;AndExpression
%_36 = load i32, i32* %a
%_37 = load i32*, i32** %arr
%_38 = load i32, i32* %_37
%_39 = icmp sge i32 0, 0
%_40 = icmp slt i32 0, %_38
%_41 = and i1 %_39, %_40
br i1 %_41, label %tag_17, label %tag_16
tag_16:
call void @throw_oob()
br label %tag_17
tag_17:
%_42 = add i32 1, 0
%_43 = getelementptr i32, i32* %_37, i32 %_42
%_44 = load i32, i32* %_43
%_45 = icmp slt i32 %_36, %_44
br i1 %_45, label %tag_19, label %tag_18
tag_18:
br label %tag_21
tag_19:
%_46 = bitcast i8* %this to i8***
%_47 = load i8**, i8*** %_46
%_48 = getelementptr i8*, i8** %_47, i32 3
%_49 = load i8*, i8** %_48
%_50 = bitcast i8* %_49 to i1 (i8*)*
%_51 = call i1 %_50(i8* %this)
br label %tag_20
tag_20:
br label %tag_21
tag_21:
%_52 = phi i1  [ 0, %tag_18 ], [ %_51, %tag_20 ]
br i1 %_52, label %tag_23, label %tag_22
tag_22:
br label %tag_25
tag_23:
%_53 = bitcast i8* %this to i8***
%_54 = load i8**, i8*** %_53
%_55 = getelementptr i8*, i8** %_54, i32 4
%_56 = load i8*, i8** %_55
%_57 = bitcast i8* %_56 to i1 (i8*,i32,i32*)*
%_58 = bitcast i8* %this to i8***
%_59 = load i8**, i8*** %_58
%_60 = getelementptr i8*, i8** %_59, i32 1
%_61 = load i8*, i8** %_60
%_62 = bitcast i8* %_61 to i32 (i8*)*
%_63 = call i32 %_62(i8* %this)
%_64 = load i32*, i32** %arr
%_65 = call i1 %_57(i8* %this, i32 %_63, i32* %_64)
br label %tag_24
tag_24:
br label %tag_25
tag_25:
%_66 = phi i1  [ 0, %tag_22 ], [ %_65, %tag_24 ]
br label %tag_14
tag_14:
br label %tag_15
tag_15:
%_67 = phi i1  [ 0, %tag_12 ], [ %_66, %tag_14 ]
ret i1 %_67
}

define i32 @A.t5(i8* %this, i32* %.a){
%a = alloca i32*
store i32* %.a, i32** %a
%b = alloca i32
store i32 0, i32* %b
%_70 = bitcast i8* %this to i8***
%_71 = load i8**, i8*** %_70
%_72 = getelementptr i8*, i8** %_71, i32 1
%_73 = load i8*, i8** %_72
%_74 = bitcast i8* %_73 to i32 (i8*)*
%_75 = call i32 %_74(i8* %this)
%_76 = bitcast i8* %this to i8***
%_77 = load i8**, i8*** %_76
%_78 = getelementptr i8*, i8** %_77, i32 2
%_79 = load i8*, i8** %_78
%_80 = bitcast i8* %_79 to i32 (i8*,i32*)*
%_81 = load i32*, i32** %a
%_82 = load i32, i32* %_81
%_83 = icmp sge i32 0, 0
%_84 = icmp slt i32 0, %_82
%_85 = and i1 %_83, %_84
br i1 %_85, label %tag_27, label %tag_26
tag_26:
call void @throw_oob()
br label %tag_27
tag_27:
%_86 = add i32 1, 0
%_87 = getelementptr i32, i32* %_81, i32 %_86
%_88 = load i32, i32* %_87
%_89 = add i32 1, %_88
%_90 = icmp sge i32 %_89, 1
br i1 %_90, label %tag_29, label %tag_28
tag_28:
call void @throw_nsz()
br label %tag_29
tag_29:
%_91 = call i8* @calloc(i32 %_89, i32 4)
%_92 = bitcast i8* %_91 to i32*
store i32 %_88, i32* %_92
%_93 = call i32 %_80(i8* %this, i32* %_92)
%_69 = add i32 %_75, %_93
%_94 = add i32 1, %_69
%_95 = icmp sge i32 %_94, 1
br i1 %_95, label %tag_31, label %tag_30
tag_30:
call void @throw_nsz()
br label %tag_31
tag_31:
%_96 = call i8* @calloc(i32 %_94, i32 4)
%_97 = bitcast i8* %_96 to i32*
store i32 %_69, i32* %_97
%_98 = bitcast i8* %_97 to i32**
%_99 = load i32*, i32** %_98
%_100 = load i32, i32* %_99
%_101 = icmp sge i32 0, 0
%_102 = icmp slt i32 0, %_100
%_103 = and i1 %_101, %_102
br i1 %_103, label %tag_33, label %tag_32
tag_32:
call void @throw_oob()
br label %tag_33
tag_33:
%_104 = add i32 1, 0
%_105 = getelementptr i32, i32* %_99, i32 %_104
%_106 = load i32, i32* %_105
%_68 = add i32 %_106, 10
%_107 = add i32 1, %_68
%_108 = icmp sge i32 %_107, 1
br i1 %_108, label %tag_35, label %tag_34
tag_34:
call void @throw_nsz()
br label %tag_35
tag_35:
%_109 = call i8* @calloc(i32 %_107, i32 4)
%_110 = bitcast i8* %_109 to i32*
store i32 %_68, i32* %_110
%_111 = bitcast i8* %_110 to i32**
%_112 = load i32*, i32** %_111
%_113 = load i32, i32* %_112
%_114 = icmp sge i32 2, 0
%_115 = icmp slt i32 2, %_113
%_116 = and i1 %_114, %_115
br i1 %_116, label %tag_37, label %tag_36
tag_36:
call void @throw_oob()
br label %tag_37
tag_37:
%_117 = add i32 1, 2
%_118 = getelementptr i32, i32* %_112, i32 %_117
%_119 = load i32, i32* %_118
store i32 %_119, i32* %b
%_120 = load i32, i32* %b
%_121 = load i32*, i32** %a
%_122 = load i32, i32* %_121
%_123 = icmp sge i32 %_120, 0
%_124 = icmp slt i32 %_120, %_122
%_125 = and i1 %_123, %_124
br i1 %_125, label %tag_39, label %tag_38
tag_38:
call void @throw_oob()
br label %tag_39
tag_39:
%_126 = add i32 1, %_120
%_127 = getelementptr i32, i32* %_121, i32 %_126
%_128 = load i32, i32* %_127
ret i32 %_128
}

define i1 @A.t6(i8* %this, i1 %.dummy, i32* %.arr){
%dummy = alloca i1
store i1 %.dummy, i1* %dummy
%arr = alloca i32*
store i32* %.arr, i32** %arr
%a = alloca i32
store i32 0, i32* %a
%c = alloca i8*
store i8* null, i8** %c
store i32 2, i32* %a
%_129 = call i8* @calloc(i32 1, i32 8)
%_130 = bitcast i8* %_129 to i8***
%_131 = getelementptr [1 x i8*], [1 x i8*]* @.C_vtable, i32 0, i32 0
store i8** %_131, i8*** %_130
store i8* %_129, i8** %c
;AndExpression
%_133 = bitcast i8* %this to i8***
%_134 = load i8**, i8*** %_133
%_135 = getelementptr i8*, i8** %_134, i32 1
%_136 = load i8*, i8** %_135
%_137 = bitcast i8* %_136 to i32 (i8*)*
%_138 = call i32 %_137(i8* %this)
%_132 = add i32 29347, %_138
%_139 = icmp slt i32 %_132, 12
br i1 %_139, label %tag_41, label %tag_40
tag_40:
br label %tag_43
tag_41:
;AndExpression
;AndExpression
%_140 = load i32, i32* %a
%_141 = load i32*, i32** %arr
%_142 = load i32, i32* %_141
%_143 = icmp sge i32 0, 0
%_144 = icmp slt i32 0, %_142
%_145 = and i1 %_143, %_144
br i1 %_145, label %tag_45, label %tag_44
tag_44:
call void @throw_oob()
br label %tag_45
tag_45:
%_146 = add i32 1, 0
%_147 = getelementptr i32, i32* %_141, i32 %_146
%_148 = load i32, i32* %_147
%_149 = icmp slt i32 %_140, %_148
br i1 %_149, label %tag_47, label %tag_46
tag_46:
br label %tag_49
tag_47:
%_150 = bitcast i8* %this to i8***
%_151 = load i8**, i8*** %_150
%_152 = getelementptr i8*, i8** %_151, i32 3
%_153 = load i8*, i8** %_152
%_154 = bitcast i8* %_153 to i1 (i8*)*
%_155 = call i1 %_154(i8* %this)
br label %tag_48
tag_48:
br label %tag_49
tag_49:
%_156 = phi i1  [ 0, %tag_46 ], [ %_155, %tag_48 ]
br i1 %_156, label %tag_51, label %tag_50
tag_50:
br label %tag_53
tag_51:
%_157 = bitcast i8* %this to i8***
%_158 = load i8**, i8*** %_157
%_159 = getelementptr i8*, i8** %_158, i32 6
%_160 = load i8*, i8** %_159
%_161 = bitcast i8* %_160 to i1 (i8*,i1,i32*)*
%_162 = bitcast i8* %this to i8***
%_163 = load i8**, i8*** %_162
%_164 = getelementptr i8*, i8** %_163, i32 4
%_165 = load i8*, i8** %_164
%_166 = bitcast i8* %_165 to i1 (i8*,i32,i32*)*
%_167 = call i8* @calloc(i32 1, i32 8)
%_168 = bitcast i8* %_167 to i8***
%_169 = getelementptr [2 x i8*], [2 x i8*]* @.B_vtable, i32 0, i32 0
store i8** %_169, i8*** %_168
%_170 = bitcast i8* %_167 to i8***
%_171 = load i8**, i8*** %_170
%_172 = getelementptr i8*, i8** %_171, i32 0
%_173 = load i8*, i8** %_172
%_174 = bitcast i8* %_173 to i32* (i8*,i1)*
%_175 = call i32* %_174(i8* %_167, i1 1)
%_176 = bitcast i8* %_175 to i32**
%_177 = load i32*, i32** %_176
%_178 = load i32, i32* %_177
%_179 = icmp sge i32 0, 0
%_180 = icmp slt i32 0, %_178
%_181 = and i1 %_179, %_180
br i1 %_181, label %tag_55, label %tag_54
tag_54:
call void @throw_oob()
br label %tag_55
tag_55:
%_182 = add i32 1, 0
%_183 = getelementptr i32, i32* %_177, i32 %_182
%_184 = load i32, i32* %_183
%_185 = load i32*, i32** %arr
%_186 = call i1 %_166(i8* %this, i32 %_184, i32* %_185)
%_187 = load i32*, i32** %arr
%_188 = load i32, i32* %_187
%_189 = icmp sge i32 0, 0
%_190 = icmp slt i32 0, %_188
%_191 = and i1 %_189, %_190
br i1 %_191, label %tag_57, label %tag_56
tag_56:
call void @throw_oob()
br label %tag_57
tag_57:
%_192 = add i32 1, 0
%_193 = getelementptr i32, i32* %_187, i32 %_192
%_194 = load i32, i32* %_193
%_195 = add i32 1, %_194
%_196 = icmp sge i32 %_195, 1
br i1 %_196, label %tag_59, label %tag_58
tag_58:
call void @throw_nsz()
br label %tag_59
tag_59:
%_197 = call i8* @calloc(i32 %_195, i32 4)
%_198 = bitcast i8* %_197 to i32*
store i32 %_194, i32* %_198
%_199 = call i1 %_161(i8* %this, i1 %_186, i32* %_198)
br label %tag_52
tag_52:
br label %tag_53
tag_53:
%_200 = phi i1  [ 0, %tag_50 ], [ %_199, %tag_52 ]
br label %tag_42
tag_42:
br label %tag_43
tag_43:
%_201 = phi i1  [ 0, %tag_40 ], [ %_200, %tag_42 ]
ret i1 %_201
}

define i32* @C.test(i8* %this, i1 %.a){
%a = alloca i1
store i1 %.a, i1* %a
%_202 = add i32 1, 10
%_203 = icmp sge i32 %_202, 1
br i1 %_203, label %tag_61, label %tag_60
tag_60:
call void @throw_nsz()
br label %tag_61
tag_61:
%_204 = call i8* @calloc(i32 %_202, i32 4)
%_205 = bitcast i8* %_204 to i32*
store i32 10, i32* %_205
%_206 = load i32*, i32** %_205
ret i32* %_206
}

define i32* @B.test2(i8* %this, i32 %.i){
%i = alloca i32
store i32 %.i, i32* %i
%_207 = load i32, i32* %i
%_208 = add i32 1, %_207
%_209 = icmp sge i32 %_208, 1
br i1 %_209, label %tag_63, label %tag_62
tag_62:
call void @throw_nsz()
br label %tag_63
tag_63:
%_210 = call i8* @calloc(i32 %_208, i32 4)
%_211 = bitcast i8* %_210 to i32*
store i32 %_207, i32* %_211
%_212 = load i32*, i32** %_211
ret i32* %_212
}


