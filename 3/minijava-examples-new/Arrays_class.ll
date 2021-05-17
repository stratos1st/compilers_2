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

@.aa_vtable = global [2 x i8*] [ 
	i8* bitcast (i32 (i8*,i32)* @aa.Start to i8*),
	i8* bitcast (i32 (i8*)* @aa.bbb to i8*)
]

define i32 @main() {
%_0 = call i8* @calloc(i32 1, i32 20)
%_1 = bitcast i8* %_0 to i8***
%_2 = getelementptr [2 x i8*], [2 x i8*]* @.aa_vtable, i32 0, i32 0
store i8** %_2, i8*** %_1
%_3 = bitcast i8* %_0 to i8***
%_4 = load i8**, i8*** %_3
%_5 = getelementptr i8*, i8** %_4, i32 0
%_6 = load i8*, i8** %_5
%_7 = bitcast i8* %_6 to i32 (i8*,i32)*
%_8 = call i32 %_7(i8* %_0, i32 5)
call void (i32) @print_int(i32 %_8)
ret i32 0
}

define i32 @aa.Start(i8* %this, i32 %.sz){
%sz = alloca i32
store i32 %.sz, i32* %sz
%aux01 = alloca i32
store i32 0, i32* %aux01
%_9 = getelementptr i8, i8* %this, i32 16
%_10 = bitcast i8* %_9 to i32*
%_12 = load i32, i32* %sz
%_11 = sub i32 %_12, 1
store i32 %_11, i32* %_10
%_13 = getelementptr i8, i8* %this, i32 8
%_14 = bitcast i8* %_13 to i32**
%_15 = load i32, i32* %sz
%_16 = add i32 1, %_15
%_17 = icmp sge i32 %_16, 1
br i1 %_17, label %tag_1, label %tag_0
tag_0:
call void @throw_nsz()
br label %tag_1
tag_1:
%_18 = call i8* @calloc(i32 %_16, i32 4)
%_19 = bitcast i8* %_18 to i32*
store i32 %_15, i32* %_19
store i32* %_19, i32** %_14
%_20 = getelementptr i8, i8* %this, i32 8
%_21 = bitcast i8* %_20 to i32**
%_22 = load i32*, i32** %_21
%_23 = load i32, i32* %_22
%_24 = icmp sge i32 0, 0
%_25 = icmp slt i32 0, %_23
%_26 = and i1 %_24, %_25
br i1 %_26, label %tag_3, label %tag_2
tag_2:
call void @throw_oob()
br label %tag_3
tag_3:
%_27 = add i32 1, 0
%_28 = getelementptr i32, i32* %_22, i32 %_27
store i32 20, i32* %_28
%_29 = getelementptr i8, i8* %this, i32 8
%_30 = bitcast i8* %_29 to i32**
%_31 = load i32*, i32** %_30
%_32 = load i32, i32* %_31
%_33 = icmp sge i32 0, 0
%_34 = icmp slt i32 0, %_32
%_35 = and i1 %_33, %_34
br i1 %_35, label %tag_5, label %tag_4
tag_4:
call void @throw_oob()
br label %tag_5
tag_5:
%_36 = add i32 1, 0
%_37 = getelementptr i32, i32* %_31, i32 %_36
%_38 = load i32, i32* %_37
%_39 = getelementptr i8, i8* %this, i32 8
%_40 = bitcast i8* %_39 to i32**
%_41 = load i32*, i32** %_40
%_42 = load i32, i32* %_41
%_43 = icmp sge i32 1, 0
%_44 = icmp slt i32 1, %_42
%_45 = and i1 %_43, %_44
br i1 %_45, label %tag_7, label %tag_6
tag_6:
call void @throw_oob()
br label %tag_7
tag_7:
%_46 = add i32 1, 1
%_47 = getelementptr i32, i32* %_41, i32 %_46
store i32 %_38, i32* %_47
%_48 = getelementptr i8, i8* %this, i32 8
%_49 = bitcast i8* %_48 to i32**
%_50 = load i32*, i32** %_49
%_51 = load i32, i32* %_50
%_52 = icmp sge i32 2, 0
%_53 = icmp slt i32 2, %_51
%_54 = and i1 %_52, %_53
br i1 %_54, label %tag_9, label %tag_8
tag_8:
call void @throw_oob()
br label %tag_9
tag_9:
%_55 = add i32 1, 2
%_56 = getelementptr i32, i32* %_50, i32 %_55
store i32 9, i32* %_56
%_58 = getelementptr i8, i8* %this, i32 16
%_59 = bitcast i8* %_58 to i32*
%_60 = load i32, i32* %_59
%_57 = sub i32 %_60, 1
%_61 = getelementptr i8, i8* %this, i32 8
%_62 = bitcast i8* %_61 to i32**
%_63 = load i32*, i32** %_62
%_64 = load i32, i32* %_63
%_65 = icmp sge i32 %_57, 0
%_66 = icmp slt i32 %_57, %_64
%_67 = and i1 %_65, %_66
br i1 %_67, label %tag_11, label %tag_10
tag_10:
call void @throw_oob()
br label %tag_11
tag_11:
%_68 = add i32 1, %_57
%_69 = getelementptr i32, i32* %_63, i32 %_68
store i32 19, i32* %_69
%_70 = getelementptr i8, i8* %this, i32 16
%_71 = bitcast i8* %_70 to i32*
%_72 = load i32, i32* %_71
%_74 = getelementptr i8, i8* %this, i32 16
%_75 = bitcast i8* %_74 to i32*
%_76 = load i32, i32* %_75
%_73 = sub i32 %_76, 1
%_77 = getelementptr i8, i8* %this, i32 8
%_78 = bitcast i8* %_77 to i32**
%_79 = load i32*, i32** %_78
%_80 = load i32, i32* %_79
%_81 = icmp sge i32 %_73, 0
%_82 = icmp slt i32 %_73, %_80
%_83 = and i1 %_81, %_82
br i1 %_83, label %tag_13, label %tag_12
tag_12:
call void @throw_oob()
br label %tag_13
tag_13:
%_84 = add i32 1, %_73
%_85 = getelementptr i32, i32* %_79, i32 %_84
%_86 = load i32, i32* %_85
%_87 = getelementptr i8, i8* %this, i32 8
%_88 = bitcast i8* %_87 to i32**
%_89 = load i32*, i32** %_88
%_90 = load i32, i32* %_89
%_91 = icmp sge i32 %_72, 0
%_92 = icmp slt i32 %_72, %_90
%_93 = and i1 %_91, %_92
br i1 %_93, label %tag_15, label %tag_14
tag_14:
call void @throw_oob()
br label %tag_15
tag_15:
%_94 = add i32 1, %_72
%_95 = getelementptr i32, i32* %_89, i32 %_94
store i32 %_86, i32* %_95
%_96 = getelementptr i8, i8* %this, i32 8
%_97 = bitcast i8* %_96 to i32**
%_98 = load i32*, i32** %_97
%_99 = load i32, i32* %_98
%_100 = icmp sge i32 0, 0
%_101 = icmp slt i32 0, %_99
%_102 = and i1 %_100, %_101
br i1 %_102, label %tag_17, label %tag_16
tag_16:
call void @throw_oob()
br label %tag_17
tag_17:
%_103 = add i32 1, 0
%_104 = getelementptr i32, i32* %_98, i32 %_103
%_105 = load i32, i32* %_104
call void (i32) @print_int(i32 %_105)
%_106 = getelementptr i8, i8* %this, i32 8
%_107 = bitcast i8* %_106 to i32**
%_108 = load i32*, i32** %_107
%_109 = load i32, i32* %_108
%_110 = icmp sge i32 1, 0
%_111 = icmp slt i32 1, %_109
%_112 = and i1 %_110, %_111
br i1 %_112, label %tag_19, label %tag_18
tag_18:
call void @throw_oob()
br label %tag_19
tag_19:
%_113 = add i32 1, 1
%_114 = getelementptr i32, i32* %_108, i32 %_113
%_115 = load i32, i32* %_114
call void (i32) @print_int(i32 %_115)
%_116 = getelementptr i8, i8* %this, i32 8
%_117 = bitcast i8* %_116 to i32**
%_118 = load i32*, i32** %_117
%_119 = load i32, i32* %_118
%_120 = icmp sge i32 2, 0
%_121 = icmp slt i32 2, %_119
%_122 = and i1 %_120, %_121
br i1 %_122, label %tag_21, label %tag_20
tag_20:
call void @throw_oob()
br label %tag_21
tag_21:
%_123 = add i32 1, 2
%_124 = getelementptr i32, i32* %_118, i32 %_123
%_125 = load i32, i32* %_124
call void (i32) @print_int(i32 %_125)
%_126 = getelementptr i8, i8* %this, i32 8
%_127 = bitcast i8* %_126 to i32**
%_128 = load i32*, i32** %_127
%_129 = load i32, i32* %_128
%_130 = icmp sge i32 3, 0
%_131 = icmp slt i32 3, %_129
%_132 = and i1 %_130, %_131
br i1 %_132, label %tag_23, label %tag_22
tag_22:
call void @throw_oob()
br label %tag_23
tag_23:
%_133 = add i32 1, 3
%_134 = getelementptr i32, i32* %_128, i32 %_133
%_135 = load i32, i32* %_134
call void (i32) @print_int(i32 %_135)
%_136 = getelementptr i8, i8* %this, i32 8
%_137 = bitcast i8* %_136 to i32**
%_138 = load i32*, i32** %_137
%_139 = load i32, i32* %_138
%_140 = icmp sge i32 4, 0
%_141 = icmp slt i32 4, %_139
%_142 = and i1 %_140, %_141
br i1 %_142, label %tag_25, label %tag_24
tag_24:
call void @throw_oob()
br label %tag_25
tag_25:
%_143 = add i32 1, 4
%_144 = getelementptr i32, i32* %_138, i32 %_143
%_145 = load i32, i32* %_144
call void (i32) @print_int(i32 %_145)
%_146 = bitcast i8* %this to i8***
%_147 = load i8**, i8*** %_146
%_148 = getelementptr i8*, i8** %_147, i32 1
%_149 = load i8*, i8** %_148
%_150 = bitcast i8* %_149 to i32 (i8*)*
%_151 = call i32 %_150(i8* %this)
store i32 %_151, i32* %aux01
ret i32 0
}

define i32 @aa.bbb(i8* %this){
%_152 = getelementptr i8, i8* %this, i32 8
%_153 = bitcast i8* %_152 to i32**
%_154 = load i32*, i32** %_153
%_155 = load i32, i32* %_154
%_156 = icmp sge i32 0, 0
%_157 = icmp slt i32 0, %_155
%_158 = and i1 %_156, %_157
br i1 %_158, label %tag_27, label %tag_26
tag_26:
call void @throw_oob()
br label %tag_27
tag_27:
%_159 = add i32 1, 0
%_160 = getelementptr i32, i32* %_154, i32 %_159
store i32 201, i32* %_160
%_161 = getelementptr i8, i8* %this, i32 8
%_162 = bitcast i8* %_161 to i32**
%_163 = load i32*, i32** %_162
%_164 = load i32, i32* %_163
%_165 = icmp sge i32 0, 0
%_166 = icmp slt i32 0, %_164
%_167 = and i1 %_165, %_166
br i1 %_167, label %tag_29, label %tag_28
tag_28:
call void @throw_oob()
br label %tag_29
tag_29:
%_168 = add i32 1, 0
%_169 = getelementptr i32, i32* %_163, i32 %_168
%_170 = load i32, i32* %_169
%_171 = getelementptr i8, i8* %this, i32 8
%_172 = bitcast i8* %_171 to i32**
%_173 = load i32*, i32** %_172
%_174 = load i32, i32* %_173
%_175 = icmp sge i32 1, 0
%_176 = icmp slt i32 1, %_174
%_177 = and i1 %_175, %_176
br i1 %_177, label %tag_31, label %tag_30
tag_30:
call void @throw_oob()
br label %tag_31
tag_31:
%_178 = add i32 1, 1
%_179 = getelementptr i32, i32* %_173, i32 %_178
store i32 %_170, i32* %_179
%_181 = getelementptr i8, i8* %this, i32 16
%_182 = bitcast i8* %_181 to i32*
%_183 = load i32, i32* %_182
%_180 = sub i32 %_183, 1
%_184 = getelementptr i8, i8* %this, i32 8
%_185 = bitcast i8* %_184 to i32**
%_186 = load i32*, i32** %_185
%_187 = load i32, i32* %_186
%_188 = icmp sge i32 %_180, 0
%_189 = icmp slt i32 %_180, %_187
%_190 = and i1 %_188, %_189
br i1 %_190, label %tag_33, label %tag_32
tag_32:
call void @throw_oob()
br label %tag_33
tag_33:
%_191 = add i32 1, %_180
%_192 = getelementptr i32, i32* %_186, i32 %_191
store i32 191, i32* %_192
%_193 = getelementptr i8, i8* %this, i32 16
%_194 = bitcast i8* %_193 to i32*
%_195 = load i32, i32* %_194
%_197 = getelementptr i8, i8* %this, i32 16
%_198 = bitcast i8* %_197 to i32*
%_199 = load i32, i32* %_198
%_196 = sub i32 %_199, 1
%_200 = getelementptr i8, i8* %this, i32 8
%_201 = bitcast i8* %_200 to i32**
%_202 = load i32*, i32** %_201
%_203 = load i32, i32* %_202
%_204 = icmp sge i32 %_196, 0
%_205 = icmp slt i32 %_196, %_203
%_206 = and i1 %_204, %_205
br i1 %_206, label %tag_35, label %tag_34
tag_34:
call void @throw_oob()
br label %tag_35
tag_35:
%_207 = add i32 1, %_196
%_208 = getelementptr i32, i32* %_202, i32 %_207
%_209 = load i32, i32* %_208
%_210 = getelementptr i8, i8* %this, i32 8
%_211 = bitcast i8* %_210 to i32**
%_212 = load i32*, i32** %_211
%_213 = load i32, i32* %_212
%_214 = icmp sge i32 %_195, 0
%_215 = icmp slt i32 %_195, %_213
%_216 = and i1 %_214, %_215
br i1 %_216, label %tag_37, label %tag_36
tag_36:
call void @throw_oob()
br label %tag_37
tag_37:
%_217 = add i32 1, %_195
%_218 = getelementptr i32, i32* %_212, i32 %_217
store i32 %_209, i32* %_218
%_219 = getelementptr i8, i8* %this, i32 8
%_220 = bitcast i8* %_219 to i32**
%_221 = load i32*, i32** %_220
%_222 = load i32, i32* %_221
%_223 = icmp sge i32 0, 0
%_224 = icmp slt i32 0, %_222
%_225 = and i1 %_223, %_224
br i1 %_225, label %tag_39, label %tag_38
tag_38:
call void @throw_oob()
br label %tag_39
tag_39:
%_226 = add i32 1, 0
%_227 = getelementptr i32, i32* %_221, i32 %_226
%_228 = load i32, i32* %_227
call void (i32) @print_int(i32 %_228)
%_229 = getelementptr i8, i8* %this, i32 8
%_230 = bitcast i8* %_229 to i32**
%_231 = load i32*, i32** %_230
%_232 = load i32, i32* %_231
%_233 = icmp sge i32 1, 0
%_234 = icmp slt i32 1, %_232
%_235 = and i1 %_233, %_234
br i1 %_235, label %tag_41, label %tag_40
tag_40:
call void @throw_oob()
br label %tag_41
tag_41:
%_236 = add i32 1, 1
%_237 = getelementptr i32, i32* %_231, i32 %_236
%_238 = load i32, i32* %_237
call void (i32) @print_int(i32 %_238)
%_239 = getelementptr i8, i8* %this, i32 8
%_240 = bitcast i8* %_239 to i32**
%_241 = load i32*, i32** %_240
%_242 = load i32, i32* %_241
%_243 = icmp sge i32 3, 0
%_244 = icmp slt i32 3, %_242
%_245 = and i1 %_243, %_244
br i1 %_245, label %tag_43, label %tag_42
tag_42:
call void @throw_oob()
br label %tag_43
tag_43:
%_246 = add i32 1, 3
%_247 = getelementptr i32, i32* %_241, i32 %_246
%_248 = load i32, i32* %_247
call void (i32) @print_int(i32 %_248)
%_249 = getelementptr i8, i8* %this, i32 8
%_250 = bitcast i8* %_249 to i32**
%_251 = load i32*, i32** %_250
%_252 = load i32, i32* %_251
%_253 = icmp sge i32 4, 0
%_254 = icmp slt i32 4, %_252
%_255 = and i1 %_253, %_254
br i1 %_255, label %tag_45, label %tag_44
tag_44:
call void @throw_oob()
br label %tag_45
tag_45:
%_256 = add i32 1, 4
%_257 = getelementptr i32, i32* %_251, i32 %_256
%_258 = load i32, i32* %_257
call void (i32) @print_int(i32 %_258)
ret i32 0
}


