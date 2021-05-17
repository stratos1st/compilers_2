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

@.BT_vtable = global [1 x i8*] [ 
	i8* bitcast (i32 (i8*)* @BT.Start to i8*)
]

@.Tree_vtable = global [20 x i8*] [ 
	i8* bitcast (i1 (i8*,i32)* @Tree.Init to i8*),
	i8* bitcast (i1 (i8*,i8*)* @Tree.SetRight to i8*),
	i8* bitcast (i1 (i8*,i8*)* @Tree.SetLeft to i8*),
	i8* bitcast (i8* (i8*)* @Tree.GetRight to i8*),
	i8* bitcast (i8* (i8*)* @Tree.GetLeft to i8*),
	i8* bitcast (i32 (i8*)* @Tree.GetKey to i8*),
	i8* bitcast (i1 (i8*,i32)* @Tree.SetKey to i8*),
	i8* bitcast (i1 (i8*)* @Tree.GetHas_Right to i8*),
	i8* bitcast (i1 (i8*)* @Tree.GetHas_Left to i8*),
	i8* bitcast (i1 (i8*,i1)* @Tree.SetHas_Left to i8*),
	i8* bitcast (i1 (i8*,i1)* @Tree.SetHas_Right to i8*),
	i8* bitcast (i1 (i8*,i32,i32)* @Tree.Compare to i8*),
	i8* bitcast (i1 (i8*,i32)* @Tree.Insert to i8*),
	i8* bitcast (i1 (i8*,i32)* @Tree.Delete to i8*),
	i8* bitcast (i1 (i8*,i8*,i8*)* @Tree.Remove to i8*),
	i8* bitcast (i1 (i8*,i8*,i8*)* @Tree.RemoveRight to i8*),
	i8* bitcast (i1 (i8*,i8*,i8*)* @Tree.RemoveLeft to i8*),
	i8* bitcast (i32 (i8*,i32)* @Tree.Search to i8*),
	i8* bitcast (i1 (i8*)* @Tree.Print to i8*),
	i8* bitcast (i1 (i8*,i8*)* @Tree.RecPrint to i8*)
]

define i32 @main() {
%_0 = call i8* @calloc(i32 1, i32 8)
%_1 = bitcast i8* %_0 to i8***
%_2 = getelementptr [1 x i8*], [1 x i8*]* @.BT_vtable, i32 0, i32 0
store i8** %_2, i8*** %_1
%_3 = bitcast i8* %_0 to i8***
%_4 = load i8**, i8*** %_3
%_5 = getelementptr i8*, i8** %_4, i32 0
%_6 = load i8*, i8** %_5
%_7 = bitcast i8* %_6 to i32 (i8*)*
%_8 = call i32 %_7(i8* %_0)
call void (i32) @print_int(i32 %_8)
ret i32 0
}

define i32 @BT.Start(i8* %this){
%root = alloca i8*
store i8* null, i8** %root
%ntb = alloca i1
store i1 0, i1* %ntb
%nti = alloca i32
store i32 0, i32* %nti
%_9 = call i8* @calloc(i32 1, i32 38)
%_10 = bitcast i8* %_9 to i8***
%_11 = getelementptr [20 x i8*], [20 x i8*]* @.Tree_vtable, i32 0, i32 0
store i8** %_11, i8*** %_10
store i8* %_9, i8** %root
%_12 = load i8*, i8** %root
%_13 = bitcast i8* %_12 to i8***
%_14 = load i8**, i8*** %_13
%_15 = getelementptr i8*, i8** %_14, i32 0
%_16 = load i8*, i8** %_15
%_17 = bitcast i8* %_16 to i1 (i8*,i32)*
%_18 = call i1 %_17(i8* %_12, i32 16)
store i1 %_18, i1* %ntb
%_19 = load i8*, i8** %root
%_20 = bitcast i8* %_19 to i8***
%_21 = load i8**, i8*** %_20
%_22 = getelementptr i8*, i8** %_21, i32 18
%_23 = load i8*, i8** %_22
%_24 = bitcast i8* %_23 to i1 (i8*)*
%_25 = call i1 %_24(i8* %_19)
store i1 %_25, i1* %ntb
call void (i32) @print_int(i32 100000000)
%_26 = load i8*, i8** %root
%_27 = bitcast i8* %_26 to i8***
%_28 = load i8**, i8*** %_27
%_29 = getelementptr i8*, i8** %_28, i32 12
%_30 = load i8*, i8** %_29
%_31 = bitcast i8* %_30 to i1 (i8*,i32)*
%_32 = call i1 %_31(i8* %_26, i32 8)
store i1 %_32, i1* %ntb
%_33 = load i8*, i8** %root
%_34 = bitcast i8* %_33 to i8***
%_35 = load i8**, i8*** %_34
%_36 = getelementptr i8*, i8** %_35, i32 18
%_37 = load i8*, i8** %_36
%_38 = bitcast i8* %_37 to i1 (i8*)*
%_39 = call i1 %_38(i8* %_33)
store i1 %_39, i1* %ntb
%_40 = load i8*, i8** %root
%_41 = bitcast i8* %_40 to i8***
%_42 = load i8**, i8*** %_41
%_43 = getelementptr i8*, i8** %_42, i32 12
%_44 = load i8*, i8** %_43
%_45 = bitcast i8* %_44 to i1 (i8*,i32)*
%_46 = call i1 %_45(i8* %_40, i32 24)
store i1 %_46, i1* %ntb
%_47 = load i8*, i8** %root
%_48 = bitcast i8* %_47 to i8***
%_49 = load i8**, i8*** %_48
%_50 = getelementptr i8*, i8** %_49, i32 12
%_51 = load i8*, i8** %_50
%_52 = bitcast i8* %_51 to i1 (i8*,i32)*
%_53 = call i1 %_52(i8* %_47, i32 4)
store i1 %_53, i1* %ntb
%_54 = load i8*, i8** %root
%_55 = bitcast i8* %_54 to i8***
%_56 = load i8**, i8*** %_55
%_57 = getelementptr i8*, i8** %_56, i32 12
%_58 = load i8*, i8** %_57
%_59 = bitcast i8* %_58 to i1 (i8*,i32)*
%_60 = call i1 %_59(i8* %_54, i32 12)
store i1 %_60, i1* %ntb
%_61 = load i8*, i8** %root
%_62 = bitcast i8* %_61 to i8***
%_63 = load i8**, i8*** %_62
%_64 = getelementptr i8*, i8** %_63, i32 12
%_65 = load i8*, i8** %_64
%_66 = bitcast i8* %_65 to i1 (i8*,i32)*
%_67 = call i1 %_66(i8* %_61, i32 20)
store i1 %_67, i1* %ntb
%_68 = load i8*, i8** %root
%_69 = bitcast i8* %_68 to i8***
%_70 = load i8**, i8*** %_69
%_71 = getelementptr i8*, i8** %_70, i32 12
%_72 = load i8*, i8** %_71
%_73 = bitcast i8* %_72 to i1 (i8*,i32)*
%_74 = call i1 %_73(i8* %_68, i32 28)
store i1 %_74, i1* %ntb
%_75 = load i8*, i8** %root
%_76 = bitcast i8* %_75 to i8***
%_77 = load i8**, i8*** %_76
%_78 = getelementptr i8*, i8** %_77, i32 12
%_79 = load i8*, i8** %_78
%_80 = bitcast i8* %_79 to i1 (i8*,i32)*
%_81 = call i1 %_80(i8* %_75, i32 14)
store i1 %_81, i1* %ntb
%_82 = load i8*, i8** %root
%_83 = bitcast i8* %_82 to i8***
%_84 = load i8**, i8*** %_83
%_85 = getelementptr i8*, i8** %_84, i32 18
%_86 = load i8*, i8** %_85
%_87 = bitcast i8* %_86 to i1 (i8*)*
%_88 = call i1 %_87(i8* %_82)
store i1 %_88, i1* %ntb
%_89 = load i8*, i8** %root
%_90 = bitcast i8* %_89 to i8***
%_91 = load i8**, i8*** %_90
%_92 = getelementptr i8*, i8** %_91, i32 17
%_93 = load i8*, i8** %_92
%_94 = bitcast i8* %_93 to i32 (i8*,i32)*
%_95 = call i32 %_94(i8* %_89, i32 24)
call void (i32) @print_int(i32 %_95)
%_96 = load i8*, i8** %root
%_97 = bitcast i8* %_96 to i8***
%_98 = load i8**, i8*** %_97
%_99 = getelementptr i8*, i8** %_98, i32 17
%_100 = load i8*, i8** %_99
%_101 = bitcast i8* %_100 to i32 (i8*,i32)*
%_102 = call i32 %_101(i8* %_96, i32 12)
call void (i32) @print_int(i32 %_102)
%_103 = load i8*, i8** %root
%_104 = bitcast i8* %_103 to i8***
%_105 = load i8**, i8*** %_104
%_106 = getelementptr i8*, i8** %_105, i32 17
%_107 = load i8*, i8** %_106
%_108 = bitcast i8* %_107 to i32 (i8*,i32)*
%_109 = call i32 %_108(i8* %_103, i32 16)
call void (i32) @print_int(i32 %_109)
%_110 = load i8*, i8** %root
%_111 = bitcast i8* %_110 to i8***
%_112 = load i8**, i8*** %_111
%_113 = getelementptr i8*, i8** %_112, i32 17
%_114 = load i8*, i8** %_113
%_115 = bitcast i8* %_114 to i32 (i8*,i32)*
%_116 = call i32 %_115(i8* %_110, i32 50)
call void (i32) @print_int(i32 %_116)
%_117 = load i8*, i8** %root
%_118 = bitcast i8* %_117 to i8***
%_119 = load i8**, i8*** %_118
%_120 = getelementptr i8*, i8** %_119, i32 17
%_121 = load i8*, i8** %_120
%_122 = bitcast i8* %_121 to i32 (i8*,i32)*
%_123 = call i32 %_122(i8* %_117, i32 12)
call void (i32) @print_int(i32 %_123)
%_124 = load i8*, i8** %root
%_125 = bitcast i8* %_124 to i8***
%_126 = load i8**, i8*** %_125
%_127 = getelementptr i8*, i8** %_126, i32 13
%_128 = load i8*, i8** %_127
%_129 = bitcast i8* %_128 to i1 (i8*,i32)*
%_130 = call i1 %_129(i8* %_124, i32 12)
store i1 %_130, i1* %ntb
%_131 = load i8*, i8** %root
%_132 = bitcast i8* %_131 to i8***
%_133 = load i8**, i8*** %_132
%_134 = getelementptr i8*, i8** %_133, i32 18
%_135 = load i8*, i8** %_134
%_136 = bitcast i8* %_135 to i1 (i8*)*
%_137 = call i1 %_136(i8* %_131)
store i1 %_137, i1* %ntb
%_138 = load i8*, i8** %root
%_139 = bitcast i8* %_138 to i8***
%_140 = load i8**, i8*** %_139
%_141 = getelementptr i8*, i8** %_140, i32 17
%_142 = load i8*, i8** %_141
%_143 = bitcast i8* %_142 to i32 (i8*,i32)*
%_144 = call i32 %_143(i8* %_138, i32 12)
call void (i32) @print_int(i32 %_144)
ret i32 0
}

define i1 @Tree.Init(i8* %this, i32 %.v_key){
%v_key = alloca i32
store i32 %.v_key, i32* %v_key
%_145 = getelementptr i8, i8* %this, i32 24
%_146 = bitcast i8* %_145 to i32*
%_147 = load i32, i32* %v_key
store i32 %_147, i32* %_146
%_148 = getelementptr i8, i8* %this, i32 28
%_149 = bitcast i8* %_148 to i1*
store i1 0, i1* %_149
%_150 = getelementptr i8, i8* %this, i32 29
%_151 = bitcast i8* %_150 to i1*
store i1 0, i1* %_151
ret i1 1
}

define i1 @Tree.SetRight(i8* %this, i8* %.rn){
%rn = alloca i8*
store i8* %.rn, i8** %rn
%_152 = getelementptr i8, i8* %this, i32 16
%_153 = bitcast i8* %_152 to i8**
%_154 = load i8*, i8** %rn
store i8* %_154, i8** %_153
ret i1 1
}

define i1 @Tree.SetLeft(i8* %this, i8* %.ln){
%ln = alloca i8*
store i8* %.ln, i8** %ln
%_155 = getelementptr i8, i8* %this, i32 8
%_156 = bitcast i8* %_155 to i8**
%_157 = load i8*, i8** %ln
store i8* %_157, i8** %_156
ret i1 1
}

define i8* @Tree.GetRight(i8* %this){
%_158 = getelementptr i8, i8* %this, i32 16
%_159 = bitcast i8* %_158 to i8**
%_160 = load i8*, i8** %_159
ret i8* %_160
}

define i8* @Tree.GetLeft(i8* %this){
%_161 = getelementptr i8, i8* %this, i32 8
%_162 = bitcast i8* %_161 to i8**
%_163 = load i8*, i8** %_162
ret i8* %_163
}

define i32 @Tree.GetKey(i8* %this){
%_164 = getelementptr i8, i8* %this, i32 24
%_165 = bitcast i8* %_164 to i32*
%_166 = load i32, i32* %_165
ret i32 %_166
}

define i1 @Tree.SetKey(i8* %this, i32 %.v_key){
%v_key = alloca i32
store i32 %.v_key, i32* %v_key
%_167 = getelementptr i8, i8* %this, i32 24
%_168 = bitcast i8* %_167 to i32*
%_169 = load i32, i32* %v_key
store i32 %_169, i32* %_168
ret i1 1
}

define i1 @Tree.GetHas_Right(i8* %this){
%_170 = getelementptr i8, i8* %this, i32 29
%_171 = bitcast i8* %_170 to i1*
%_172 = load i1, i1* %_171
ret i1 %_172
}

define i1 @Tree.GetHas_Left(i8* %this){
%_173 = getelementptr i8, i8* %this, i32 28
%_174 = bitcast i8* %_173 to i1*
%_175 = load i1, i1* %_174
ret i1 %_175
}

define i1 @Tree.SetHas_Left(i8* %this, i1 %.val){
%val = alloca i1
store i1 %.val, i1* %val
%_176 = getelementptr i8, i8* %this, i32 28
%_177 = bitcast i8* %_176 to i1*
%_178 = load i1, i1* %val
store i1 %_178, i1* %_177
ret i1 1
}

define i1 @Tree.SetHas_Right(i8* %this, i1 %.val){
%val = alloca i1
store i1 %.val, i1* %val
%_179 = getelementptr i8, i8* %this, i32 29
%_180 = bitcast i8* %_179 to i1*
%_181 = load i1, i1* %val
store i1 %_181, i1* %_180
ret i1 1
}

define i1 @Tree.Compare(i8* %this, i32 %.num1, i32 %.num2){
%num1 = alloca i32
store i32 %.num1, i32* %num1
%num2 = alloca i32
store i32 %.num2, i32* %num2
%ntb = alloca i1
store i1 0, i1* %ntb
%nti = alloca i32
store i32 0, i32* %nti
store i1 0, i1* %ntb
%_183 = load i32, i32* %num2
%_182 = add i32 %_183, 1
store i32 %_182, i32* %nti
%_184 = load i32, i32* %num1
%_185 = load i32, i32* %num2
%_186 = icmp slt i32 %_184, %_185
;IfStatement
br i1 %_186, label %tag_0, label %tag_1
tag_0:
store i1 0, i1* %ntb
br label %tag_2
tag_1:
%_187 = load i32, i32* %num1
%_188 = load i32, i32* %nti
%_189 = icmp slt i32 %_187, %_188
%_190 = xor i1 1, %_189
;IfStatement
br i1 %_190, label %tag_3, label %tag_4
tag_3:
store i1 0, i1* %ntb
br label %tag_5
tag_4:
store i1 1, i1* %ntb
br label %tag_5
tag_5:
br label %tag_2
tag_2:
%_191 = load i1, i1* %ntb
ret i1 %_191
}

define i1 @Tree.Insert(i8* %this, i32 %.v_key){
%v_key = alloca i32
store i32 %.v_key, i32* %v_key
%new_node = alloca i8*
store i8* null, i8** %new_node
%ntb = alloca i1
store i1 0, i1* %ntb
%cont = alloca i1
store i1 0, i1* %cont
%key_aux = alloca i32
store i32 0, i32* %key_aux
%current_node = alloca i8*
store i8* null, i8** %current_node
%_192 = call i8* @calloc(i32 1, i32 38)
%_193 = bitcast i8* %_192 to i8***
%_194 = getelementptr [20 x i8*], [20 x i8*]* @.Tree_vtable, i32 0, i32 0
store i8** %_194, i8*** %_193
store i8* %_192, i8** %new_node
%_195 = load i8*, i8** %new_node
%_196 = bitcast i8* %_195 to i8***
%_197 = load i8**, i8*** %_196
%_198 = getelementptr i8*, i8** %_197, i32 0
%_199 = load i8*, i8** %_198
%_200 = bitcast i8* %_199 to i1 (i8*,i32)*
%_201 = load i32, i32* %v_key
%_202 = call i1 %_200(i8* %_195, i32 %_201)
store i1 %_202, i1* %ntb
store i8* %this, i8** %current_node
store i1 1, i1* %cont
;WhileStatement
br label %tag_6
tag_6:
%_203 = load i1, i1* %cont
br i1 %_203, label %tag_7, label %tag_8
tag_7:
%_204 = load i8*, i8** %current_node
%_205 = bitcast i8* %_204 to i8***
%_206 = load i8**, i8*** %_205
%_207 = getelementptr i8*, i8** %_206, i32 5
%_208 = load i8*, i8** %_207
%_209 = bitcast i8* %_208 to i32 (i8*)*
%_210 = call i32 %_209(i8* %_204)
store i32 %_210, i32* %key_aux
%_211 = load i32, i32* %v_key
%_212 = load i32, i32* %key_aux
%_213 = icmp slt i32 %_211, %_212
;IfStatement
br i1 %_213, label %tag_9, label %tag_10
tag_9:
%_214 = load i8*, i8** %current_node
%_215 = bitcast i8* %_214 to i8***
%_216 = load i8**, i8*** %_215
%_217 = getelementptr i8*, i8** %_216, i32 8
%_218 = load i8*, i8** %_217
%_219 = bitcast i8* %_218 to i1 (i8*)*
%_220 = call i1 %_219(i8* %_214)
;IfStatement
br i1 %_220, label %tag_12, label %tag_13
tag_12:
%_221 = load i8*, i8** %current_node
%_222 = bitcast i8* %_221 to i8***
%_223 = load i8**, i8*** %_222
%_224 = getelementptr i8*, i8** %_223, i32 4
%_225 = load i8*, i8** %_224
%_226 = bitcast i8* %_225 to i8* (i8*)*
%_227 = call i8* %_226(i8* %_221)
store i8* %_227, i8** %current_node
br label %tag_14
tag_13:
store i1 0, i1* %cont
%_228 = load i8*, i8** %current_node
%_229 = bitcast i8* %_228 to i8***
%_230 = load i8**, i8*** %_229
%_231 = getelementptr i8*, i8** %_230, i32 9
%_232 = load i8*, i8** %_231
%_233 = bitcast i8* %_232 to i1 (i8*,i1)*
%_234 = call i1 %_233(i8* %_228, i1 1)
store i1 %_234, i1* %ntb
%_235 = load i8*, i8** %current_node
%_236 = bitcast i8* %_235 to i8***
%_237 = load i8**, i8*** %_236
%_238 = getelementptr i8*, i8** %_237, i32 2
%_239 = load i8*, i8** %_238
%_240 = bitcast i8* %_239 to i1 (i8*,i8*)*
%_241 = load i8*, i8** %new_node
%_242 = call i1 %_240(i8* %_235, i8* %_241)
store i1 %_242, i1* %ntb
br label %tag_14
tag_14:
br label %tag_11
tag_10:
%_243 = load i8*, i8** %current_node
%_244 = bitcast i8* %_243 to i8***
%_245 = load i8**, i8*** %_244
%_246 = getelementptr i8*, i8** %_245, i32 7
%_247 = load i8*, i8** %_246
%_248 = bitcast i8* %_247 to i1 (i8*)*
%_249 = call i1 %_248(i8* %_243)
;IfStatement
br i1 %_249, label %tag_15, label %tag_16
tag_15:
%_250 = load i8*, i8** %current_node
%_251 = bitcast i8* %_250 to i8***
%_252 = load i8**, i8*** %_251
%_253 = getelementptr i8*, i8** %_252, i32 3
%_254 = load i8*, i8** %_253
%_255 = bitcast i8* %_254 to i8* (i8*)*
%_256 = call i8* %_255(i8* %_250)
store i8* %_256, i8** %current_node
br label %tag_17
tag_16:
store i1 0, i1* %cont
%_257 = load i8*, i8** %current_node
%_258 = bitcast i8* %_257 to i8***
%_259 = load i8**, i8*** %_258
%_260 = getelementptr i8*, i8** %_259, i32 10
%_261 = load i8*, i8** %_260
%_262 = bitcast i8* %_261 to i1 (i8*,i1)*
%_263 = call i1 %_262(i8* %_257, i1 1)
store i1 %_263, i1* %ntb
%_264 = load i8*, i8** %current_node
%_265 = bitcast i8* %_264 to i8***
%_266 = load i8**, i8*** %_265
%_267 = getelementptr i8*, i8** %_266, i32 1
%_268 = load i8*, i8** %_267
%_269 = bitcast i8* %_268 to i1 (i8*,i8*)*
%_270 = load i8*, i8** %new_node
%_271 = call i1 %_269(i8* %_264, i8* %_270)
store i1 %_271, i1* %ntb
br label %tag_17
tag_17:
br label %tag_11
tag_11:
br label %tag_6
tag_8:
ret i1 1
}

define i1 @Tree.Delete(i8* %this, i32 %.v_key){
%v_key = alloca i32
store i32 %.v_key, i32* %v_key
%current_node = alloca i8*
store i8* null, i8** %current_node
%parent_node = alloca i8*
store i8* null, i8** %parent_node
%cont = alloca i1
store i1 0, i1* %cont
%found = alloca i1
store i1 0, i1* %found
%is_root = alloca i1
store i1 0, i1* %is_root
%key_aux = alloca i32
store i32 0, i32* %key_aux
%ntb = alloca i1
store i1 0, i1* %ntb
store i8* %this, i8** %current_node
store i8* %this, i8** %parent_node
store i1 1, i1* %cont
store i1 0, i1* %found
store i1 1, i1* %is_root
;WhileStatement
br label %tag_18
tag_18:
%_272 = load i1, i1* %cont
br i1 %_272, label %tag_19, label %tag_20
tag_19:
%_273 = load i8*, i8** %current_node
%_274 = bitcast i8* %_273 to i8***
%_275 = load i8**, i8*** %_274
%_276 = getelementptr i8*, i8** %_275, i32 5
%_277 = load i8*, i8** %_276
%_278 = bitcast i8* %_277 to i32 (i8*)*
%_279 = call i32 %_278(i8* %_273)
store i32 %_279, i32* %key_aux
%_280 = load i32, i32* %v_key
%_281 = load i32, i32* %key_aux
%_282 = icmp slt i32 %_280, %_281
;IfStatement
br i1 %_282, label %tag_21, label %tag_22
tag_21:
%_283 = load i8*, i8** %current_node
%_284 = bitcast i8* %_283 to i8***
%_285 = load i8**, i8*** %_284
%_286 = getelementptr i8*, i8** %_285, i32 8
%_287 = load i8*, i8** %_286
%_288 = bitcast i8* %_287 to i1 (i8*)*
%_289 = call i1 %_288(i8* %_283)
;IfStatement
br i1 %_289, label %tag_24, label %tag_25
tag_24:
%_290 = load i8*, i8** %current_node
store i8* %_290, i8** %parent_node
%_291 = load i8*, i8** %current_node
%_292 = bitcast i8* %_291 to i8***
%_293 = load i8**, i8*** %_292
%_294 = getelementptr i8*, i8** %_293, i32 4
%_295 = load i8*, i8** %_294
%_296 = bitcast i8* %_295 to i8* (i8*)*
%_297 = call i8* %_296(i8* %_291)
store i8* %_297, i8** %current_node
br label %tag_26
tag_25:
store i1 0, i1* %cont
br label %tag_26
tag_26:
br label %tag_23
tag_22:
%_298 = load i32, i32* %key_aux
%_299 = load i32, i32* %v_key
%_300 = icmp slt i32 %_298, %_299
;IfStatement
br i1 %_300, label %tag_27, label %tag_28
tag_27:
%_301 = load i8*, i8** %current_node
%_302 = bitcast i8* %_301 to i8***
%_303 = load i8**, i8*** %_302
%_304 = getelementptr i8*, i8** %_303, i32 7
%_305 = load i8*, i8** %_304
%_306 = bitcast i8* %_305 to i1 (i8*)*
%_307 = call i1 %_306(i8* %_301)
;IfStatement
br i1 %_307, label %tag_30, label %tag_31
tag_30:
%_308 = load i8*, i8** %current_node
store i8* %_308, i8** %parent_node
%_309 = load i8*, i8** %current_node
%_310 = bitcast i8* %_309 to i8***
%_311 = load i8**, i8*** %_310
%_312 = getelementptr i8*, i8** %_311, i32 3
%_313 = load i8*, i8** %_312
%_314 = bitcast i8* %_313 to i8* (i8*)*
%_315 = call i8* %_314(i8* %_309)
store i8* %_315, i8** %current_node
br label %tag_32
tag_31:
store i1 0, i1* %cont
br label %tag_32
tag_32:
br label %tag_29
tag_28:
%_316 = load i1, i1* %is_root
;IfStatement
br i1 %_316, label %tag_33, label %tag_34
tag_33:
;AndExpression
%_317 = load i8*, i8** %current_node
%_318 = bitcast i8* %_317 to i8***
%_319 = load i8**, i8*** %_318
%_320 = getelementptr i8*, i8** %_319, i32 7
%_321 = load i8*, i8** %_320
%_322 = bitcast i8* %_321 to i1 (i8*)*
%_323 = call i1 %_322(i8* %_317)
%_324 = xor i1 1, %_323
br i1 %_324, label %tag_37, label %tag_36
tag_36:
br label %tag_39
tag_37:
%_325 = load i8*, i8** %current_node
%_326 = bitcast i8* %_325 to i8***
%_327 = load i8**, i8*** %_326
%_328 = getelementptr i8*, i8** %_327, i32 8
%_329 = load i8*, i8** %_328
%_330 = bitcast i8* %_329 to i1 (i8*)*
%_331 = call i1 %_330(i8* %_325)
%_332 = xor i1 1, %_331
br label %tag_38
tag_38:
br label %tag_39
tag_39:
%_333 = phi i1  [ 0, %tag_36 ], [ %_332, %tag_38 ]
;IfStatement
br i1 %_333, label %tag_40, label %tag_41
tag_40:
store i1 1, i1* %ntb
br label %tag_42
tag_41:
%_334 = bitcast i8* %this to i8***
%_335 = load i8**, i8*** %_334
%_336 = getelementptr i8*, i8** %_335, i32 14
%_337 = load i8*, i8** %_336
%_338 = bitcast i8* %_337 to i1 (i8*,i8*,i8*)*
%_339 = load i8*, i8** %parent_node
%_340 = load i8*, i8** %current_node
%_341 = call i1 %_338(i8* %this, i8* %_339, i8* %_340)
store i1 %_341, i1* %ntb
br label %tag_42
tag_42:
br label %tag_35
tag_34:
%_342 = bitcast i8* %this to i8***
%_343 = load i8**, i8*** %_342
%_344 = getelementptr i8*, i8** %_343, i32 14
%_345 = load i8*, i8** %_344
%_346 = bitcast i8* %_345 to i1 (i8*,i8*,i8*)*
%_347 = load i8*, i8** %parent_node
%_348 = load i8*, i8** %current_node
%_349 = call i1 %_346(i8* %this, i8* %_347, i8* %_348)
store i1 %_349, i1* %ntb
br label %tag_35
tag_35:
store i1 1, i1* %found
store i1 0, i1* %cont
br label %tag_29
tag_29:
br label %tag_23
tag_23:
store i1 0, i1* %is_root
br label %tag_18
tag_20:
%_350 = load i1, i1* %found
ret i1 %_350
}

define i1 @Tree.Remove(i8* %this, i8* %.p_node, i8* %.c_node){
%p_node = alloca i8*
store i8* %.p_node, i8** %p_node
%c_node = alloca i8*
store i8* %.c_node, i8** %c_node
%ntb = alloca i1
store i1 0, i1* %ntb
%auxkey1 = alloca i32
store i32 0, i32* %auxkey1
%auxkey2 = alloca i32
store i32 0, i32* %auxkey2
%_351 = load i8*, i8** %c_node
%_352 = bitcast i8* %_351 to i8***
%_353 = load i8**, i8*** %_352
%_354 = getelementptr i8*, i8** %_353, i32 8
%_355 = load i8*, i8** %_354
%_356 = bitcast i8* %_355 to i1 (i8*)*
%_357 = call i1 %_356(i8* %_351)
;IfStatement
br i1 %_357, label %tag_43, label %tag_44
tag_43:
%_358 = bitcast i8* %this to i8***
%_359 = load i8**, i8*** %_358
%_360 = getelementptr i8*, i8** %_359, i32 16
%_361 = load i8*, i8** %_360
%_362 = bitcast i8* %_361 to i1 (i8*,i8*,i8*)*
%_363 = load i8*, i8** %p_node
%_364 = load i8*, i8** %c_node
%_365 = call i1 %_362(i8* %this, i8* %_363, i8* %_364)
store i1 %_365, i1* %ntb
br label %tag_45
tag_44:
%_366 = load i8*, i8** %c_node
%_367 = bitcast i8* %_366 to i8***
%_368 = load i8**, i8*** %_367
%_369 = getelementptr i8*, i8** %_368, i32 7
%_370 = load i8*, i8** %_369
%_371 = bitcast i8* %_370 to i1 (i8*)*
%_372 = call i1 %_371(i8* %_366)
;IfStatement
br i1 %_372, label %tag_46, label %tag_47
tag_46:
%_373 = bitcast i8* %this to i8***
%_374 = load i8**, i8*** %_373
%_375 = getelementptr i8*, i8** %_374, i32 15
%_376 = load i8*, i8** %_375
%_377 = bitcast i8* %_376 to i1 (i8*,i8*,i8*)*
%_378 = load i8*, i8** %p_node
%_379 = load i8*, i8** %c_node
%_380 = call i1 %_377(i8* %this, i8* %_378, i8* %_379)
store i1 %_380, i1* %ntb
br label %tag_48
tag_47:
%_381 = load i8*, i8** %c_node
%_382 = bitcast i8* %_381 to i8***
%_383 = load i8**, i8*** %_382
%_384 = getelementptr i8*, i8** %_383, i32 5
%_385 = load i8*, i8** %_384
%_386 = bitcast i8* %_385 to i32 (i8*)*
%_387 = call i32 %_386(i8* %_381)
store i32 %_387, i32* %auxkey1
%_388 = load i8*, i8** %p_node
%_389 = bitcast i8* %_388 to i8***
%_390 = load i8**, i8*** %_389
%_391 = getelementptr i8*, i8** %_390, i32 4
%_392 = load i8*, i8** %_391
%_393 = bitcast i8* %_392 to i8* (i8*)*
%_394 = call i8* %_393(i8* %_388)
%_395 = bitcast i8* %_394 to i8***
%_396 = load i8**, i8*** %_395
%_397 = getelementptr i8*, i8** %_396, i32 5
%_398 = load i8*, i8** %_397
%_399 = bitcast i8* %_398 to i32 (i8*)*
%_400 = call i32 %_399(i8* %_394)
store i32 %_400, i32* %auxkey2
%_401 = bitcast i8* %this to i8***
%_402 = load i8**, i8*** %_401
%_403 = getelementptr i8*, i8** %_402, i32 11
%_404 = load i8*, i8** %_403
%_405 = bitcast i8* %_404 to i1 (i8*,i32,i32)*
%_406 = load i32, i32* %auxkey1
%_407 = load i32, i32* %auxkey2
%_408 = call i1 %_405(i8* %this, i32 %_406, i32 %_407)
;IfStatement
br i1 %_408, label %tag_49, label %tag_50
tag_49:
%_409 = load i8*, i8** %p_node
%_410 = bitcast i8* %_409 to i8***
%_411 = load i8**, i8*** %_410
%_412 = getelementptr i8*, i8** %_411, i32 2
%_413 = load i8*, i8** %_412
%_414 = bitcast i8* %_413 to i1 (i8*,i8*)*
%_415 = getelementptr i8, i8* %this, i32 30
%_416 = bitcast i8* %_415 to i8**
%_417 = load i8*, i8** %_416
%_418 = call i1 %_414(i8* %_409, i8* %_417)
store i1 %_418, i1* %ntb
%_419 = load i8*, i8** %p_node
%_420 = bitcast i8* %_419 to i8***
%_421 = load i8**, i8*** %_420
%_422 = getelementptr i8*, i8** %_421, i32 9
%_423 = load i8*, i8** %_422
%_424 = bitcast i8* %_423 to i1 (i8*,i1)*
%_425 = call i1 %_424(i8* %_419, i1 0)
store i1 %_425, i1* %ntb
br label %tag_51
tag_50:
%_426 = load i8*, i8** %p_node
%_427 = bitcast i8* %_426 to i8***
%_428 = load i8**, i8*** %_427
%_429 = getelementptr i8*, i8** %_428, i32 1
%_430 = load i8*, i8** %_429
%_431 = bitcast i8* %_430 to i1 (i8*,i8*)*
%_432 = getelementptr i8, i8* %this, i32 30
%_433 = bitcast i8* %_432 to i8**
%_434 = load i8*, i8** %_433
%_435 = call i1 %_431(i8* %_426, i8* %_434)
store i1 %_435, i1* %ntb
%_436 = load i8*, i8** %p_node
%_437 = bitcast i8* %_436 to i8***
%_438 = load i8**, i8*** %_437
%_439 = getelementptr i8*, i8** %_438, i32 10
%_440 = load i8*, i8** %_439
%_441 = bitcast i8* %_440 to i1 (i8*,i1)*
%_442 = call i1 %_441(i8* %_436, i1 0)
store i1 %_442, i1* %ntb
br label %tag_51
tag_51:
br label %tag_48
tag_48:
br label %tag_45
tag_45:
ret i1 1
}

define i1 @Tree.RemoveRight(i8* %this, i8* %.p_node, i8* %.c_node){
%p_node = alloca i8*
store i8* %.p_node, i8** %p_node
%c_node = alloca i8*
store i8* %.c_node, i8** %c_node
%ntb = alloca i1
store i1 0, i1* %ntb
;WhileStatement
br label %tag_52
tag_52:
%_443 = load i8*, i8** %c_node
%_444 = bitcast i8* %_443 to i8***
%_445 = load i8**, i8*** %_444
%_446 = getelementptr i8*, i8** %_445, i32 7
%_447 = load i8*, i8** %_446
%_448 = bitcast i8* %_447 to i1 (i8*)*
%_449 = call i1 %_448(i8* %_443)
br i1 %_449, label %tag_53, label %tag_54
tag_53:
%_450 = load i8*, i8** %c_node
%_451 = bitcast i8* %_450 to i8***
%_452 = load i8**, i8*** %_451
%_453 = getelementptr i8*, i8** %_452, i32 6
%_454 = load i8*, i8** %_453
%_455 = bitcast i8* %_454 to i1 (i8*,i32)*
%_456 = load i8*, i8** %c_node
%_457 = bitcast i8* %_456 to i8***
%_458 = load i8**, i8*** %_457
%_459 = getelementptr i8*, i8** %_458, i32 3
%_460 = load i8*, i8** %_459
%_461 = bitcast i8* %_460 to i8* (i8*)*
%_462 = call i8* %_461(i8* %_456)
%_463 = bitcast i8* %_462 to i8***
%_464 = load i8**, i8*** %_463
%_465 = getelementptr i8*, i8** %_464, i32 5
%_466 = load i8*, i8** %_465
%_467 = bitcast i8* %_466 to i32 (i8*)*
%_468 = call i32 %_467(i8* %_462)
%_469 = call i1 %_455(i8* %_450, i32 %_468)
store i1 %_469, i1* %ntb
%_470 = load i8*, i8** %c_node
store i8* %_470, i8** %p_node
%_471 = load i8*, i8** %c_node
%_472 = bitcast i8* %_471 to i8***
%_473 = load i8**, i8*** %_472
%_474 = getelementptr i8*, i8** %_473, i32 3
%_475 = load i8*, i8** %_474
%_476 = bitcast i8* %_475 to i8* (i8*)*
%_477 = call i8* %_476(i8* %_471)
store i8* %_477, i8** %c_node
br label %tag_52
tag_54:
%_478 = load i8*, i8** %p_node
%_479 = bitcast i8* %_478 to i8***
%_480 = load i8**, i8*** %_479
%_481 = getelementptr i8*, i8** %_480, i32 1
%_482 = load i8*, i8** %_481
%_483 = bitcast i8* %_482 to i1 (i8*,i8*)*
%_484 = getelementptr i8, i8* %this, i32 30
%_485 = bitcast i8* %_484 to i8**
%_486 = load i8*, i8** %_485
%_487 = call i1 %_483(i8* %_478, i8* %_486)
store i1 %_487, i1* %ntb
%_488 = load i8*, i8** %p_node
%_489 = bitcast i8* %_488 to i8***
%_490 = load i8**, i8*** %_489
%_491 = getelementptr i8*, i8** %_490, i32 10
%_492 = load i8*, i8** %_491
%_493 = bitcast i8* %_492 to i1 (i8*,i1)*
%_494 = call i1 %_493(i8* %_488, i1 0)
store i1 %_494, i1* %ntb
ret i1 1
}

define i1 @Tree.RemoveLeft(i8* %this, i8* %.p_node, i8* %.c_node){
%p_node = alloca i8*
store i8* %.p_node, i8** %p_node
%c_node = alloca i8*
store i8* %.c_node, i8** %c_node
%ntb = alloca i1
store i1 0, i1* %ntb
;WhileStatement
br label %tag_55
tag_55:
%_495 = load i8*, i8** %c_node
%_496 = bitcast i8* %_495 to i8***
%_497 = load i8**, i8*** %_496
%_498 = getelementptr i8*, i8** %_497, i32 8
%_499 = load i8*, i8** %_498
%_500 = bitcast i8* %_499 to i1 (i8*)*
%_501 = call i1 %_500(i8* %_495)
br i1 %_501, label %tag_56, label %tag_57
tag_56:
%_502 = load i8*, i8** %c_node
%_503 = bitcast i8* %_502 to i8***
%_504 = load i8**, i8*** %_503
%_505 = getelementptr i8*, i8** %_504, i32 6
%_506 = load i8*, i8** %_505
%_507 = bitcast i8* %_506 to i1 (i8*,i32)*
%_508 = load i8*, i8** %c_node
%_509 = bitcast i8* %_508 to i8***
%_510 = load i8**, i8*** %_509
%_511 = getelementptr i8*, i8** %_510, i32 4
%_512 = load i8*, i8** %_511
%_513 = bitcast i8* %_512 to i8* (i8*)*
%_514 = call i8* %_513(i8* %_508)
%_515 = bitcast i8* %_514 to i8***
%_516 = load i8**, i8*** %_515
%_517 = getelementptr i8*, i8** %_516, i32 5
%_518 = load i8*, i8** %_517
%_519 = bitcast i8* %_518 to i32 (i8*)*
%_520 = call i32 %_519(i8* %_514)
%_521 = call i1 %_507(i8* %_502, i32 %_520)
store i1 %_521, i1* %ntb
%_522 = load i8*, i8** %c_node
store i8* %_522, i8** %p_node
%_523 = load i8*, i8** %c_node
%_524 = bitcast i8* %_523 to i8***
%_525 = load i8**, i8*** %_524
%_526 = getelementptr i8*, i8** %_525, i32 4
%_527 = load i8*, i8** %_526
%_528 = bitcast i8* %_527 to i8* (i8*)*
%_529 = call i8* %_528(i8* %_523)
store i8* %_529, i8** %c_node
br label %tag_55
tag_57:
%_530 = load i8*, i8** %p_node
%_531 = bitcast i8* %_530 to i8***
%_532 = load i8**, i8*** %_531
%_533 = getelementptr i8*, i8** %_532, i32 2
%_534 = load i8*, i8** %_533
%_535 = bitcast i8* %_534 to i1 (i8*,i8*)*
%_536 = getelementptr i8, i8* %this, i32 30
%_537 = bitcast i8* %_536 to i8**
%_538 = load i8*, i8** %_537
%_539 = call i1 %_535(i8* %_530, i8* %_538)
store i1 %_539, i1* %ntb
%_540 = load i8*, i8** %p_node
%_541 = bitcast i8* %_540 to i8***
%_542 = load i8**, i8*** %_541
%_543 = getelementptr i8*, i8** %_542, i32 9
%_544 = load i8*, i8** %_543
%_545 = bitcast i8* %_544 to i1 (i8*,i1)*
%_546 = call i1 %_545(i8* %_540, i1 0)
store i1 %_546, i1* %ntb
ret i1 1
}

define i32 @Tree.Search(i8* %this, i32 %.v_key){
%v_key = alloca i32
store i32 %.v_key, i32* %v_key
%cont = alloca i1
store i1 0, i1* %cont
%ifound = alloca i32
store i32 0, i32* %ifound
%current_node = alloca i8*
store i8* null, i8** %current_node
%key_aux = alloca i32
store i32 0, i32* %key_aux
store i8* %this, i8** %current_node
store i1 1, i1* %cont
store i32 0, i32* %ifound
;WhileStatement
br label %tag_58
tag_58:
%_547 = load i1, i1* %cont
br i1 %_547, label %tag_59, label %tag_60
tag_59:
%_548 = load i8*, i8** %current_node
%_549 = bitcast i8* %_548 to i8***
%_550 = load i8**, i8*** %_549
%_551 = getelementptr i8*, i8** %_550, i32 5
%_552 = load i8*, i8** %_551
%_553 = bitcast i8* %_552 to i32 (i8*)*
%_554 = call i32 %_553(i8* %_548)
store i32 %_554, i32* %key_aux
%_555 = load i32, i32* %v_key
%_556 = load i32, i32* %key_aux
%_557 = icmp slt i32 %_555, %_556
;IfStatement
br i1 %_557, label %tag_61, label %tag_62
tag_61:
%_558 = load i8*, i8** %current_node
%_559 = bitcast i8* %_558 to i8***
%_560 = load i8**, i8*** %_559
%_561 = getelementptr i8*, i8** %_560, i32 8
%_562 = load i8*, i8** %_561
%_563 = bitcast i8* %_562 to i1 (i8*)*
%_564 = call i1 %_563(i8* %_558)
;IfStatement
br i1 %_564, label %tag_64, label %tag_65
tag_64:
%_565 = load i8*, i8** %current_node
%_566 = bitcast i8* %_565 to i8***
%_567 = load i8**, i8*** %_566
%_568 = getelementptr i8*, i8** %_567, i32 4
%_569 = load i8*, i8** %_568
%_570 = bitcast i8* %_569 to i8* (i8*)*
%_571 = call i8* %_570(i8* %_565)
store i8* %_571, i8** %current_node
br label %tag_66
tag_65:
store i1 0, i1* %cont
br label %tag_66
tag_66:
br label %tag_63
tag_62:
%_572 = load i32, i32* %key_aux
%_573 = load i32, i32* %v_key
%_574 = icmp slt i32 %_572, %_573
;IfStatement
br i1 %_574, label %tag_67, label %tag_68
tag_67:
%_575 = load i8*, i8** %current_node
%_576 = bitcast i8* %_575 to i8***
%_577 = load i8**, i8*** %_576
%_578 = getelementptr i8*, i8** %_577, i32 7
%_579 = load i8*, i8** %_578
%_580 = bitcast i8* %_579 to i1 (i8*)*
%_581 = call i1 %_580(i8* %_575)
;IfStatement
br i1 %_581, label %tag_70, label %tag_71
tag_70:
%_582 = load i8*, i8** %current_node
%_583 = bitcast i8* %_582 to i8***
%_584 = load i8**, i8*** %_583
%_585 = getelementptr i8*, i8** %_584, i32 3
%_586 = load i8*, i8** %_585
%_587 = bitcast i8* %_586 to i8* (i8*)*
%_588 = call i8* %_587(i8* %_582)
store i8* %_588, i8** %current_node
br label %tag_72
tag_71:
store i1 0, i1* %cont
br label %tag_72
tag_72:
br label %tag_69
tag_68:
store i32 1, i32* %ifound
store i1 0, i1* %cont
br label %tag_69
tag_69:
br label %tag_63
tag_63:
br label %tag_58
tag_60:
%_589 = load i32, i32* %ifound
ret i32 %_589
}

define i1 @Tree.Print(i8* %this){
%current_node = alloca i8*
store i8* null, i8** %current_node
%ntb = alloca i1
store i1 0, i1* %ntb
store i8* %this, i8** %current_node
%_590 = bitcast i8* %this to i8***
%_591 = load i8**, i8*** %_590
%_592 = getelementptr i8*, i8** %_591, i32 19
%_593 = load i8*, i8** %_592
%_594 = bitcast i8* %_593 to i1 (i8*,i8*)*
%_595 = load i8*, i8** %current_node
%_596 = call i1 %_594(i8* %this, i8* %_595)
store i1 %_596, i1* %ntb
ret i1 1
}

define i1 @Tree.RecPrint(i8* %this, i8* %.node){
%node = alloca i8*
store i8* %.node, i8** %node
%ntb = alloca i1
store i1 0, i1* %ntb
%_597 = load i8*, i8** %node
%_598 = bitcast i8* %_597 to i8***
%_599 = load i8**, i8*** %_598
%_600 = getelementptr i8*, i8** %_599, i32 8
%_601 = load i8*, i8** %_600
%_602 = bitcast i8* %_601 to i1 (i8*)*
%_603 = call i1 %_602(i8* %_597)
;IfStatement
br i1 %_603, label %tag_73, label %tag_74
tag_73:
%_604 = bitcast i8* %this to i8***
%_605 = load i8**, i8*** %_604
%_606 = getelementptr i8*, i8** %_605, i32 19
%_607 = load i8*, i8** %_606
%_608 = bitcast i8* %_607 to i1 (i8*,i8*)*
%_609 = load i8*, i8** %node
%_610 = bitcast i8* %_609 to i8***
%_611 = load i8**, i8*** %_610
%_612 = getelementptr i8*, i8** %_611, i32 4
%_613 = load i8*, i8** %_612
%_614 = bitcast i8* %_613 to i8* (i8*)*
%_615 = call i8* %_614(i8* %_609)
%_616 = call i1 %_608(i8* %this, i8* %_615)
store i1 %_616, i1* %ntb
br label %tag_75
tag_74:
store i1 1, i1* %ntb
br label %tag_75
tag_75:
%_617 = load i8*, i8** %node
%_618 = bitcast i8* %_617 to i8***
%_619 = load i8**, i8*** %_618
%_620 = getelementptr i8*, i8** %_619, i32 5
%_621 = load i8*, i8** %_620
%_622 = bitcast i8* %_621 to i32 (i8*)*
%_623 = call i32 %_622(i8* %_617)
call void (i32) @print_int(i32 %_623)
%_624 = load i8*, i8** %node
%_625 = bitcast i8* %_624 to i8***
%_626 = load i8**, i8*** %_625
%_627 = getelementptr i8*, i8** %_626, i32 7
%_628 = load i8*, i8** %_627
%_629 = bitcast i8* %_628 to i1 (i8*)*
%_630 = call i1 %_629(i8* %_624)
;IfStatement
br i1 %_630, label %tag_76, label %tag_77
tag_76:
%_631 = bitcast i8* %this to i8***
%_632 = load i8**, i8*** %_631
%_633 = getelementptr i8*, i8** %_632, i32 19
%_634 = load i8*, i8** %_633
%_635 = bitcast i8* %_634 to i1 (i8*,i8*)*
%_636 = load i8*, i8** %node
%_637 = bitcast i8* %_636 to i8***
%_638 = load i8**, i8*** %_637
%_639 = getelementptr i8*, i8** %_638, i32 3
%_640 = load i8*, i8** %_639
%_641 = bitcast i8* %_640 to i8* (i8*)*
%_642 = call i8* %_641(i8* %_636)
%_643 = call i1 %_635(i8* %this, i8* %_642)
store i1 %_643, i1* %ntb
br label %tag_78
tag_77:
store i1 1, i1* %ntb
br label %tag_78
tag_78:
ret i1 1
}


