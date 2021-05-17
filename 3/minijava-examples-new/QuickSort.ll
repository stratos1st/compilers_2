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

@.QS_vtable = global [4 x i8*] [ 
	i8* bitcast (i32 (i8*,i32)* @QS.Start to i8*),
	i8* bitcast (i32 (i8*,i32,i32)* @QS.Sort to i8*),
	i8* bitcast (i32 (i8*)* @QS.Print to i8*),
	i8* bitcast (i32 (i8*,i32)* @QS.Init to i8*)
]

define i32 @main() {
%_0 = call i8* @calloc(i32 1, i32 20)
%_1 = bitcast i8* %_0 to i8***
%_2 = getelementptr [4 x i8*], [4 x i8*]* @.QS_vtable, i32 0, i32 0
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

define i32 @QS.Start(i8* %this, i32 %.sz){
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
call void (i32) @print_int(i32 9999)
%_23 = getelementptr i8, i8* %this, i32 16
%_24 = bitcast i8* %_23 to i32*
%_25 = load i32, i32* %_24
%_22 = sub i32 %_25, 1
store i32 %_22, i32* %aux01
%_26 = bitcast i8* %this to i8***
%_27 = load i8**, i8*** %_26
%_28 = getelementptr i8*, i8** %_27, i32 1
%_29 = load i8*, i8** %_28
%_30 = bitcast i8* %_29 to i32 (i8*,i32,i32)*
%_31 = load i32, i32* %aux01
%_32 = call i32 %_30(i8* %this, i32 0, i32 %_31)
store i32 %_32, i32* %aux01
%_33 = bitcast i8* %this to i8***
%_34 = load i8**, i8*** %_33
%_35 = getelementptr i8*, i8** %_34, i32 2
%_36 = load i8*, i8** %_35
%_37 = bitcast i8* %_36 to i32 (i8*)*
%_38 = call i32 %_37(i8* %this)
store i32 %_38, i32* %aux01
ret i32 0
}

define i32 @QS.Sort(i8* %this, i32 %.left, i32 %.right){
%left = alloca i32
store i32 %.left, i32* %left
%right = alloca i32
store i32 %.right, i32* %right
%v = alloca i32
store i32 0, i32* %v
%i = alloca i32
store i32 0, i32* %i
%j = alloca i32
store i32 0, i32* %j
%nt = alloca i32
store i32 0, i32* %nt
%t = alloca i32
store i32 0, i32* %t
%cont01 = alloca i1
store i1 0, i1* %cont01
%cont02 = alloca i1
store i1 0, i1* %cont02
%aux03 = alloca i32
store i32 0, i32* %aux03
store i32 0, i32* %t
%_39 = load i32, i32* %left
%_40 = load i32, i32* %right
%_41 = icmp slt i32 %_39, %_40
;IfStatement
br i1 %_41, label %tag_0, label %tag_1
tag_0:
%_42 = load i32, i32* %right
%_43 = getelementptr i8, i8* %this, i32 8
%_44 = bitcast i8* %_43 to i32**
%_45 = load i32*, i32** %_44
%_46 = load i32, i32* %_45
%_47 = icmp sge i32 %_42, 0
%_48 = icmp slt i32 %_42, %_46
%_49 = and i1 %_47, %_48
br i1 %_49, label %tag_4, label %tag_3
tag_3:
call void @throw_oob()
br label %tag_4
tag_4:
%_50 = add i32 1, %_42
%_51 = getelementptr i32, i32* %_45, i32 %_50
%_52 = load i32, i32* %_51
store i32 %_52, i32* %v
%_54 = load i32, i32* %left
%_53 = sub i32 %_54, 1
store i32 %_53, i32* %i
%_55 = load i32, i32* %right
store i32 %_55, i32* %j
store i1 1, i1* %cont01
;WhileStatement
br label %tag_5
tag_5:
%_56 = load i1, i1* %cont01
br i1 %_56, label %tag_6, label %tag_7
tag_6:
store i1 1, i1* %cont02
;WhileStatement
br label %tag_8
tag_8:
%_57 = load i1, i1* %cont02
br i1 %_57, label %tag_9, label %tag_10
tag_9:
%_59 = load i32, i32* %i
%_58 = add i32 %_59, 1
store i32 %_58, i32* %i
%_60 = load i32, i32* %i
%_61 = getelementptr i8, i8* %this, i32 8
%_62 = bitcast i8* %_61 to i32**
%_63 = load i32*, i32** %_62
%_64 = load i32, i32* %_63
%_65 = icmp sge i32 %_60, 0
%_66 = icmp slt i32 %_60, %_64
%_67 = and i1 %_65, %_66
br i1 %_67, label %tag_12, label %tag_11
tag_11:
call void @throw_oob()
br label %tag_12
tag_12:
%_68 = add i32 1, %_60
%_69 = getelementptr i32, i32* %_63, i32 %_68
%_70 = load i32, i32* %_69
store i32 %_70, i32* %aux03
%_71 = load i32, i32* %aux03
%_72 = load i32, i32* %v
%_73 = icmp slt i32 %_71, %_72
%_74 = xor i1 1, %_73
;IfStatement
br i1 %_74, label %tag_13, label %tag_14
tag_13:
store i1 0, i1* %cont02
br label %tag_15
tag_14:
store i1 1, i1* %cont02
br label %tag_15
tag_15:
br label %tag_8
tag_10:
store i1 1, i1* %cont02
;WhileStatement
br label %tag_16
tag_16:
%_75 = load i1, i1* %cont02
br i1 %_75, label %tag_17, label %tag_18
tag_17:
%_77 = load i32, i32* %j
%_76 = sub i32 %_77, 1
store i32 %_76, i32* %j
%_78 = load i32, i32* %j
%_79 = getelementptr i8, i8* %this, i32 8
%_80 = bitcast i8* %_79 to i32**
%_81 = load i32*, i32** %_80
%_82 = load i32, i32* %_81
%_83 = icmp sge i32 %_78, 0
%_84 = icmp slt i32 %_78, %_82
%_85 = and i1 %_83, %_84
br i1 %_85, label %tag_20, label %tag_19
tag_19:
call void @throw_oob()
br label %tag_20
tag_20:
%_86 = add i32 1, %_78
%_87 = getelementptr i32, i32* %_81, i32 %_86
%_88 = load i32, i32* %_87
store i32 %_88, i32* %aux03
%_89 = load i32, i32* %v
%_90 = load i32, i32* %aux03
%_91 = icmp slt i32 %_89, %_90
%_92 = xor i1 1, %_91
;IfStatement
br i1 %_92, label %tag_21, label %tag_22
tag_21:
store i1 0, i1* %cont02
br label %tag_23
tag_22:
store i1 1, i1* %cont02
br label %tag_23
tag_23:
br label %tag_16
tag_18:
%_93 = load i32, i32* %i
%_94 = getelementptr i8, i8* %this, i32 8
%_95 = bitcast i8* %_94 to i32**
%_96 = load i32*, i32** %_95
%_97 = load i32, i32* %_96
%_98 = icmp sge i32 %_93, 0
%_99 = icmp slt i32 %_93, %_97
%_100 = and i1 %_98, %_99
br i1 %_100, label %tag_25, label %tag_24
tag_24:
call void @throw_oob()
br label %tag_25
tag_25:
%_101 = add i32 1, %_93
%_102 = getelementptr i32, i32* %_96, i32 %_101
%_103 = load i32, i32* %_102
store i32 %_103, i32* %t
%_104 = load i32, i32* %i
%_105 = load i32, i32* %j
%_106 = getelementptr i8, i8* %this, i32 8
%_107 = bitcast i8* %_106 to i32**
%_108 = load i32*, i32** %_107
%_109 = load i32, i32* %_108
%_110 = icmp sge i32 %_105, 0
%_111 = icmp slt i32 %_105, %_109
%_112 = and i1 %_110, %_111
br i1 %_112, label %tag_27, label %tag_26
tag_26:
call void @throw_oob()
br label %tag_27
tag_27:
%_113 = add i32 1, %_105
%_114 = getelementptr i32, i32* %_108, i32 %_113
%_115 = load i32, i32* %_114
%_116 = getelementptr i8, i8* %this, i32 8
%_117 = bitcast i8* %_116 to i32**
%_118 = load i32*, i32** %_117
%_119 = load i32, i32* %_118
%_120 = icmp sge i32 %_104, 0
%_121 = icmp slt i32 %_104, %_119
%_122 = and i1 %_120, %_121
br i1 %_122, label %tag_29, label %tag_28
tag_28:
call void @throw_oob()
br label %tag_29
tag_29:
%_123 = add i32 1, %_104
%_124 = getelementptr i32, i32* %_118, i32 %_123
store i32 %_115, i32* %_124
%_125 = load i32, i32* %j
%_126 = load i32, i32* %t
%_127 = getelementptr i8, i8* %this, i32 8
%_128 = bitcast i8* %_127 to i32**
%_129 = load i32*, i32** %_128
%_130 = load i32, i32* %_129
%_131 = icmp sge i32 %_125, 0
%_132 = icmp slt i32 %_125, %_130
%_133 = and i1 %_131, %_132
br i1 %_133, label %tag_31, label %tag_30
tag_30:
call void @throw_oob()
br label %tag_31
tag_31:
%_134 = add i32 1, %_125
%_135 = getelementptr i32, i32* %_129, i32 %_134
store i32 %_126, i32* %_135
%_136 = load i32, i32* %j
%_138 = load i32, i32* %i
%_137 = add i32 %_138, 1
%_139 = icmp slt i32 %_136, %_137
;IfStatement
br i1 %_139, label %tag_32, label %tag_33
tag_32:
store i1 0, i1* %cont01
br label %tag_34
tag_33:
store i1 1, i1* %cont01
br label %tag_34
tag_34:
br label %tag_5
tag_7:
%_140 = load i32, i32* %j
%_141 = load i32, i32* %i
%_142 = getelementptr i8, i8* %this, i32 8
%_143 = bitcast i8* %_142 to i32**
%_144 = load i32*, i32** %_143
%_145 = load i32, i32* %_144
%_146 = icmp sge i32 %_141, 0
%_147 = icmp slt i32 %_141, %_145
%_148 = and i1 %_146, %_147
br i1 %_148, label %tag_36, label %tag_35
tag_35:
call void @throw_oob()
br label %tag_36
tag_36:
%_149 = add i32 1, %_141
%_150 = getelementptr i32, i32* %_144, i32 %_149
%_151 = load i32, i32* %_150
%_152 = getelementptr i8, i8* %this, i32 8
%_153 = bitcast i8* %_152 to i32**
%_154 = load i32*, i32** %_153
%_155 = load i32, i32* %_154
%_156 = icmp sge i32 %_140, 0
%_157 = icmp slt i32 %_140, %_155
%_158 = and i1 %_156, %_157
br i1 %_158, label %tag_38, label %tag_37
tag_37:
call void @throw_oob()
br label %tag_38
tag_38:
%_159 = add i32 1, %_140
%_160 = getelementptr i32, i32* %_154, i32 %_159
store i32 %_151, i32* %_160
%_161 = load i32, i32* %i
%_162 = load i32, i32* %right
%_163 = getelementptr i8, i8* %this, i32 8
%_164 = bitcast i8* %_163 to i32**
%_165 = load i32*, i32** %_164
%_166 = load i32, i32* %_165
%_167 = icmp sge i32 %_162, 0
%_168 = icmp slt i32 %_162, %_166
%_169 = and i1 %_167, %_168
br i1 %_169, label %tag_40, label %tag_39
tag_39:
call void @throw_oob()
br label %tag_40
tag_40:
%_170 = add i32 1, %_162
%_171 = getelementptr i32, i32* %_165, i32 %_170
%_172 = load i32, i32* %_171
%_173 = getelementptr i8, i8* %this, i32 8
%_174 = bitcast i8* %_173 to i32**
%_175 = load i32*, i32** %_174
%_176 = load i32, i32* %_175
%_177 = icmp sge i32 %_161, 0
%_178 = icmp slt i32 %_161, %_176
%_179 = and i1 %_177, %_178
br i1 %_179, label %tag_42, label %tag_41
tag_41:
call void @throw_oob()
br label %tag_42
tag_42:
%_180 = add i32 1, %_161
%_181 = getelementptr i32, i32* %_175, i32 %_180
store i32 %_172, i32* %_181
%_182 = load i32, i32* %right
%_183 = load i32, i32* %t
%_184 = getelementptr i8, i8* %this, i32 8
%_185 = bitcast i8* %_184 to i32**
%_186 = load i32*, i32** %_185
%_187 = load i32, i32* %_186
%_188 = icmp sge i32 %_182, 0
%_189 = icmp slt i32 %_182, %_187
%_190 = and i1 %_188, %_189
br i1 %_190, label %tag_44, label %tag_43
tag_43:
call void @throw_oob()
br label %tag_44
tag_44:
%_191 = add i32 1, %_182
%_192 = getelementptr i32, i32* %_186, i32 %_191
store i32 %_183, i32* %_192
%_193 = bitcast i8* %this to i8***
%_194 = load i8**, i8*** %_193
%_195 = getelementptr i8*, i8** %_194, i32 1
%_196 = load i8*, i8** %_195
%_197 = bitcast i8* %_196 to i32 (i8*,i32,i32)*
%_198 = load i32, i32* %left
%_200 = load i32, i32* %i
%_199 = sub i32 %_200, 1
%_201 = call i32 %_197(i8* %this, i32 %_198, i32 %_199)
store i32 %_201, i32* %nt
%_202 = bitcast i8* %this to i8***
%_203 = load i8**, i8*** %_202
%_204 = getelementptr i8*, i8** %_203, i32 1
%_205 = load i8*, i8** %_204
%_206 = bitcast i8* %_205 to i32 (i8*,i32,i32)*
%_208 = load i32, i32* %i
%_207 = add i32 %_208, 1
%_209 = load i32, i32* %right
%_210 = call i32 %_206(i8* %this, i32 %_207, i32 %_209)
store i32 %_210, i32* %nt
br label %tag_2
tag_1:
store i32 0, i32* %nt
br label %tag_2
tag_2:
ret i32 0
}

define i32 @QS.Print(i8* %this){
%j = alloca i32
store i32 0, i32* %j
store i32 0, i32* %j
;WhileStatement
br label %tag_45
tag_45:
%_211 = load i32, i32* %j
%_212 = getelementptr i8, i8* %this, i32 16
%_213 = bitcast i8* %_212 to i32*
%_214 = load i32, i32* %_213
%_215 = icmp slt i32 %_211, %_214
br i1 %_215, label %tag_46, label %tag_47
tag_46:
%_216 = load i32, i32* %j
%_217 = getelementptr i8, i8* %this, i32 8
%_218 = bitcast i8* %_217 to i32**
%_219 = load i32*, i32** %_218
%_220 = load i32, i32* %_219
%_221 = icmp sge i32 %_216, 0
%_222 = icmp slt i32 %_216, %_220
%_223 = and i1 %_221, %_222
br i1 %_223, label %tag_49, label %tag_48
tag_48:
call void @throw_oob()
br label %tag_49
tag_49:
%_224 = add i32 1, %_216
%_225 = getelementptr i32, i32* %_219, i32 %_224
%_226 = load i32, i32* %_225
call void (i32) @print_int(i32 %_226)
%_228 = load i32, i32* %j
%_227 = add i32 %_228, 1
store i32 %_227, i32* %j
br label %tag_45
tag_47:
ret i32 0
}

define i32 @QS.Init(i8* %this, i32 %.sz){
%sz = alloca i32
store i32 %.sz, i32* %sz
%_229 = getelementptr i8, i8* %this, i32 16
%_230 = bitcast i8* %_229 to i32*
%_231 = load i32, i32* %sz
store i32 %_231, i32* %_230
%_232 = getelementptr i8, i8* %this, i32 8
%_233 = bitcast i8* %_232 to i32**
%_234 = load i32, i32* %sz
%_235 = add i32 1, %_234
%_236 = icmp sge i32 %_235, 1
br i1 %_236, label %tag_51, label %tag_50
tag_50:
call void @throw_nsz()
br label %tag_51
tag_51:
%_237 = call i8* @calloc(i32 %_235, i32 4)
%_238 = bitcast i8* %_237 to i32*
store i32 %_234, i32* %_238
store i32* %_238, i32** %_233
%_239 = getelementptr i8, i8* %this, i32 8
%_240 = bitcast i8* %_239 to i32**
%_241 = load i32*, i32** %_240
%_242 = load i32, i32* %_241
%_243 = icmp sge i32 0, 0
%_244 = icmp slt i32 0, %_242
%_245 = and i1 %_243, %_244
br i1 %_245, label %tag_53, label %tag_52
tag_52:
call void @throw_oob()
br label %tag_53
tag_53:
%_246 = add i32 1, 0
%_247 = getelementptr i32, i32* %_241, i32 %_246
store i32 20, i32* %_247
%_248 = getelementptr i8, i8* %this, i32 8
%_249 = bitcast i8* %_248 to i32**
%_250 = load i32*, i32** %_249
%_251 = load i32, i32* %_250
%_252 = icmp sge i32 1, 0
%_253 = icmp slt i32 1, %_251
%_254 = and i1 %_252, %_253
br i1 %_254, label %tag_55, label %tag_54
tag_54:
call void @throw_oob()
br label %tag_55
tag_55:
%_255 = add i32 1, 1
%_256 = getelementptr i32, i32* %_250, i32 %_255
store i32 7, i32* %_256
%_257 = getelementptr i8, i8* %this, i32 8
%_258 = bitcast i8* %_257 to i32**
%_259 = load i32*, i32** %_258
%_260 = load i32, i32* %_259
%_261 = icmp sge i32 2, 0
%_262 = icmp slt i32 2, %_260
%_263 = and i1 %_261, %_262
br i1 %_263, label %tag_57, label %tag_56
tag_56:
call void @throw_oob()
br label %tag_57
tag_57:
%_264 = add i32 1, 2
%_265 = getelementptr i32, i32* %_259, i32 %_264
store i32 12, i32* %_265
%_266 = getelementptr i8, i8* %this, i32 8
%_267 = bitcast i8* %_266 to i32**
%_268 = load i32*, i32** %_267
%_269 = load i32, i32* %_268
%_270 = icmp sge i32 3, 0
%_271 = icmp slt i32 3, %_269
%_272 = and i1 %_270, %_271
br i1 %_272, label %tag_59, label %tag_58
tag_58:
call void @throw_oob()
br label %tag_59
tag_59:
%_273 = add i32 1, 3
%_274 = getelementptr i32, i32* %_268, i32 %_273
store i32 18, i32* %_274
%_275 = getelementptr i8, i8* %this, i32 8
%_276 = bitcast i8* %_275 to i32**
%_277 = load i32*, i32** %_276
%_278 = load i32, i32* %_277
%_279 = icmp sge i32 4, 0
%_280 = icmp slt i32 4, %_278
%_281 = and i1 %_279, %_280
br i1 %_281, label %tag_61, label %tag_60
tag_60:
call void @throw_oob()
br label %tag_61
tag_61:
%_282 = add i32 1, 4
%_283 = getelementptr i32, i32* %_277, i32 %_282
store i32 2, i32* %_283
%_284 = getelementptr i8, i8* %this, i32 8
%_285 = bitcast i8* %_284 to i32**
%_286 = load i32*, i32** %_285
%_287 = load i32, i32* %_286
%_288 = icmp sge i32 5, 0
%_289 = icmp slt i32 5, %_287
%_290 = and i1 %_288, %_289
br i1 %_290, label %tag_63, label %tag_62
tag_62:
call void @throw_oob()
br label %tag_63
tag_63:
%_291 = add i32 1, 5
%_292 = getelementptr i32, i32* %_286, i32 %_291
store i32 11, i32* %_292
%_293 = getelementptr i8, i8* %this, i32 8
%_294 = bitcast i8* %_293 to i32**
%_295 = load i32*, i32** %_294
%_296 = load i32, i32* %_295
%_297 = icmp sge i32 6, 0
%_298 = icmp slt i32 6, %_296
%_299 = and i1 %_297, %_298
br i1 %_299, label %tag_65, label %tag_64
tag_64:
call void @throw_oob()
br label %tag_65
tag_65:
%_300 = add i32 1, 6
%_301 = getelementptr i32, i32* %_295, i32 %_300
store i32 6, i32* %_301
%_302 = getelementptr i8, i8* %this, i32 8
%_303 = bitcast i8* %_302 to i32**
%_304 = load i32*, i32** %_303
%_305 = load i32, i32* %_304
%_306 = icmp sge i32 7, 0
%_307 = icmp slt i32 7, %_305
%_308 = and i1 %_306, %_307
br i1 %_308, label %tag_67, label %tag_66
tag_66:
call void @throw_oob()
br label %tag_67
tag_67:
%_309 = add i32 1, 7
%_310 = getelementptr i32, i32* %_304, i32 %_309
store i32 9, i32* %_310
%_311 = getelementptr i8, i8* %this, i32 8
%_312 = bitcast i8* %_311 to i32**
%_313 = load i32*, i32** %_312
%_314 = load i32, i32* %_313
%_315 = icmp sge i32 8, 0
%_316 = icmp slt i32 8, %_314
%_317 = and i1 %_315, %_316
br i1 %_317, label %tag_69, label %tag_68
tag_68:
call void @throw_oob()
br label %tag_69
tag_69:
%_318 = add i32 1, 8
%_319 = getelementptr i32, i32* %_313, i32 %_318
store i32 19, i32* %_319
%_320 = getelementptr i8, i8* %this, i32 8
%_321 = bitcast i8* %_320 to i32**
%_322 = load i32*, i32** %_321
%_323 = load i32, i32* %_322
%_324 = icmp sge i32 9, 0
%_325 = icmp slt i32 9, %_323
%_326 = and i1 %_324, %_325
br i1 %_326, label %tag_71, label %tag_70
tag_70:
call void @throw_oob()
br label %tag_71
tag_71:
%_327 = add i32 1, 9
%_328 = getelementptr i32, i32* %_322, i32 %_327
store i32 5, i32* %_328
ret i32 0
}


