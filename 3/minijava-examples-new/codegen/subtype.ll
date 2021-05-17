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

@.Receiver_vtable = global [8 x i8*] [ 
	i8* bitcast (i1 (i8*,i8*)* @Receiver.A to i8*),
	i8* bitcast (i1 (i8*,i8*)* @Receiver.B to i8*),
	i8* bitcast (i1 (i8*,i8*)* @Receiver.C to i8*),
	i8* bitcast (i1 (i8*,i8*)* @Receiver.D to i8*),
	i8* bitcast (i8* (i8*)* @Receiver.alloc_B_for_A to i8*),
	i8* bitcast (i8* (i8*)* @Receiver.alloc_C_for_A to i8*),
	i8* bitcast (i8* (i8*)* @Receiver.alloc_D_for_A to i8*),
	i8* bitcast (i8* (i8*)* @Receiver.alloc_D_for_B to i8*)
]

@.A_vtable = global [3 x i8*] [ 
	i8* bitcast (i32 (i8*)* @A.foo to i8*),
	i8* bitcast (i32 (i8*)* @A.bar to i8*),
	i8* bitcast (i32 (i8*)* @A.test to i8*)
]

@.B_vtable = global [5 x i8*] [ 
	i8* bitcast (i32 (i8*)* @A.foo to i8*),
	i8* bitcast (i32 (i8*)* @B.bar to i8*),
	i8* bitcast (i32 (i8*)* @A.test to i8*),
	i8* bitcast (i32 (i8*)* @B.not_overriden to i8*),
	i8* bitcast (i32 (i8*)* @B.another to i8*)
]

@.C_vtable = global [3 x i8*] [ 
	i8* bitcast (i32 (i8*)* @A.foo to i8*),
	i8* bitcast (i32 (i8*)* @C.bar to i8*),
	i8* bitcast (i32 (i8*)* @A.test to i8*)
]

@.D_vtable = global [6 x i8*] [ 
	i8* bitcast (i32 (i8*)* @A.foo to i8*),
	i8* bitcast (i32 (i8*)* @D.bar to i8*),
	i8* bitcast (i32 (i8*)* @A.test to i8*),
	i8* bitcast (i32 (i8*)* @B.not_overriden to i8*),
	i8* bitcast (i32 (i8*)* @D.another to i8*),
	i8* bitcast (i32 (i8*)* @D.stef to i8*)
]

define i32 @main() {
%dummy = alloca i1
store i1 0, i1* %dummy
%a = alloca i8*
store i8* null, i8** %a
%b = alloca i8*
store i8* null, i8** %b
%c = alloca i8*
store i8* null, i8** %c
%d = alloca i8*
store i8* null, i8** %d
%separator = alloca i32
store i32 0, i32* %separator
%cls_separator = alloca i32
store i32 0, i32* %cls_separator
store i32 1111111111, i32* %separator
store i32 333333333, i32* %cls_separator
%_0 = call i8* @calloc(i32 1, i32 8)
%_1 = bitcast i8* %_0 to i8***
%_2 = getelementptr [8 x i8*], [8 x i8*]* @.Receiver_vtable, i32 0, i32 0
store i8** %_2, i8*** %_1
%_3 = bitcast i8* %_0 to i8***
%_4 = load i8**, i8*** %_3
%_5 = getelementptr i8*, i8** %_4, i32 0
%_6 = load i8*, i8** %_5
%_7 = bitcast i8* %_6 to i1 (i8*,i8*)*
%_8 = call i8* @calloc(i32 1, i32 8)
%_9 = bitcast i8* %_8 to i8***
%_10 = getelementptr [3 x i8*], [3 x i8*]* @.A_vtable, i32 0, i32 0
store i8** %_10, i8*** %_9
%_11 = call i1 %_7(i8* %_0, i8* %_8)
store i1 %_11, i1* %dummy
%_12 = load i32, i32* %separator
call void (i32) @print_int(i32 %_12)
%_13 = call i8* @calloc(i32 1, i32 8)
%_14 = bitcast i8* %_13 to i8***
%_15 = getelementptr [8 x i8*], [8 x i8*]* @.Receiver_vtable, i32 0, i32 0
store i8** %_15, i8*** %_14
%_16 = bitcast i8* %_13 to i8***
%_17 = load i8**, i8*** %_16
%_18 = getelementptr i8*, i8** %_17, i32 0
%_19 = load i8*, i8** %_18
%_20 = bitcast i8* %_19 to i1 (i8*,i8*)*
%_21 = call i8* @calloc(i32 1, i32 8)
%_22 = bitcast i8* %_21 to i8***
%_23 = getelementptr [8 x i8*], [8 x i8*]* @.Receiver_vtable, i32 0, i32 0
store i8** %_23, i8*** %_22
%_24 = bitcast i8* %_21 to i8***
%_25 = load i8**, i8*** %_24
%_26 = getelementptr i8*, i8** %_25, i32 4
%_27 = load i8*, i8** %_26
%_28 = bitcast i8* %_27 to i8* (i8*)*
%_29 = call i8* %_28(i8* %_21)
%_30 = call i1 %_20(i8* %_13, i8* %_29)
store i1 %_30, i1* %dummy
%_31 = load i32, i32* %separator
call void (i32) @print_int(i32 %_31)
%_32 = call i8* @calloc(i32 1, i32 8)
%_33 = bitcast i8* %_32 to i8***
%_34 = getelementptr [8 x i8*], [8 x i8*]* @.Receiver_vtable, i32 0, i32 0
store i8** %_34, i8*** %_33
%_35 = bitcast i8* %_32 to i8***
%_36 = load i8**, i8*** %_35
%_37 = getelementptr i8*, i8** %_36, i32 0
%_38 = load i8*, i8** %_37
%_39 = bitcast i8* %_38 to i1 (i8*,i8*)*
%_40 = call i8* @calloc(i32 1, i32 8)
%_41 = bitcast i8* %_40 to i8***
%_42 = getelementptr [8 x i8*], [8 x i8*]* @.Receiver_vtable, i32 0, i32 0
store i8** %_42, i8*** %_41
%_43 = bitcast i8* %_40 to i8***
%_44 = load i8**, i8*** %_43
%_45 = getelementptr i8*, i8** %_44, i32 5
%_46 = load i8*, i8** %_45
%_47 = bitcast i8* %_46 to i8* (i8*)*
%_48 = call i8* %_47(i8* %_40)
%_49 = call i1 %_39(i8* %_32, i8* %_48)
store i1 %_49, i1* %dummy
%_50 = load i32, i32* %separator
call void (i32) @print_int(i32 %_50)
%_51 = call i8* @calloc(i32 1, i32 8)
%_52 = bitcast i8* %_51 to i8***
%_53 = getelementptr [8 x i8*], [8 x i8*]* @.Receiver_vtable, i32 0, i32 0
store i8** %_53, i8*** %_52
%_54 = bitcast i8* %_51 to i8***
%_55 = load i8**, i8*** %_54
%_56 = getelementptr i8*, i8** %_55, i32 0
%_57 = load i8*, i8** %_56
%_58 = bitcast i8* %_57 to i1 (i8*,i8*)*
%_59 = call i8* @calloc(i32 1, i32 8)
%_60 = bitcast i8* %_59 to i8***
%_61 = getelementptr [8 x i8*], [8 x i8*]* @.Receiver_vtable, i32 0, i32 0
store i8** %_61, i8*** %_60
%_62 = bitcast i8* %_59 to i8***
%_63 = load i8**, i8*** %_62
%_64 = getelementptr i8*, i8** %_63, i32 6
%_65 = load i8*, i8** %_64
%_66 = bitcast i8* %_65 to i8* (i8*)*
%_67 = call i8* %_66(i8* %_59)
%_68 = call i1 %_58(i8* %_51, i8* %_67)
store i1 %_68, i1* %dummy
%_69 = load i32, i32* %cls_separator
call void (i32) @print_int(i32 %_69)
%_70 = call i8* @calloc(i32 1, i32 8)
%_71 = bitcast i8* %_70 to i8***
%_72 = getelementptr [8 x i8*], [8 x i8*]* @.Receiver_vtable, i32 0, i32 0
store i8** %_72, i8*** %_71
%_73 = bitcast i8* %_70 to i8***
%_74 = load i8**, i8*** %_73
%_75 = getelementptr i8*, i8** %_74, i32 1
%_76 = load i8*, i8** %_75
%_77 = bitcast i8* %_76 to i1 (i8*,i8*)*
%_78 = call i8* @calloc(i32 1, i32 8)
%_79 = bitcast i8* %_78 to i8***
%_80 = getelementptr [5 x i8*], [5 x i8*]* @.B_vtable, i32 0, i32 0
store i8** %_80, i8*** %_79
%_81 = call i1 %_77(i8* %_70, i8* %_78)
store i1 %_81, i1* %dummy
%_82 = load i32, i32* %separator
call void (i32) @print_int(i32 %_82)
%_83 = call i8* @calloc(i32 1, i32 8)
%_84 = bitcast i8* %_83 to i8***
%_85 = getelementptr [8 x i8*], [8 x i8*]* @.Receiver_vtable, i32 0, i32 0
store i8** %_85, i8*** %_84
%_86 = bitcast i8* %_83 to i8***
%_87 = load i8**, i8*** %_86
%_88 = getelementptr i8*, i8** %_87, i32 1
%_89 = load i8*, i8** %_88
%_90 = bitcast i8* %_89 to i1 (i8*,i8*)*
%_91 = call i8* @calloc(i32 1, i32 8)
%_92 = bitcast i8* %_91 to i8***
%_93 = getelementptr [8 x i8*], [8 x i8*]* @.Receiver_vtable, i32 0, i32 0
store i8** %_93, i8*** %_92
%_94 = bitcast i8* %_91 to i8***
%_95 = load i8**, i8*** %_94
%_96 = getelementptr i8*, i8** %_95, i32 7
%_97 = load i8*, i8** %_96
%_98 = bitcast i8* %_97 to i8* (i8*)*
%_99 = call i8* %_98(i8* %_91)
%_100 = call i1 %_90(i8* %_83, i8* %_99)
store i1 %_100, i1* %dummy
%_101 = load i32, i32* %cls_separator
call void (i32) @print_int(i32 %_101)
%_102 = call i8* @calloc(i32 1, i32 8)
%_103 = bitcast i8* %_102 to i8***
%_104 = getelementptr [8 x i8*], [8 x i8*]* @.Receiver_vtable, i32 0, i32 0
store i8** %_104, i8*** %_103
%_105 = bitcast i8* %_102 to i8***
%_106 = load i8**, i8*** %_105
%_107 = getelementptr i8*, i8** %_106, i32 2
%_108 = load i8*, i8** %_107
%_109 = bitcast i8* %_108 to i1 (i8*,i8*)*
%_110 = call i8* @calloc(i32 1, i32 8)
%_111 = bitcast i8* %_110 to i8***
%_112 = getelementptr [3 x i8*], [3 x i8*]* @.C_vtable, i32 0, i32 0
store i8** %_112, i8*** %_111
%_113 = call i1 %_109(i8* %_102, i8* %_110)
store i1 %_113, i1* %dummy
%_114 = load i32, i32* %cls_separator
call void (i32) @print_int(i32 %_114)
%_115 = call i8* @calloc(i32 1, i32 8)
%_116 = bitcast i8* %_115 to i8***
%_117 = getelementptr [8 x i8*], [8 x i8*]* @.Receiver_vtable, i32 0, i32 0
store i8** %_117, i8*** %_116
%_118 = bitcast i8* %_115 to i8***
%_119 = load i8**, i8*** %_118
%_120 = getelementptr i8*, i8** %_119, i32 3
%_121 = load i8*, i8** %_120
%_122 = bitcast i8* %_121 to i1 (i8*,i8*)*
%_123 = call i8* @calloc(i32 1, i32 8)
%_124 = bitcast i8* %_123 to i8***
%_125 = getelementptr [6 x i8*], [6 x i8*]* @.D_vtable, i32 0, i32 0
store i8** %_125, i8*** %_124
%_126 = call i1 %_122(i8* %_115, i8* %_123)
store i1 %_126, i1* %dummy
ret i32 0
}

define i1 @Receiver.A(i8* %this, i8* %.a){
%a = alloca i8*
store i8* %.a, i8** %a
%_127 = load i8*, i8** %a
%_128 = bitcast i8* %_127 to i8***
%_129 = load i8**, i8*** %_128
%_130 = getelementptr i8*, i8** %_129, i32 0
%_131 = load i8*, i8** %_130
%_132 = bitcast i8* %_131 to i32 (i8*)*
%_133 = call i32 %_132(i8* %_127)
call void (i32) @print_int(i32 %_133)
%_134 = load i8*, i8** %a
%_135 = bitcast i8* %_134 to i8***
%_136 = load i8**, i8*** %_135
%_137 = getelementptr i8*, i8** %_136, i32 1
%_138 = load i8*, i8** %_137
%_139 = bitcast i8* %_138 to i32 (i8*)*
%_140 = call i32 %_139(i8* %_134)
call void (i32) @print_int(i32 %_140)
%_141 = load i8*, i8** %a
%_142 = bitcast i8* %_141 to i8***
%_143 = load i8**, i8*** %_142
%_144 = getelementptr i8*, i8** %_143, i32 2
%_145 = load i8*, i8** %_144
%_146 = bitcast i8* %_145 to i32 (i8*)*
%_147 = call i32 %_146(i8* %_141)
call void (i32) @print_int(i32 %_147)
ret i1 1
}

define i1 @Receiver.B(i8* %this, i8* %.b){
%b = alloca i8*
store i8* %.b, i8** %b
%_148 = load i8*, i8** %b
%_149 = bitcast i8* %_148 to i8***
%_150 = load i8**, i8*** %_149
%_151 = getelementptr i8*, i8** %_150, i32 0
%_152 = load i8*, i8** %_151
%_153 = bitcast i8* %_152 to i32 (i8*)*
%_154 = call i32 %_153(i8* %_148)
call void (i32) @print_int(i32 %_154)
%_155 = load i8*, i8** %b
%_156 = bitcast i8* %_155 to i8***
%_157 = load i8**, i8*** %_156
%_158 = getelementptr i8*, i8** %_157, i32 1
%_159 = load i8*, i8** %_158
%_160 = bitcast i8* %_159 to i32 (i8*)*
%_161 = call i32 %_160(i8* %_155)
call void (i32) @print_int(i32 %_161)
%_162 = load i8*, i8** %b
%_163 = bitcast i8* %_162 to i8***
%_164 = load i8**, i8*** %_163
%_165 = getelementptr i8*, i8** %_164, i32 2
%_166 = load i8*, i8** %_165
%_167 = bitcast i8* %_166 to i32 (i8*)*
%_168 = call i32 %_167(i8* %_162)
call void (i32) @print_int(i32 %_168)
%_169 = load i8*, i8** %b
%_170 = bitcast i8* %_169 to i8***
%_171 = load i8**, i8*** %_170
%_172 = getelementptr i8*, i8** %_171, i32 3
%_173 = load i8*, i8** %_172
%_174 = bitcast i8* %_173 to i32 (i8*)*
%_175 = call i32 %_174(i8* %_169)
call void (i32) @print_int(i32 %_175)
%_176 = load i8*, i8** %b
%_177 = bitcast i8* %_176 to i8***
%_178 = load i8**, i8*** %_177
%_179 = getelementptr i8*, i8** %_178, i32 4
%_180 = load i8*, i8** %_179
%_181 = bitcast i8* %_180 to i32 (i8*)*
%_182 = call i32 %_181(i8* %_176)
call void (i32) @print_int(i32 %_182)
ret i1 1
}

define i1 @Receiver.C(i8* %this, i8* %.c){
%c = alloca i8*
store i8* %.c, i8** %c
%_183 = load i8*, i8** %c
%_184 = bitcast i8* %_183 to i8***
%_185 = load i8**, i8*** %_184
%_186 = getelementptr i8*, i8** %_185, i32 0
%_187 = load i8*, i8** %_186
%_188 = bitcast i8* %_187 to i32 (i8*)*
%_189 = call i32 %_188(i8* %_183)
call void (i32) @print_int(i32 %_189)
%_190 = load i8*, i8** %c
%_191 = bitcast i8* %_190 to i8***
%_192 = load i8**, i8*** %_191
%_193 = getelementptr i8*, i8** %_192, i32 1
%_194 = load i8*, i8** %_193
%_195 = bitcast i8* %_194 to i32 (i8*)*
%_196 = call i32 %_195(i8* %_190)
call void (i32) @print_int(i32 %_196)
%_197 = load i8*, i8** %c
%_198 = bitcast i8* %_197 to i8***
%_199 = load i8**, i8*** %_198
%_200 = getelementptr i8*, i8** %_199, i32 2
%_201 = load i8*, i8** %_200
%_202 = bitcast i8* %_201 to i32 (i8*)*
%_203 = call i32 %_202(i8* %_197)
call void (i32) @print_int(i32 %_203)
ret i1 1
}

define i1 @Receiver.D(i8* %this, i8* %.d){
%d = alloca i8*
store i8* %.d, i8** %d
%_204 = load i8*, i8** %d
%_205 = bitcast i8* %_204 to i8***
%_206 = load i8**, i8*** %_205
%_207 = getelementptr i8*, i8** %_206, i32 0
%_208 = load i8*, i8** %_207
%_209 = bitcast i8* %_208 to i32 (i8*)*
%_210 = call i32 %_209(i8* %_204)
call void (i32) @print_int(i32 %_210)
%_211 = load i8*, i8** %d
%_212 = bitcast i8* %_211 to i8***
%_213 = load i8**, i8*** %_212
%_214 = getelementptr i8*, i8** %_213, i32 1
%_215 = load i8*, i8** %_214
%_216 = bitcast i8* %_215 to i32 (i8*)*
%_217 = call i32 %_216(i8* %_211)
call void (i32) @print_int(i32 %_217)
%_218 = load i8*, i8** %d
%_219 = bitcast i8* %_218 to i8***
%_220 = load i8**, i8*** %_219
%_221 = getelementptr i8*, i8** %_220, i32 2
%_222 = load i8*, i8** %_221
%_223 = bitcast i8* %_222 to i32 (i8*)*
%_224 = call i32 %_223(i8* %_218)
call void (i32) @print_int(i32 %_224)
%_225 = load i8*, i8** %d
%_226 = bitcast i8* %_225 to i8***
%_227 = load i8**, i8*** %_226
%_228 = getelementptr i8*, i8** %_227, i32 3
%_229 = load i8*, i8** %_228
%_230 = bitcast i8* %_229 to i32 (i8*)*
%_231 = call i32 %_230(i8* %_225)
call void (i32) @print_int(i32 %_231)
%_232 = load i8*, i8** %d
%_233 = bitcast i8* %_232 to i8***
%_234 = load i8**, i8*** %_233
%_235 = getelementptr i8*, i8** %_234, i32 4
%_236 = load i8*, i8** %_235
%_237 = bitcast i8* %_236 to i32 (i8*)*
%_238 = call i32 %_237(i8* %_232)
call void (i32) @print_int(i32 %_238)
%_239 = load i8*, i8** %d
%_240 = bitcast i8* %_239 to i8***
%_241 = load i8**, i8*** %_240
%_242 = getelementptr i8*, i8** %_241, i32 5
%_243 = load i8*, i8** %_242
%_244 = bitcast i8* %_243 to i32 (i8*)*
%_245 = call i32 %_244(i8* %_239)
call void (i32) @print_int(i32 %_245)
ret i1 1
}

define i8* @Receiver.alloc_B_for_A(i8* %this){
%_246 = call i8* @calloc(i32 1, i32 8)
%_247 = bitcast i8* %_246 to i8***
%_248 = getelementptr [5 x i8*], [5 x i8*]* @.B_vtable, i32 0, i32 0
store i8** %_248, i8*** %_247
ret i8* %_246
}

define i8* @Receiver.alloc_C_for_A(i8* %this){
%_249 = call i8* @calloc(i32 1, i32 8)
%_250 = bitcast i8* %_249 to i8***
%_251 = getelementptr [3 x i8*], [3 x i8*]* @.C_vtable, i32 0, i32 0
store i8** %_251, i8*** %_250
ret i8* %_249
}

define i8* @Receiver.alloc_D_for_A(i8* %this){
%_252 = call i8* @calloc(i32 1, i32 8)
%_253 = bitcast i8* %_252 to i8***
%_254 = getelementptr [6 x i8*], [6 x i8*]* @.D_vtable, i32 0, i32 0
store i8** %_254, i8*** %_253
ret i8* %_252
}

define i8* @Receiver.alloc_D_for_B(i8* %this){
%_255 = call i8* @calloc(i32 1, i32 8)
%_256 = bitcast i8* %_255 to i8***
%_257 = getelementptr [6 x i8*], [6 x i8*]* @.D_vtable, i32 0, i32 0
store i8** %_257, i8*** %_256
ret i8* %_255
}

define i32 @A.foo(i8* %this){
ret i32 1
}

define i32 @A.bar(i8* %this){
ret i32 2
}

define i32 @A.test(i8* %this){
ret i32 3
}

define i32 @B.bar(i8* %this){
ret i32 12
}

define i32 @B.not_overriden(i8* %this){
ret i32 14
}

define i32 @B.another(i8* %this){
ret i32 15
}

define i32 @C.bar(i8* %this){
ret i32 22
}

define i32 @D.bar(i8* %this){
ret i32 32
}

define i32 @D.another(i8* %this){
ret i32 35
}

define i32 @D.stef(i8* %this){
ret i32 36
}


