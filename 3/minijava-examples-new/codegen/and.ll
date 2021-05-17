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

@.A_vtable = global [3 x i8*] [ 
	i8* bitcast (i1 (i8*,i1,i1,i1)* @A.foo to i8*),
	i8* bitcast (i1 (i8*,i1,i1)* @A.bar to i8*),
	i8* bitcast (i1 (i8*,i1)* @A.print to i8*)
]

@.B_vtable = global [2 x i8*] [ 
	i8* bitcast (i1 (i8*,i32)* @B.foo to i8*),
	i8* bitcast (i1 (i8*,i32,i32,i1,i1)* @B.t to i8*)
]

define i32 @main() {
%dummy = alloca i1
store i1 0, i1* %dummy
%a = alloca i8*
store i8* null, i8** %a
%_0 = call i8* @calloc(i32 1, i32 8)
%_1 = bitcast i8* %_0 to i8***
%_2 = getelementptr [3 x i8*], [3 x i8*]* @.A_vtable, i32 0, i32 0
store i8** %_2, i8*** %_1
store i8* %_0, i8** %a
%_3 = load i8*, i8** %a
%_4 = bitcast i8* %_3 to i8***
%_5 = load i8**, i8*** %_4
%_6 = getelementptr i8*, i8** %_5, i32 2
%_7 = load i8*, i8** %_6
%_8 = bitcast i8* %_7 to i1 (i8*,i1)*
%_9 = load i8*, i8** %a
%_10 = bitcast i8* %_9 to i8***
%_11 = load i8**, i8*** %_10
%_12 = getelementptr i8*, i8** %_11, i32 0
%_13 = load i8*, i8** %_12
%_14 = bitcast i8* %_13 to i1 (i8*,i1,i1,i1)*
%_15 = call i1 %_14(i8* %_9, i1 0, i1 0, i1 0)
%_16 = call i1 %_8(i8* %_3, i1 %_15)
store i1 %_16, i1* %dummy
%_17 = load i8*, i8** %a
%_18 = bitcast i8* %_17 to i8***
%_19 = load i8**, i8*** %_18
%_20 = getelementptr i8*, i8** %_19, i32 2
%_21 = load i8*, i8** %_20
%_22 = bitcast i8* %_21 to i1 (i8*,i1)*
%_23 = load i8*, i8** %a
%_24 = bitcast i8* %_23 to i8***
%_25 = load i8**, i8*** %_24
%_26 = getelementptr i8*, i8** %_25, i32 0
%_27 = load i8*, i8** %_26
%_28 = bitcast i8* %_27 to i1 (i8*,i1,i1,i1)*
%_29 = call i1 %_28(i8* %_23, i1 0, i1 0, i1 1)
%_30 = call i1 %_22(i8* %_17, i1 %_29)
store i1 %_30, i1* %dummy
%_31 = load i8*, i8** %a
%_32 = bitcast i8* %_31 to i8***
%_33 = load i8**, i8*** %_32
%_34 = getelementptr i8*, i8** %_33, i32 2
%_35 = load i8*, i8** %_34
%_36 = bitcast i8* %_35 to i1 (i8*,i1)*
%_37 = load i8*, i8** %a
%_38 = bitcast i8* %_37 to i8***
%_39 = load i8**, i8*** %_38
%_40 = getelementptr i8*, i8** %_39, i32 0
%_41 = load i8*, i8** %_40
%_42 = bitcast i8* %_41 to i1 (i8*,i1,i1,i1)*
%_43 = call i1 %_42(i8* %_37, i1 0, i1 1, i1 0)
%_44 = call i1 %_36(i8* %_31, i1 %_43)
store i1 %_44, i1* %dummy
%_45 = load i8*, i8** %a
%_46 = bitcast i8* %_45 to i8***
%_47 = load i8**, i8*** %_46
%_48 = getelementptr i8*, i8** %_47, i32 2
%_49 = load i8*, i8** %_48
%_50 = bitcast i8* %_49 to i1 (i8*,i1)*
%_51 = load i8*, i8** %a
%_52 = bitcast i8* %_51 to i8***
%_53 = load i8**, i8*** %_52
%_54 = getelementptr i8*, i8** %_53, i32 0
%_55 = load i8*, i8** %_54
%_56 = bitcast i8* %_55 to i1 (i8*,i1,i1,i1)*
%_57 = call i1 %_56(i8* %_51, i1 0, i1 1, i1 1)
%_58 = call i1 %_50(i8* %_45, i1 %_57)
store i1 %_58, i1* %dummy
%_59 = load i8*, i8** %a
%_60 = bitcast i8* %_59 to i8***
%_61 = load i8**, i8*** %_60
%_62 = getelementptr i8*, i8** %_61, i32 2
%_63 = load i8*, i8** %_62
%_64 = bitcast i8* %_63 to i1 (i8*,i1)*
%_65 = load i8*, i8** %a
%_66 = bitcast i8* %_65 to i8***
%_67 = load i8**, i8*** %_66
%_68 = getelementptr i8*, i8** %_67, i32 0
%_69 = load i8*, i8** %_68
%_70 = bitcast i8* %_69 to i1 (i8*,i1,i1,i1)*
%_71 = call i1 %_70(i8* %_65, i1 1, i1 0, i1 0)
%_72 = call i1 %_64(i8* %_59, i1 %_71)
store i1 %_72, i1* %dummy
%_73 = load i8*, i8** %a
%_74 = bitcast i8* %_73 to i8***
%_75 = load i8**, i8*** %_74
%_76 = getelementptr i8*, i8** %_75, i32 2
%_77 = load i8*, i8** %_76
%_78 = bitcast i8* %_77 to i1 (i8*,i1)*
%_79 = load i8*, i8** %a
%_80 = bitcast i8* %_79 to i8***
%_81 = load i8**, i8*** %_80
%_82 = getelementptr i8*, i8** %_81, i32 0
%_83 = load i8*, i8** %_82
%_84 = bitcast i8* %_83 to i1 (i8*,i1,i1,i1)*
%_85 = call i1 %_84(i8* %_79, i1 1, i1 0, i1 1)
%_86 = call i1 %_78(i8* %_73, i1 %_85)
store i1 %_86, i1* %dummy
%_87 = load i8*, i8** %a
%_88 = bitcast i8* %_87 to i8***
%_89 = load i8**, i8*** %_88
%_90 = getelementptr i8*, i8** %_89, i32 2
%_91 = load i8*, i8** %_90
%_92 = bitcast i8* %_91 to i1 (i8*,i1)*
%_93 = load i8*, i8** %a
%_94 = bitcast i8* %_93 to i8***
%_95 = load i8**, i8*** %_94
%_96 = getelementptr i8*, i8** %_95, i32 0
%_97 = load i8*, i8** %_96
%_98 = bitcast i8* %_97 to i1 (i8*,i1,i1,i1)*
%_99 = call i1 %_98(i8* %_93, i1 1, i1 1, i1 0)
%_100 = call i1 %_92(i8* %_87, i1 %_99)
store i1 %_100, i1* %dummy
%_101 = load i8*, i8** %a
%_102 = bitcast i8* %_101 to i8***
%_103 = load i8**, i8*** %_102
%_104 = getelementptr i8*, i8** %_103, i32 2
%_105 = load i8*, i8** %_104
%_106 = bitcast i8* %_105 to i1 (i8*,i1)*
%_107 = load i8*, i8** %a
%_108 = bitcast i8* %_107 to i8***
%_109 = load i8**, i8*** %_108
%_110 = getelementptr i8*, i8** %_109, i32 0
%_111 = load i8*, i8** %_110
%_112 = bitcast i8* %_111 to i1 (i8*,i1,i1,i1)*
%_113 = call i1 %_112(i8* %_107, i1 1, i1 1, i1 1)
%_114 = call i1 %_106(i8* %_101, i1 %_113)
store i1 %_114, i1* %dummy
%_115 = load i8*, i8** %a
%_116 = bitcast i8* %_115 to i8***
%_117 = load i8**, i8*** %_116
%_118 = getelementptr i8*, i8** %_117, i32 2
%_119 = load i8*, i8** %_118
%_120 = bitcast i8* %_119 to i1 (i8*,i1)*
%_121 = load i8*, i8** %a
%_122 = bitcast i8* %_121 to i8***
%_123 = load i8**, i8*** %_122
%_124 = getelementptr i8*, i8** %_123, i32 1
%_125 = load i8*, i8** %_124
%_126 = bitcast i8* %_125 to i1 (i8*,i1,i1)*
%_127 = call i1 %_126(i8* %_121, i1 1, i1 1)
%_128 = call i1 %_120(i8* %_115, i1 %_127)
store i1 %_128, i1* %dummy
%_129 = load i8*, i8** %a
%_130 = bitcast i8* %_129 to i8***
%_131 = load i8**, i8*** %_130
%_132 = getelementptr i8*, i8** %_131, i32 2
%_133 = load i8*, i8** %_132
%_134 = bitcast i8* %_133 to i1 (i8*,i1)*
%_135 = load i8*, i8** %a
%_136 = bitcast i8* %_135 to i8***
%_137 = load i8**, i8*** %_136
%_138 = getelementptr i8*, i8** %_137, i32 1
%_139 = load i8*, i8** %_138
%_140 = bitcast i8* %_139 to i1 (i8*,i1,i1)*
%_141 = call i1 %_140(i8* %_135, i1 0, i1 1)
%_142 = call i1 %_134(i8* %_129, i1 %_141)
store i1 %_142, i1* %dummy
%_143 = load i8*, i8** %a
%_144 = bitcast i8* %_143 to i8***
%_145 = load i8**, i8*** %_144
%_146 = getelementptr i8*, i8** %_145, i32 2
%_147 = load i8*, i8** %_146
%_148 = bitcast i8* %_147 to i1 (i8*,i1)*
%_149 = call i8* @calloc(i32 1, i32 8)
%_150 = bitcast i8* %_149 to i8***
%_151 = getelementptr [2 x i8*], [2 x i8*]* @.B_vtable, i32 0, i32 0
store i8** %_151, i8*** %_150
%_152 = bitcast i8* %_149 to i8***
%_153 = load i8**, i8*** %_152
%_154 = getelementptr i8*, i8** %_153, i32 0
%_155 = load i8*, i8** %_154
%_156 = bitcast i8* %_155 to i1 (i8*,i32)*
%_157 = call i1 %_156(i8* %_149, i32 1)
%_158 = call i1 %_148(i8* %_143, i1 %_157)
store i1 %_158, i1* %dummy
%_159 = load i8*, i8** %a
%_160 = bitcast i8* %_159 to i8***
%_161 = load i8**, i8*** %_160
%_162 = getelementptr i8*, i8** %_161, i32 2
%_163 = load i8*, i8** %_162
%_164 = bitcast i8* %_163 to i1 (i8*,i1)*
%_165 = call i8* @calloc(i32 1, i32 8)
%_166 = bitcast i8* %_165 to i8***
%_167 = getelementptr [2 x i8*], [2 x i8*]* @.B_vtable, i32 0, i32 0
store i8** %_167, i8*** %_166
%_168 = bitcast i8* %_165 to i8***
%_169 = load i8**, i8*** %_168
%_170 = getelementptr i8*, i8** %_169, i32 0
%_171 = load i8*, i8** %_170
%_172 = bitcast i8* %_171 to i1 (i8*,i32)*
%_173 = call i1 %_172(i8* %_165, i32 2)
%_174 = call i1 %_164(i8* %_159, i1 %_173)
store i1 %_174, i1* %dummy
%_175 = load i8*, i8** %a
%_176 = bitcast i8* %_175 to i8***
%_177 = load i8**, i8*** %_176
%_178 = getelementptr i8*, i8** %_177, i32 2
%_179 = load i8*, i8** %_178
%_180 = bitcast i8* %_179 to i1 (i8*,i1)*
%_181 = call i8* @calloc(i32 1, i32 8)
%_182 = bitcast i8* %_181 to i8***
%_183 = getelementptr [2 x i8*], [2 x i8*]* @.B_vtable, i32 0, i32 0
store i8** %_183, i8*** %_182
%_184 = bitcast i8* %_181 to i8***
%_185 = load i8**, i8*** %_184
%_186 = getelementptr i8*, i8** %_185, i32 1
%_187 = load i8*, i8** %_186
%_188 = bitcast i8* %_187 to i1 (i8*,i32,i32,i1,i1)*
%_189 = call i1 %_188(i8* %_181, i32 2, i32 2, i1 1, i1 1)
%_190 = call i1 %_180(i8* %_175, i1 %_189)
store i1 %_190, i1* %dummy
ret i32 0
}

define i1 @A.foo(i8* %this, i1 %.a, i1 %.b, i1 %.c){
%a = alloca i1
store i1 %.a, i1* %a
%b = alloca i1
store i1 %.b, i1* %b
%c = alloca i1
store i1 %.c, i1* %c
;AndExpression
;AndExpression
%_191 = load i1, i1* %a
br i1 %_191, label %tag_1, label %tag_0
tag_0:
br label %tag_3
tag_1:
%_192 = load i1, i1* %b
br label %tag_2
tag_2:
br label %tag_3
tag_3:
%_193 = phi i1  [ 0, %tag_0 ], [ %_192, %tag_2 ]
br i1 %_193, label %tag_5, label %tag_4
tag_4:
br label %tag_7
tag_5:
%_194 = load i1, i1* %c
br label %tag_6
tag_6:
br label %tag_7
tag_7:
%_195 = phi i1  [ 0, %tag_4 ], [ %_194, %tag_6 ]
ret i1 %_195
}

define i1 @A.bar(i8* %this, i1 %.a, i1 %.b){
%a = alloca i1
store i1 %.a, i1* %a
%b = alloca i1
store i1 %.b, i1* %b
;AndExpression
;AndExpression
%_196 = load i1, i1* %a
br i1 %_196, label %tag_9, label %tag_8
tag_8:
br label %tag_11
tag_9:
%_197 = bitcast i8* %this to i8***
%_198 = load i8**, i8*** %_197
%_199 = getelementptr i8*, i8** %_198, i32 0
%_200 = load i8*, i8** %_199
%_201 = bitcast i8* %_200 to i1 (i8*,i1,i1,i1)*
%_202 = load i1, i1* %a
%_203 = load i1, i1* %b
%_204 = call i1 %_201(i8* %this, i1 %_202, i1 %_203, i1 1)
br label %tag_10
tag_10:
br label %tag_11
tag_11:
%_205 = phi i1  [ 0, %tag_8 ], [ %_204, %tag_10 ]
br i1 %_205, label %tag_13, label %tag_12
tag_12:
br label %tag_15
tag_13:
%_206 = load i1, i1* %b
br label %tag_14
tag_14:
br label %tag_15
tag_15:
%_207 = phi i1  [ 0, %tag_12 ], [ %_206, %tag_14 ]
ret i1 %_207
}

define i1 @A.print(i8* %this, i1 %.res){
%res = alloca i1
store i1 %.res, i1* %res
%_208 = load i1, i1* %res
;IfStatement
br i1 %_208, label %tag_16, label %tag_17
tag_16:
call void (i32) @print_int(i32 1)
br label %tag_18
tag_17:
call void (i32) @print_int(i32 0)
br label %tag_18
tag_18:
ret i1 1
}

define i1 @B.foo(i8* %this, i32 %.a){
%a = alloca i32
store i32 %.a, i32* %a
;AndExpression
%_210 = load i32, i32* %a
%_209 = add i32 %_210, 2
%_211 = icmp slt i32 3, %_209
%_212 = xor i1 1, %_211
br i1 %_212, label %tag_20, label %tag_19
tag_19:
br label %tag_22
tag_20:
%_213 = xor i1 1, 0
br label %tag_21
tag_21:
br label %tag_22
tag_22:
%_214 = phi i1  [ 0, %tag_19 ], [ %_213, %tag_21 ]
ret i1 %_214
}

define i1 @B.t(i8* %this, i32 %.a, i32 %.b, i1 %.c, i1 %.d){
%a = alloca i32
store i32 %.a, i32* %a
%b = alloca i32
store i32 %.b, i32* %b
%c = alloca i1
store i1 %.c, i1* %c
%d = alloca i1
store i1 %.d, i1* %d
;AndExpression
%_215 = load i32, i32* %a
%_216 = load i32, i32* %b
%_217 = icmp slt i32 %_215, %_216
%_218 = xor i1 1, %_217
br i1 %_218, label %tag_24, label %tag_23
tag_23:
br label %tag_26
tag_24:
;AndExpression
%_219 = load i1, i1* %c
br i1 %_219, label %tag_28, label %tag_27
tag_27:
br label %tag_30
tag_28:
%_220 = load i1, i1* %d
br label %tag_29
tag_29:
br label %tag_30
tag_30:
%_221 = phi i1  [ 0, %tag_27 ], [ %_220, %tag_29 ]
br label %tag_25
tag_25:
br label %tag_26
tag_26:
%_222 = phi i1  [ 0, %tag_23 ], [ %_221, %tag_25 ]
ret i1 %_222
}


