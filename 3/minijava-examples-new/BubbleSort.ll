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

@.BBS_vtable = global [4 x i8*] [ 
	i8* bitcast (i32 (i8*,i32)* @BBS.Start to i8*),
	i8* bitcast (i32 (i8*)* @BBS.Sort to i8*),
	i8* bitcast (i32 (i8*)* @BBS.Print to i8*),
	i8* bitcast (i32 (i8*,i32)* @BBS.Init to i8*)
]

define i32 @main() {
%_0 = call i8* @calloc(i32 1, i32 20)
%_1 = bitcast i8* %_0 to i8***
%_2 = getelementptr [4 x i8*], [4 x i8*]* @.BBS_vtable, i32 0, i32 0
store i8** %_2, i8*** %_1
%_3 = bitcast i8* %_0 to i8***
%_4 = load i8**, i8*** %_3
%_5 = getelementptr i8*, i8** %_4, i32 0
%_6 = load i8*, i8** %_5
%_7 = bitcast i8* %_6 to i32 (i8*,i32)*
%_8 = call i32 %_7(i8* %_0, i32 10)
call void (i32) @print_int(i32 %_8)
ret i32 0
}

define i32 @BBS.Start(i8* %this, i32 %.sz){
%sz = alloca i32
store i32 %.sz, i32* %sz
%aux01 = alloca i32
store i32 0, i32* %aux01
%_9 = bitcast i8* %this to i8***
%_10 = load i8**, i8*** %_9
%_11 = getelementptr i8*, i8** %_10, i32 3
%_12 = load i8*, i8** %_11
%_13 = bitcast i8* %_12 to i32 (i8*,i32)*
%_14 = load i32, i32* %sz
%_15 = call i32 %_13(i8* %this, i32 %_14)
store i32 %_15, i32* %aux01
%_16 = bitcast i8* %this to i8***
%_17 = load i8**, i8*** %_16
%_18 = getelementptr i8*, i8** %_17, i32 2
%_19 = load i8*, i8** %_18
%_20 = bitcast i8* %_19 to i32 (i8*)*
%_21 = call i32 %_20(i8* %this)
store i32 %_21, i32* %aux01
call void (i32) @print_int(i32 99999)
%_22 = bitcast i8* %this to i8***
%_23 = load i8**, i8*** %_22
%_24 = getelementptr i8*, i8** %_23, i32 1
%_25 = load i8*, i8** %_24
%_26 = bitcast i8* %_25 to i32 (i8*)*
%_27 = call i32 %_26(i8* %this)
store i32 %_27, i32* %aux01
%_28 = bitcast i8* %this to i8***
%_29 = load i8**, i8*** %_28
%_30 = getelementptr i8*, i8** %_29, i32 2
%_31 = load i8*, i8** %_30
%_32 = bitcast i8* %_31 to i32 (i8*)*
%_33 = call i32 %_32(i8* %this)
store i32 %_33, i32* %aux01
ret i32 0
}

define i32 @BBS.Sort(i8* %this){
%nt = alloca i32
store i32 0, i32* %nt
%i = alloca i32
store i32 0, i32* %i
%aux02 = alloca i32
store i32 0, i32* %aux02
%aux04 = alloca i32
store i32 0, i32* %aux04
%aux05 = alloca i32
store i32 0, i32* %aux05
%aux06 = alloca i32
store i32 0, i32* %aux06
%aux07 = alloca i32
store i32 0, i32* %aux07
%j = alloca i32
store i32 0, i32* %j
%t = alloca i32
store i32 0, i32* %t
%_35 = getelementptr i8, i8* %this, i32 16
%_36 = bitcast i8* %_35 to i32*
%_37 = load i32, i32* %_36
%_34 = sub i32 %_37, 1
store i32 %_34, i32* %i
%_38 = sub i32 0, 1
store i32 %_38, i32* %aux02
;WhileStatement
br label %tag_0
tag_0:
%_39 = load i32, i32* %aux02
%_40 = load i32, i32* %i
%_41 = icmp slt i32 %_39, %_40
br i1 %_41, label %tag_1, label %tag_2
tag_1:
store i32 1, i32* %j
;WhileStatement
br label %tag_3
tag_3:
%_42 = load i32, i32* %j
%_44 = load i32, i32* %i
%_43 = add i32 %_44, 1
%_45 = icmp slt i32 %_42, %_43
br i1 %_45, label %tag_4, label %tag_5
tag_4:
%_47 = load i32, i32* %j
%_46 = sub i32 %_47, 1
store i32 %_46, i32* %aux07
%_48 = load i32, i32* %aux07
%_49 = getelementptr i8, i8* %this, i32 8
%_50 = bitcast i8* %_49 to i32**
%_51 = load i32*, i32** %_50
%_52 = load i32, i32* %_51
%_53 = icmp sge i32 %_48, 0
%_54 = icmp slt i32 %_48, %_52
%_55 = and i1 %_53, %_54
br i1 %_55, label %tag_7, label %tag_6
tag_6:
call void @throw_oob()
br label %tag_7
tag_7:
%_56 = add i32 1, %_48
%_57 = getelementptr i32, i32* %_51, i32 %_56
%_58 = load i32, i32* %_57
store i32 %_58, i32* %aux04
%_59 = load i32, i32* %j
%_60 = getelementptr i8, i8* %this, i32 8
%_61 = bitcast i8* %_60 to i32**
%_62 = load i32*, i32** %_61
%_63 = load i32, i32* %_62
%_64 = icmp sge i32 %_59, 0
%_65 = icmp slt i32 %_59, %_63
%_66 = and i1 %_64, %_65
br i1 %_66, label %tag_9, label %tag_8
tag_8:
call void @throw_oob()
br label %tag_9
tag_9:
%_67 = add i32 1, %_59
%_68 = getelementptr i32, i32* %_62, i32 %_67
%_69 = load i32, i32* %_68
store i32 %_69, i32* %aux05
%_70 = load i32, i32* %aux05
%_71 = load i32, i32* %aux04
%_72 = icmp slt i32 %_70, %_71
;IfStatement
br i1 %_72, label %tag_10, label %tag_11
tag_10:
%_74 = load i32, i32* %j
%_73 = sub i32 %_74, 1
store i32 %_73, i32* %aux06
%_75 = load i32, i32* %aux06
%_76 = getelementptr i8, i8* %this, i32 8
%_77 = bitcast i8* %_76 to i32**
%_78 = load i32*, i32** %_77
%_79 = load i32, i32* %_78
%_80 = icmp sge i32 %_75, 0
%_81 = icmp slt i32 %_75, %_79
%_82 = and i1 %_80, %_81
br i1 %_82, label %tag_14, label %tag_13
tag_13:
call void @throw_oob()
br label %tag_14
tag_14:
%_83 = add i32 1, %_75
%_84 = getelementptr i32, i32* %_78, i32 %_83
%_85 = load i32, i32* %_84
store i32 %_85, i32* %t
%_86 = load i32, i32* %aux06
%_87 = load i32, i32* %j
%_88 = getelementptr i8, i8* %this, i32 8
%_89 = bitcast i8* %_88 to i32**
%_90 = load i32*, i32** %_89
%_91 = load i32, i32* %_90
%_92 = icmp sge i32 %_87, 0
%_93 = icmp slt i32 %_87, %_91
%_94 = and i1 %_92, %_93
br i1 %_94, label %tag_16, label %tag_15
tag_15:
call void @throw_oob()
br label %tag_16
tag_16:
%_95 = add i32 1, %_87
%_96 = getelementptr i32, i32* %_90, i32 %_95
%_97 = load i32, i32* %_96
%_98 = getelementptr i8, i8* %this, i32 8
%_99 = bitcast i8* %_98 to i32**
%_100 = load i32*, i32** %_99
%_101 = load i32, i32* %_100
%_102 = icmp sge i32 %_86, 0
%_103 = icmp slt i32 %_86, %_101
%_104 = and i1 %_102, %_103
br i1 %_104, label %tag_18, label %tag_17
tag_17:
call void @throw_oob()
br label %tag_18
tag_18:
%_105 = add i32 1, %_86
%_106 = getelementptr i32, i32* %_100, i32 %_105
store i32 %_97, i32* %_106
%_107 = load i32, i32* %j
%_108 = load i32, i32* %t
%_109 = getelementptr i8, i8* %this, i32 8
%_110 = bitcast i8* %_109 to i32**
%_111 = load i32*, i32** %_110
%_112 = load i32, i32* %_111
%_113 = icmp sge i32 %_107, 0
%_114 = icmp slt i32 %_107, %_112
%_115 = and i1 %_113, %_114
br i1 %_115, label %tag_20, label %tag_19
tag_19:
call void @throw_oob()
br label %tag_20
tag_20:
%_116 = add i32 1, %_107
%_117 = getelementptr i32, i32* %_111, i32 %_116
store i32 %_108, i32* %_117
br label %tag_12
tag_11:
store i32 0, i32* %nt
br label %tag_12
tag_12:
%_119 = load i32, i32* %j
%_118 = add i32 %_119, 1
store i32 %_118, i32* %j
br label %tag_3
tag_5:
%_121 = load i32, i32* %i
%_120 = sub i32 %_121, 1
store i32 %_120, i32* %i
br label %tag_0
tag_2:
ret i32 0
}

define i32 @BBS.Print(i8* %this){
%j = alloca i32
store i32 0, i32* %j
store i32 0, i32* %j
;WhileStatement
br label %tag_21
tag_21:
%_122 = load i32, i32* %j
%_123 = getelementptr i8, i8* %this, i32 16
%_124 = bitcast i8* %_123 to i32*
%_125 = load i32, i32* %_124
%_126 = icmp slt i32 %_122, %_125
br i1 %_126, label %tag_22, label %tag_23
tag_22:
%_127 = load i32, i32* %j
%_128 = getelementptr i8, i8* %this, i32 8
%_129 = bitcast i8* %_128 to i32**
%_130 = load i32*, i32** %_129
%_131 = load i32, i32* %_130
%_132 = icmp sge i32 %_127, 0
%_133 = icmp slt i32 %_127, %_131
%_134 = and i1 %_132, %_133
br i1 %_134, label %tag_25, label %tag_24
tag_24:
call void @throw_oob()
br label %tag_25
tag_25:
%_135 = add i32 1, %_127
%_136 = getelementptr i32, i32* %_130, i32 %_135
%_137 = load i32, i32* %_136
call void (i32) @print_int(i32 %_137)
%_139 = load i32, i32* %j
%_138 = add i32 %_139, 1
store i32 %_138, i32* %j
br label %tag_21
tag_23:
ret i32 0
}

define i32 @BBS.Init(i8* %this, i32 %.sz){
%sz = alloca i32
store i32 %.sz, i32* %sz
%_140 = getelementptr i8, i8* %this, i32 16
%_141 = bitcast i8* %_140 to i32*
%_142 = load i32, i32* %sz
store i32 %_142, i32* %_141
%_143 = getelementptr i8, i8* %this, i32 8
%_144 = bitcast i8* %_143 to i32**
%_145 = load i32, i32* %sz
%_146 = add i32 1, %_145
%_147 = icmp sge i32 %_146, 1
br i1 %_147, label %tag_27, label %tag_26
tag_26:
call void @throw_nsz()
br label %tag_27
tag_27:
%_148 = call i8* @calloc(i32 %_146, i32 4)
%_149 = bitcast i8* %_148 to i32*
store i32 %_145, i32* %_149
store i32* %_149, i32** %_144
%_150 = getelementptr i8, i8* %this, i32 8
%_151 = bitcast i8* %_150 to i32**
%_152 = load i32*, i32** %_151
%_153 = load i32, i32* %_152
%_154 = icmp sge i32 0, 0
%_155 = icmp slt i32 0, %_153
%_156 = and i1 %_154, %_155
br i1 %_156, label %tag_29, label %tag_28
tag_28:
call void @throw_oob()
br label %tag_29
tag_29:
%_157 = add i32 1, 0
%_158 = getelementptr i32, i32* %_152, i32 %_157
store i32 20, i32* %_158
%_159 = getelementptr i8, i8* %this, i32 8
%_160 = bitcast i8* %_159 to i32**
%_161 = load i32*, i32** %_160
%_162 = load i32, i32* %_161
%_163 = icmp sge i32 1, 0
%_164 = icmp slt i32 1, %_162
%_165 = and i1 %_163, %_164
br i1 %_165, label %tag_31, label %tag_30
tag_30:
call void @throw_oob()
br label %tag_31
tag_31:
%_166 = add i32 1, 1
%_167 = getelementptr i32, i32* %_161, i32 %_166
store i32 7, i32* %_167
%_168 = getelementptr i8, i8* %this, i32 8
%_169 = bitcast i8* %_168 to i32**
%_170 = load i32*, i32** %_169
%_171 = load i32, i32* %_170
%_172 = icmp sge i32 2, 0
%_173 = icmp slt i32 2, %_171
%_174 = and i1 %_172, %_173
br i1 %_174, label %tag_33, label %tag_32
tag_32:
call void @throw_oob()
br label %tag_33
tag_33:
%_175 = add i32 1, 2
%_176 = getelementptr i32, i32* %_170, i32 %_175
store i32 12, i32* %_176
%_177 = getelementptr i8, i8* %this, i32 8
%_178 = bitcast i8* %_177 to i32**
%_179 = load i32*, i32** %_178
%_180 = load i32, i32* %_179
%_181 = icmp sge i32 3, 0
%_182 = icmp slt i32 3, %_180
%_183 = and i1 %_181, %_182
br i1 %_183, label %tag_35, label %tag_34
tag_34:
call void @throw_oob()
br label %tag_35
tag_35:
%_184 = add i32 1, 3
%_185 = getelementptr i32, i32* %_179, i32 %_184
store i32 18, i32* %_185
%_186 = getelementptr i8, i8* %this, i32 8
%_187 = bitcast i8* %_186 to i32**
%_188 = load i32*, i32** %_187
%_189 = load i32, i32* %_188
%_190 = icmp sge i32 4, 0
%_191 = icmp slt i32 4, %_189
%_192 = and i1 %_190, %_191
br i1 %_192, label %tag_37, label %tag_36
tag_36:
call void @throw_oob()
br label %tag_37
tag_37:
%_193 = add i32 1, 4
%_194 = getelementptr i32, i32* %_188, i32 %_193
store i32 2, i32* %_194
%_195 = getelementptr i8, i8* %this, i32 8
%_196 = bitcast i8* %_195 to i32**
%_197 = load i32*, i32** %_196
%_198 = load i32, i32* %_197
%_199 = icmp sge i32 5, 0
%_200 = icmp slt i32 5, %_198
%_201 = and i1 %_199, %_200
br i1 %_201, label %tag_39, label %tag_38
tag_38:
call void @throw_oob()
br label %tag_39
tag_39:
%_202 = add i32 1, 5
%_203 = getelementptr i32, i32* %_197, i32 %_202
store i32 11, i32* %_203
%_204 = getelementptr i8, i8* %this, i32 8
%_205 = bitcast i8* %_204 to i32**
%_206 = load i32*, i32** %_205
%_207 = load i32, i32* %_206
%_208 = icmp sge i32 6, 0
%_209 = icmp slt i32 6, %_207
%_210 = and i1 %_208, %_209
br i1 %_210, label %tag_41, label %tag_40
tag_40:
call void @throw_oob()
br label %tag_41
tag_41:
%_211 = add i32 1, 6
%_212 = getelementptr i32, i32* %_206, i32 %_211
store i32 6, i32* %_212
%_213 = getelementptr i8, i8* %this, i32 8
%_214 = bitcast i8* %_213 to i32**
%_215 = load i32*, i32** %_214
%_216 = load i32, i32* %_215
%_217 = icmp sge i32 7, 0
%_218 = icmp slt i32 7, %_216
%_219 = and i1 %_217, %_218
br i1 %_219, label %tag_43, label %tag_42
tag_42:
call void @throw_oob()
br label %tag_43
tag_43:
%_220 = add i32 1, 7
%_221 = getelementptr i32, i32* %_215, i32 %_220
store i32 9, i32* %_221
%_222 = getelementptr i8, i8* %this, i32 8
%_223 = bitcast i8* %_222 to i32**
%_224 = load i32*, i32** %_223
%_225 = load i32, i32* %_224
%_226 = icmp sge i32 8, 0
%_227 = icmp slt i32 8, %_225
%_228 = and i1 %_226, %_227
br i1 %_228, label %tag_45, label %tag_44
tag_44:
call void @throw_oob()
br label %tag_45
tag_45:
%_229 = add i32 1, 8
%_230 = getelementptr i32, i32* %_224, i32 %_229
store i32 19, i32* %_230
%_231 = getelementptr i8, i8* %this, i32 8
%_232 = bitcast i8* %_231 to i32**
%_233 = load i32*, i32** %_232
%_234 = load i32, i32* %_233
%_235 = icmp sge i32 9, 0
%_236 = icmp slt i32 9, %_234
%_237 = and i1 %_235, %_236
br i1 %_237, label %tag_47, label %tag_46
tag_46:
call void @throw_oob()
br label %tag_47
tag_47:
%_238 = add i32 1, 9
%_239 = getelementptr i32, i32* %_233, i32 %_238
store i32 5, i32* %_239
ret i32 0
}


