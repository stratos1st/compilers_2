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

@.TV_vtable = global [1 x i8*] [ 
	i8* bitcast (i32 (i8*)* @TV.Start to i8*)
]

@.Tree_vtable = global [21 x i8*] [ 
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
	i8* bitcast (i1 (i8*,i8*)* @Tree.RecPrint to i8*),
	i8* bitcast (i32 (i8*,i8*)* @Tree.accept to i8*)
]

@.Visitor_vtable = global [1 x i8*] [ 
	i8* bitcast (i32 (i8*,i8*)* @Visitor.visit to i8*)
]

@.MyVisitor_vtable = global [1 x i8*] [ 
	i8* bitcast (i32 (i8*,i8*)* @MyVisitor.visit to i8*)
]

define i32 @main() {
%_0 = call i8* @calloc(i32 1, i32 8)
%_1 = bitcast i8* %_0 to i8***
%_2 = getelementptr [1 x i8*], [1 x i8*]* @.TV_vtable, i32 0, i32 0
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

define i32 @TV.Start(i8* %this){
%root = alloca i8*
store i8* null, i8** %root
%ntb = alloca i1
store i1 0, i1* %ntb
%nti = alloca i32
store i32 0, i32* %nti
%v = alloca i8*
store i8* null, i8** %v
%_9 = call i8* @calloc(i32 1, i32 38)
%_10 = bitcast i8* %_9 to i8***
%_11 = getelementptr [21 x i8*], [21 x i8*]* @.Tree_vtable, i32 0, i32 0
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
%_36 = getelementptr i8*, i8** %_35, i32 12
%_37 = load i8*, i8** %_36
%_38 = bitcast i8* %_37 to i1 (i8*,i32)*
%_39 = call i1 %_38(i8* %_33, i32 24)
store i1 %_39, i1* %ntb
%_40 = load i8*, i8** %root
%_41 = bitcast i8* %_40 to i8***
%_42 = load i8**, i8*** %_41
%_43 = getelementptr i8*, i8** %_42, i32 12
%_44 = load i8*, i8** %_43
%_45 = bitcast i8* %_44 to i1 (i8*,i32)*
%_46 = call i1 %_45(i8* %_40, i32 4)
store i1 %_46, i1* %ntb
%_47 = load i8*, i8** %root
%_48 = bitcast i8* %_47 to i8***
%_49 = load i8**, i8*** %_48
%_50 = getelementptr i8*, i8** %_49, i32 12
%_51 = load i8*, i8** %_50
%_52 = bitcast i8* %_51 to i1 (i8*,i32)*
%_53 = call i1 %_52(i8* %_47, i32 12)
store i1 %_53, i1* %ntb
%_54 = load i8*, i8** %root
%_55 = bitcast i8* %_54 to i8***
%_56 = load i8**, i8*** %_55
%_57 = getelementptr i8*, i8** %_56, i32 12
%_58 = load i8*, i8** %_57
%_59 = bitcast i8* %_58 to i1 (i8*,i32)*
%_60 = call i1 %_59(i8* %_54, i32 20)
store i1 %_60, i1* %ntb
%_61 = load i8*, i8** %root
%_62 = bitcast i8* %_61 to i8***
%_63 = load i8**, i8*** %_62
%_64 = getelementptr i8*, i8** %_63, i32 12
%_65 = load i8*, i8** %_64
%_66 = bitcast i8* %_65 to i1 (i8*,i32)*
%_67 = call i1 %_66(i8* %_61, i32 28)
store i1 %_67, i1* %ntb
%_68 = load i8*, i8** %root
%_69 = bitcast i8* %_68 to i8***
%_70 = load i8**, i8*** %_69
%_71 = getelementptr i8*, i8** %_70, i32 12
%_72 = load i8*, i8** %_71
%_73 = bitcast i8* %_72 to i1 (i8*,i32)*
%_74 = call i1 %_73(i8* %_68, i32 14)
store i1 %_74, i1* %ntb
%_75 = load i8*, i8** %root
%_76 = bitcast i8* %_75 to i8***
%_77 = load i8**, i8*** %_76
%_78 = getelementptr i8*, i8** %_77, i32 18
%_79 = load i8*, i8** %_78
%_80 = bitcast i8* %_79 to i1 (i8*)*
%_81 = call i1 %_80(i8* %_75)
store i1 %_81, i1* %ntb
call void (i32) @print_int(i32 100000000)
%_82 = call i8* @calloc(i32 1, i32 24)
%_83 = bitcast i8* %_82 to i8***
%_84 = getelementptr [1 x i8*], [1 x i8*]* @.MyVisitor_vtable, i32 0, i32 0
store i8** %_84, i8*** %_83
store i8* %_82, i8** %v
call void (i32) @print_int(i32 50000000)
%_85 = load i8*, i8** %root
%_86 = bitcast i8* %_85 to i8***
%_87 = load i8**, i8*** %_86
%_88 = getelementptr i8*, i8** %_87, i32 20
%_89 = load i8*, i8** %_88
%_90 = bitcast i8* %_89 to i32 (i8*,i8*)*
%_91 = load i8*, i8** %v
%_92 = call i32 %_90(i8* %_85, i8* %_91)
store i32 %_92, i32* %nti
call void (i32) @print_int(i32 100000000)
%_93 = load i8*, i8** %root
%_94 = bitcast i8* %_93 to i8***
%_95 = load i8**, i8*** %_94
%_96 = getelementptr i8*, i8** %_95, i32 17
%_97 = load i8*, i8** %_96
%_98 = bitcast i8* %_97 to i32 (i8*,i32)*
%_99 = call i32 %_98(i8* %_93, i32 24)
call void (i32) @print_int(i32 %_99)
%_100 = load i8*, i8** %root
%_101 = bitcast i8* %_100 to i8***
%_102 = load i8**, i8*** %_101
%_103 = getelementptr i8*, i8** %_102, i32 17
%_104 = load i8*, i8** %_103
%_105 = bitcast i8* %_104 to i32 (i8*,i32)*
%_106 = call i32 %_105(i8* %_100, i32 12)
call void (i32) @print_int(i32 %_106)
%_107 = load i8*, i8** %root
%_108 = bitcast i8* %_107 to i8***
%_109 = load i8**, i8*** %_108
%_110 = getelementptr i8*, i8** %_109, i32 17
%_111 = load i8*, i8** %_110
%_112 = bitcast i8* %_111 to i32 (i8*,i32)*
%_113 = call i32 %_112(i8* %_107, i32 16)
call void (i32) @print_int(i32 %_113)
%_114 = load i8*, i8** %root
%_115 = bitcast i8* %_114 to i8***
%_116 = load i8**, i8*** %_115
%_117 = getelementptr i8*, i8** %_116, i32 17
%_118 = load i8*, i8** %_117
%_119 = bitcast i8* %_118 to i32 (i8*,i32)*
%_120 = call i32 %_119(i8* %_114, i32 50)
call void (i32) @print_int(i32 %_120)
%_121 = load i8*, i8** %root
%_122 = bitcast i8* %_121 to i8***
%_123 = load i8**, i8*** %_122
%_124 = getelementptr i8*, i8** %_123, i32 17
%_125 = load i8*, i8** %_124
%_126 = bitcast i8* %_125 to i32 (i8*,i32)*
%_127 = call i32 %_126(i8* %_121, i32 12)
call void (i32) @print_int(i32 %_127)
%_128 = load i8*, i8** %root
%_129 = bitcast i8* %_128 to i8***
%_130 = load i8**, i8*** %_129
%_131 = getelementptr i8*, i8** %_130, i32 13
%_132 = load i8*, i8** %_131
%_133 = bitcast i8* %_132 to i1 (i8*,i32)*
%_134 = call i1 %_133(i8* %_128, i32 12)
store i1 %_134, i1* %ntb
%_135 = load i8*, i8** %root
%_136 = bitcast i8* %_135 to i8***
%_137 = load i8**, i8*** %_136
%_138 = getelementptr i8*, i8** %_137, i32 18
%_139 = load i8*, i8** %_138
%_140 = bitcast i8* %_139 to i1 (i8*)*
%_141 = call i1 %_140(i8* %_135)
store i1 %_141, i1* %ntb
%_142 = load i8*, i8** %root
%_143 = bitcast i8* %_142 to i8***
%_144 = load i8**, i8*** %_143
%_145 = getelementptr i8*, i8** %_144, i32 17
%_146 = load i8*, i8** %_145
%_147 = bitcast i8* %_146 to i32 (i8*,i32)*
%_148 = call i32 %_147(i8* %_142, i32 12)
call void (i32) @print_int(i32 %_148)
ret i32 0
}

define i1 @Tree.Init(i8* %this, i32 %.v_key){
%v_key = alloca i32
store i32 %.v_key, i32* %v_key
%_149 = getelementptr i8, i8* %this, i32 24
%_150 = bitcast i8* %_149 to i32*
%_151 = load i32, i32* %v_key
store i32 %_151, i32* %_150
%_152 = getelementptr i8, i8* %this, i32 28
%_153 = bitcast i8* %_152 to i1*
store i1 0, i1* %_153
%_154 = getelementptr i8, i8* %this, i32 29
%_155 = bitcast i8* %_154 to i1*
store i1 0, i1* %_155
ret i1 1
}

define i1 @Tree.SetRight(i8* %this, i8* %.rn){
%rn = alloca i8*
store i8* %.rn, i8** %rn
%_156 = getelementptr i8, i8* %this, i32 16
%_157 = bitcast i8* %_156 to i8**
%_158 = load i8*, i8** %rn
store i8* %_158, i8** %_157
ret i1 1
}

define i1 @Tree.SetLeft(i8* %this, i8* %.ln){
%ln = alloca i8*
store i8* %.ln, i8** %ln
%_159 = getelementptr i8, i8* %this, i32 8
%_160 = bitcast i8* %_159 to i8**
%_161 = load i8*, i8** %ln
store i8* %_161, i8** %_160
ret i1 1
}

define i8* @Tree.GetRight(i8* %this){
%_162 = getelementptr i8, i8* %this, i32 16
%_163 = bitcast i8* %_162 to i8**
%_164 = load i8*, i8** %_163
ret i8* %_164
}

define i8* @Tree.GetLeft(i8* %this){
%_165 = getelementptr i8, i8* %this, i32 8
%_166 = bitcast i8* %_165 to i8**
%_167 = load i8*, i8** %_166
ret i8* %_167
}

define i32 @Tree.GetKey(i8* %this){
%_168 = getelementptr i8, i8* %this, i32 24
%_169 = bitcast i8* %_168 to i32*
%_170 = load i32, i32* %_169
ret i32 %_170
}

define i1 @Tree.SetKey(i8* %this, i32 %.v_key){
%v_key = alloca i32
store i32 %.v_key, i32* %v_key
%_171 = getelementptr i8, i8* %this, i32 24
%_172 = bitcast i8* %_171 to i32*
%_173 = load i32, i32* %v_key
store i32 %_173, i32* %_172
ret i1 1
}

define i1 @Tree.GetHas_Right(i8* %this){
%_174 = getelementptr i8, i8* %this, i32 29
%_175 = bitcast i8* %_174 to i1*
%_176 = load i1, i1* %_175
ret i1 %_176
}

define i1 @Tree.GetHas_Left(i8* %this){
%_177 = getelementptr i8, i8* %this, i32 28
%_178 = bitcast i8* %_177 to i1*
%_179 = load i1, i1* %_178
ret i1 %_179
}

define i1 @Tree.SetHas_Left(i8* %this, i1 %.val){
%val = alloca i1
store i1 %.val, i1* %val
%_180 = getelementptr i8, i8* %this, i32 28
%_181 = bitcast i8* %_180 to i1*
%_182 = load i1, i1* %val
store i1 %_182, i1* %_181
ret i1 1
}

define i1 @Tree.SetHas_Right(i8* %this, i1 %.val){
%val = alloca i1
store i1 %.val, i1* %val
%_183 = getelementptr i8, i8* %this, i32 29
%_184 = bitcast i8* %_183 to i1*
%_185 = load i1, i1* %val
store i1 %_185, i1* %_184
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
%_187 = load i32, i32* %num2
%_186 = add i32 %_187, 1
store i32 %_186, i32* %nti
%_188 = load i32, i32* %num1
%_189 = load i32, i32* %num2
%_190 = icmp slt i32 %_188, %_189
;IfStatement
br i1 %_190, label %tag_0, label %tag_1
tag_0:
store i1 0, i1* %ntb
br label %tag_2
tag_1:
%_191 = load i32, i32* %num1
%_192 = load i32, i32* %nti
%_193 = icmp slt i32 %_191, %_192
%_194 = xor i1 1, %_193
;IfStatement
br i1 %_194, label %tag_3, label %tag_4
tag_3:
store i1 0, i1* %ntb
br label %tag_5
tag_4:
store i1 1, i1* %ntb
br label %tag_5
tag_5:
br label %tag_2
tag_2:
%_195 = load i1, i1* %ntb
ret i1 %_195
}

define i1 @Tree.Insert(i8* %this, i32 %.v_key){
%v_key = alloca i32
store i32 %.v_key, i32* %v_key
%new_node = alloca i8*
store i8* null, i8** %new_node
%ntb = alloca i1
store i1 0, i1* %ntb
%current_node = alloca i8*
store i8* null, i8** %current_node
%cont = alloca i1
store i1 0, i1* %cont
%key_aux = alloca i32
store i32 0, i32* %key_aux
%_196 = call i8* @calloc(i32 1, i32 38)
%_197 = bitcast i8* %_196 to i8***
%_198 = getelementptr [21 x i8*], [21 x i8*]* @.Tree_vtable, i32 0, i32 0
store i8** %_198, i8*** %_197
store i8* %_196, i8** %new_node
%_199 = load i8*, i8** %new_node
%_200 = bitcast i8* %_199 to i8***
%_201 = load i8**, i8*** %_200
%_202 = getelementptr i8*, i8** %_201, i32 0
%_203 = load i8*, i8** %_202
%_204 = bitcast i8* %_203 to i1 (i8*,i32)*
%_205 = load i32, i32* %v_key
%_206 = call i1 %_204(i8* %_199, i32 %_205)
store i1 %_206, i1* %ntb
store i8* %this, i8** %current_node
store i1 1, i1* %cont
;WhileStatement
br label %tag_6
tag_6:
%_207 = load i1, i1* %cont
br i1 %_207, label %tag_7, label %tag_8
tag_7:
%_208 = load i8*, i8** %current_node
%_209 = bitcast i8* %_208 to i8***
%_210 = load i8**, i8*** %_209
%_211 = getelementptr i8*, i8** %_210, i32 5
%_212 = load i8*, i8** %_211
%_213 = bitcast i8* %_212 to i32 (i8*)*
%_214 = call i32 %_213(i8* %_208)
store i32 %_214, i32* %key_aux
%_215 = load i32, i32* %v_key
%_216 = load i32, i32* %key_aux
%_217 = icmp slt i32 %_215, %_216
;IfStatement
br i1 %_217, label %tag_9, label %tag_10
tag_9:
%_218 = load i8*, i8** %current_node
%_219 = bitcast i8* %_218 to i8***
%_220 = load i8**, i8*** %_219
%_221 = getelementptr i8*, i8** %_220, i32 8
%_222 = load i8*, i8** %_221
%_223 = bitcast i8* %_222 to i1 (i8*)*
%_224 = call i1 %_223(i8* %_218)
;IfStatement
br i1 %_224, label %tag_12, label %tag_13
tag_12:
%_225 = load i8*, i8** %current_node
%_226 = bitcast i8* %_225 to i8***
%_227 = load i8**, i8*** %_226
%_228 = getelementptr i8*, i8** %_227, i32 4
%_229 = load i8*, i8** %_228
%_230 = bitcast i8* %_229 to i8* (i8*)*
%_231 = call i8* %_230(i8* %_225)
store i8* %_231, i8** %current_node
br label %tag_14
tag_13:
store i1 0, i1* %cont
%_232 = load i8*, i8** %current_node
%_233 = bitcast i8* %_232 to i8***
%_234 = load i8**, i8*** %_233
%_235 = getelementptr i8*, i8** %_234, i32 9
%_236 = load i8*, i8** %_235
%_237 = bitcast i8* %_236 to i1 (i8*,i1)*
%_238 = call i1 %_237(i8* %_232, i1 1)
store i1 %_238, i1* %ntb
%_239 = load i8*, i8** %current_node
%_240 = bitcast i8* %_239 to i8***
%_241 = load i8**, i8*** %_240
%_242 = getelementptr i8*, i8** %_241, i32 2
%_243 = load i8*, i8** %_242
%_244 = bitcast i8* %_243 to i1 (i8*,i8*)*
%_245 = load i8*, i8** %new_node
%_246 = call i1 %_244(i8* %_239, i8* %_245)
store i1 %_246, i1* %ntb
br label %tag_14
tag_14:
br label %tag_11
tag_10:
%_247 = load i8*, i8** %current_node
%_248 = bitcast i8* %_247 to i8***
%_249 = load i8**, i8*** %_248
%_250 = getelementptr i8*, i8** %_249, i32 7
%_251 = load i8*, i8** %_250
%_252 = bitcast i8* %_251 to i1 (i8*)*
%_253 = call i1 %_252(i8* %_247)
;IfStatement
br i1 %_253, label %tag_15, label %tag_16
tag_15:
%_254 = load i8*, i8** %current_node
%_255 = bitcast i8* %_254 to i8***
%_256 = load i8**, i8*** %_255
%_257 = getelementptr i8*, i8** %_256, i32 3
%_258 = load i8*, i8** %_257
%_259 = bitcast i8* %_258 to i8* (i8*)*
%_260 = call i8* %_259(i8* %_254)
store i8* %_260, i8** %current_node
br label %tag_17
tag_16:
store i1 0, i1* %cont
%_261 = load i8*, i8** %current_node
%_262 = bitcast i8* %_261 to i8***
%_263 = load i8**, i8*** %_262
%_264 = getelementptr i8*, i8** %_263, i32 10
%_265 = load i8*, i8** %_264
%_266 = bitcast i8* %_265 to i1 (i8*,i1)*
%_267 = call i1 %_266(i8* %_261, i1 1)
store i1 %_267, i1* %ntb
%_268 = load i8*, i8** %current_node
%_269 = bitcast i8* %_268 to i8***
%_270 = load i8**, i8*** %_269
%_271 = getelementptr i8*, i8** %_270, i32 1
%_272 = load i8*, i8** %_271
%_273 = bitcast i8* %_272 to i1 (i8*,i8*)*
%_274 = load i8*, i8** %new_node
%_275 = call i1 %_273(i8* %_268, i8* %_274)
store i1 %_275, i1* %ntb
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
%ntb = alloca i1
store i1 0, i1* %ntb
%is_root = alloca i1
store i1 0, i1* %is_root
%key_aux = alloca i32
store i32 0, i32* %key_aux
store i8* %this, i8** %current_node
store i8* %this, i8** %parent_node
store i1 1, i1* %cont
store i1 0, i1* %found
store i1 1, i1* %is_root
;WhileStatement
br label %tag_18
tag_18:
%_276 = load i1, i1* %cont
br i1 %_276, label %tag_19, label %tag_20
tag_19:
%_277 = load i8*, i8** %current_node
%_278 = bitcast i8* %_277 to i8***
%_279 = load i8**, i8*** %_278
%_280 = getelementptr i8*, i8** %_279, i32 5
%_281 = load i8*, i8** %_280
%_282 = bitcast i8* %_281 to i32 (i8*)*
%_283 = call i32 %_282(i8* %_277)
store i32 %_283, i32* %key_aux
%_284 = load i32, i32* %v_key
%_285 = load i32, i32* %key_aux
%_286 = icmp slt i32 %_284, %_285
;IfStatement
br i1 %_286, label %tag_21, label %tag_22
tag_21:
%_287 = load i8*, i8** %current_node
%_288 = bitcast i8* %_287 to i8***
%_289 = load i8**, i8*** %_288
%_290 = getelementptr i8*, i8** %_289, i32 8
%_291 = load i8*, i8** %_290
%_292 = bitcast i8* %_291 to i1 (i8*)*
%_293 = call i1 %_292(i8* %_287)
;IfStatement
br i1 %_293, label %tag_24, label %tag_25
tag_24:
%_294 = load i8*, i8** %current_node
store i8* %_294, i8** %parent_node
%_295 = load i8*, i8** %current_node
%_296 = bitcast i8* %_295 to i8***
%_297 = load i8**, i8*** %_296
%_298 = getelementptr i8*, i8** %_297, i32 4
%_299 = load i8*, i8** %_298
%_300 = bitcast i8* %_299 to i8* (i8*)*
%_301 = call i8* %_300(i8* %_295)
store i8* %_301, i8** %current_node
br label %tag_26
tag_25:
store i1 0, i1* %cont
br label %tag_26
tag_26:
br label %tag_23
tag_22:
%_302 = load i32, i32* %key_aux
%_303 = load i32, i32* %v_key
%_304 = icmp slt i32 %_302, %_303
;IfStatement
br i1 %_304, label %tag_27, label %tag_28
tag_27:
%_305 = load i8*, i8** %current_node
%_306 = bitcast i8* %_305 to i8***
%_307 = load i8**, i8*** %_306
%_308 = getelementptr i8*, i8** %_307, i32 7
%_309 = load i8*, i8** %_308
%_310 = bitcast i8* %_309 to i1 (i8*)*
%_311 = call i1 %_310(i8* %_305)
;IfStatement
br i1 %_311, label %tag_30, label %tag_31
tag_30:
%_312 = load i8*, i8** %current_node
store i8* %_312, i8** %parent_node
%_313 = load i8*, i8** %current_node
%_314 = bitcast i8* %_313 to i8***
%_315 = load i8**, i8*** %_314
%_316 = getelementptr i8*, i8** %_315, i32 3
%_317 = load i8*, i8** %_316
%_318 = bitcast i8* %_317 to i8* (i8*)*
%_319 = call i8* %_318(i8* %_313)
store i8* %_319, i8** %current_node
br label %tag_32
tag_31:
store i1 0, i1* %cont
br label %tag_32
tag_32:
br label %tag_29
tag_28:
%_320 = load i1, i1* %is_root
;IfStatement
br i1 %_320, label %tag_33, label %tag_34
tag_33:
;AndExpression
%_321 = load i8*, i8** %current_node
%_322 = bitcast i8* %_321 to i8***
%_323 = load i8**, i8*** %_322
%_324 = getelementptr i8*, i8** %_323, i32 7
%_325 = load i8*, i8** %_324
%_326 = bitcast i8* %_325 to i1 (i8*)*
%_327 = call i1 %_326(i8* %_321)
%_328 = xor i1 1, %_327
br i1 %_328, label %tag_37, label %tag_36
tag_36:
br label %tag_39
tag_37:
%_329 = load i8*, i8** %current_node
%_330 = bitcast i8* %_329 to i8***
%_331 = load i8**, i8*** %_330
%_332 = getelementptr i8*, i8** %_331, i32 8
%_333 = load i8*, i8** %_332
%_334 = bitcast i8* %_333 to i1 (i8*)*
%_335 = call i1 %_334(i8* %_329)
%_336 = xor i1 1, %_335
br label %tag_38
tag_38:
br label %tag_39
tag_39:
%_337 = phi i1  [ 0, %tag_36 ], [ %_336, %tag_38 ]
;IfStatement
br i1 %_337, label %tag_40, label %tag_41
tag_40:
store i1 1, i1* %ntb
br label %tag_42
tag_41:
%_338 = bitcast i8* %this to i8***
%_339 = load i8**, i8*** %_338
%_340 = getelementptr i8*, i8** %_339, i32 14
%_341 = load i8*, i8** %_340
%_342 = bitcast i8* %_341 to i1 (i8*,i8*,i8*)*
%_343 = load i8*, i8** %parent_node
%_344 = load i8*, i8** %current_node
%_345 = call i1 %_342(i8* %this, i8* %_343, i8* %_344)
store i1 %_345, i1* %ntb
br label %tag_42
tag_42:
br label %tag_35
tag_34:
%_346 = bitcast i8* %this to i8***
%_347 = load i8**, i8*** %_346
%_348 = getelementptr i8*, i8** %_347, i32 14
%_349 = load i8*, i8** %_348
%_350 = bitcast i8* %_349 to i1 (i8*,i8*,i8*)*
%_351 = load i8*, i8** %parent_node
%_352 = load i8*, i8** %current_node
%_353 = call i1 %_350(i8* %this, i8* %_351, i8* %_352)
store i1 %_353, i1* %ntb
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
%_354 = load i1, i1* %found
ret i1 %_354
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
%_355 = load i8*, i8** %c_node
%_356 = bitcast i8* %_355 to i8***
%_357 = load i8**, i8*** %_356
%_358 = getelementptr i8*, i8** %_357, i32 8
%_359 = load i8*, i8** %_358
%_360 = bitcast i8* %_359 to i1 (i8*)*
%_361 = call i1 %_360(i8* %_355)
;IfStatement
br i1 %_361, label %tag_43, label %tag_44
tag_43:
%_362 = bitcast i8* %this to i8***
%_363 = load i8**, i8*** %_362
%_364 = getelementptr i8*, i8** %_363, i32 16
%_365 = load i8*, i8** %_364
%_366 = bitcast i8* %_365 to i1 (i8*,i8*,i8*)*
%_367 = load i8*, i8** %p_node
%_368 = load i8*, i8** %c_node
%_369 = call i1 %_366(i8* %this, i8* %_367, i8* %_368)
store i1 %_369, i1* %ntb
br label %tag_45
tag_44:
%_370 = load i8*, i8** %c_node
%_371 = bitcast i8* %_370 to i8***
%_372 = load i8**, i8*** %_371
%_373 = getelementptr i8*, i8** %_372, i32 7
%_374 = load i8*, i8** %_373
%_375 = bitcast i8* %_374 to i1 (i8*)*
%_376 = call i1 %_375(i8* %_370)
;IfStatement
br i1 %_376, label %tag_46, label %tag_47
tag_46:
%_377 = bitcast i8* %this to i8***
%_378 = load i8**, i8*** %_377
%_379 = getelementptr i8*, i8** %_378, i32 15
%_380 = load i8*, i8** %_379
%_381 = bitcast i8* %_380 to i1 (i8*,i8*,i8*)*
%_382 = load i8*, i8** %p_node
%_383 = load i8*, i8** %c_node
%_384 = call i1 %_381(i8* %this, i8* %_382, i8* %_383)
store i1 %_384, i1* %ntb
br label %tag_48
tag_47:
%_385 = load i8*, i8** %c_node
%_386 = bitcast i8* %_385 to i8***
%_387 = load i8**, i8*** %_386
%_388 = getelementptr i8*, i8** %_387, i32 5
%_389 = load i8*, i8** %_388
%_390 = bitcast i8* %_389 to i32 (i8*)*
%_391 = call i32 %_390(i8* %_385)
store i32 %_391, i32* %auxkey1
%_392 = load i8*, i8** %p_node
%_393 = bitcast i8* %_392 to i8***
%_394 = load i8**, i8*** %_393
%_395 = getelementptr i8*, i8** %_394, i32 4
%_396 = load i8*, i8** %_395
%_397 = bitcast i8* %_396 to i8* (i8*)*
%_398 = call i8* %_397(i8* %_392)
%_399 = bitcast i8* %_398 to i8***
%_400 = load i8**, i8*** %_399
%_401 = getelementptr i8*, i8** %_400, i32 5
%_402 = load i8*, i8** %_401
%_403 = bitcast i8* %_402 to i32 (i8*)*
%_404 = call i32 %_403(i8* %_398)
store i32 %_404, i32* %auxkey2
%_405 = bitcast i8* %this to i8***
%_406 = load i8**, i8*** %_405
%_407 = getelementptr i8*, i8** %_406, i32 11
%_408 = load i8*, i8** %_407
%_409 = bitcast i8* %_408 to i1 (i8*,i32,i32)*
%_410 = load i32, i32* %auxkey1
%_411 = load i32, i32* %auxkey2
%_412 = call i1 %_409(i8* %this, i32 %_410, i32 %_411)
;IfStatement
br i1 %_412, label %tag_49, label %tag_50
tag_49:
%_413 = load i8*, i8** %p_node
%_414 = bitcast i8* %_413 to i8***
%_415 = load i8**, i8*** %_414
%_416 = getelementptr i8*, i8** %_415, i32 2
%_417 = load i8*, i8** %_416
%_418 = bitcast i8* %_417 to i1 (i8*,i8*)*
%_419 = getelementptr i8, i8* %this, i32 30
%_420 = bitcast i8* %_419 to i8**
%_421 = load i8*, i8** %_420
%_422 = call i1 %_418(i8* %_413, i8* %_421)
store i1 %_422, i1* %ntb
%_423 = load i8*, i8** %p_node
%_424 = bitcast i8* %_423 to i8***
%_425 = load i8**, i8*** %_424
%_426 = getelementptr i8*, i8** %_425, i32 9
%_427 = load i8*, i8** %_426
%_428 = bitcast i8* %_427 to i1 (i8*,i1)*
%_429 = call i1 %_428(i8* %_423, i1 0)
store i1 %_429, i1* %ntb
br label %tag_51
tag_50:
%_430 = load i8*, i8** %p_node
%_431 = bitcast i8* %_430 to i8***
%_432 = load i8**, i8*** %_431
%_433 = getelementptr i8*, i8** %_432, i32 1
%_434 = load i8*, i8** %_433
%_435 = bitcast i8* %_434 to i1 (i8*,i8*)*
%_436 = getelementptr i8, i8* %this, i32 30
%_437 = bitcast i8* %_436 to i8**
%_438 = load i8*, i8** %_437
%_439 = call i1 %_435(i8* %_430, i8* %_438)
store i1 %_439, i1* %ntb
%_440 = load i8*, i8** %p_node
%_441 = bitcast i8* %_440 to i8***
%_442 = load i8**, i8*** %_441
%_443 = getelementptr i8*, i8** %_442, i32 10
%_444 = load i8*, i8** %_443
%_445 = bitcast i8* %_444 to i1 (i8*,i1)*
%_446 = call i1 %_445(i8* %_440, i1 0)
store i1 %_446, i1* %ntb
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
%_447 = load i8*, i8** %c_node
%_448 = bitcast i8* %_447 to i8***
%_449 = load i8**, i8*** %_448
%_450 = getelementptr i8*, i8** %_449, i32 7
%_451 = load i8*, i8** %_450
%_452 = bitcast i8* %_451 to i1 (i8*)*
%_453 = call i1 %_452(i8* %_447)
br i1 %_453, label %tag_53, label %tag_54
tag_53:
%_454 = load i8*, i8** %c_node
%_455 = bitcast i8* %_454 to i8***
%_456 = load i8**, i8*** %_455
%_457 = getelementptr i8*, i8** %_456, i32 6
%_458 = load i8*, i8** %_457
%_459 = bitcast i8* %_458 to i1 (i8*,i32)*
%_460 = load i8*, i8** %c_node
%_461 = bitcast i8* %_460 to i8***
%_462 = load i8**, i8*** %_461
%_463 = getelementptr i8*, i8** %_462, i32 3
%_464 = load i8*, i8** %_463
%_465 = bitcast i8* %_464 to i8* (i8*)*
%_466 = call i8* %_465(i8* %_460)
%_467 = bitcast i8* %_466 to i8***
%_468 = load i8**, i8*** %_467
%_469 = getelementptr i8*, i8** %_468, i32 5
%_470 = load i8*, i8** %_469
%_471 = bitcast i8* %_470 to i32 (i8*)*
%_472 = call i32 %_471(i8* %_466)
%_473 = call i1 %_459(i8* %_454, i32 %_472)
store i1 %_473, i1* %ntb
%_474 = load i8*, i8** %c_node
store i8* %_474, i8** %p_node
%_475 = load i8*, i8** %c_node
%_476 = bitcast i8* %_475 to i8***
%_477 = load i8**, i8*** %_476
%_478 = getelementptr i8*, i8** %_477, i32 3
%_479 = load i8*, i8** %_478
%_480 = bitcast i8* %_479 to i8* (i8*)*
%_481 = call i8* %_480(i8* %_475)
store i8* %_481, i8** %c_node
br label %tag_52
tag_54:
%_482 = load i8*, i8** %p_node
%_483 = bitcast i8* %_482 to i8***
%_484 = load i8**, i8*** %_483
%_485 = getelementptr i8*, i8** %_484, i32 1
%_486 = load i8*, i8** %_485
%_487 = bitcast i8* %_486 to i1 (i8*,i8*)*
%_488 = getelementptr i8, i8* %this, i32 30
%_489 = bitcast i8* %_488 to i8**
%_490 = load i8*, i8** %_489
%_491 = call i1 %_487(i8* %_482, i8* %_490)
store i1 %_491, i1* %ntb
%_492 = load i8*, i8** %p_node
%_493 = bitcast i8* %_492 to i8***
%_494 = load i8**, i8*** %_493
%_495 = getelementptr i8*, i8** %_494, i32 10
%_496 = load i8*, i8** %_495
%_497 = bitcast i8* %_496 to i1 (i8*,i1)*
%_498 = call i1 %_497(i8* %_492, i1 0)
store i1 %_498, i1* %ntb
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
%_499 = load i8*, i8** %c_node
%_500 = bitcast i8* %_499 to i8***
%_501 = load i8**, i8*** %_500
%_502 = getelementptr i8*, i8** %_501, i32 8
%_503 = load i8*, i8** %_502
%_504 = bitcast i8* %_503 to i1 (i8*)*
%_505 = call i1 %_504(i8* %_499)
br i1 %_505, label %tag_56, label %tag_57
tag_56:
%_506 = load i8*, i8** %c_node
%_507 = bitcast i8* %_506 to i8***
%_508 = load i8**, i8*** %_507
%_509 = getelementptr i8*, i8** %_508, i32 6
%_510 = load i8*, i8** %_509
%_511 = bitcast i8* %_510 to i1 (i8*,i32)*
%_512 = load i8*, i8** %c_node
%_513 = bitcast i8* %_512 to i8***
%_514 = load i8**, i8*** %_513
%_515 = getelementptr i8*, i8** %_514, i32 4
%_516 = load i8*, i8** %_515
%_517 = bitcast i8* %_516 to i8* (i8*)*
%_518 = call i8* %_517(i8* %_512)
%_519 = bitcast i8* %_518 to i8***
%_520 = load i8**, i8*** %_519
%_521 = getelementptr i8*, i8** %_520, i32 5
%_522 = load i8*, i8** %_521
%_523 = bitcast i8* %_522 to i32 (i8*)*
%_524 = call i32 %_523(i8* %_518)
%_525 = call i1 %_511(i8* %_506, i32 %_524)
store i1 %_525, i1* %ntb
%_526 = load i8*, i8** %c_node
store i8* %_526, i8** %p_node
%_527 = load i8*, i8** %c_node
%_528 = bitcast i8* %_527 to i8***
%_529 = load i8**, i8*** %_528
%_530 = getelementptr i8*, i8** %_529, i32 4
%_531 = load i8*, i8** %_530
%_532 = bitcast i8* %_531 to i8* (i8*)*
%_533 = call i8* %_532(i8* %_527)
store i8* %_533, i8** %c_node
br label %tag_55
tag_57:
%_534 = load i8*, i8** %p_node
%_535 = bitcast i8* %_534 to i8***
%_536 = load i8**, i8*** %_535
%_537 = getelementptr i8*, i8** %_536, i32 2
%_538 = load i8*, i8** %_537
%_539 = bitcast i8* %_538 to i1 (i8*,i8*)*
%_540 = getelementptr i8, i8* %this, i32 30
%_541 = bitcast i8* %_540 to i8**
%_542 = load i8*, i8** %_541
%_543 = call i1 %_539(i8* %_534, i8* %_542)
store i1 %_543, i1* %ntb
%_544 = load i8*, i8** %p_node
%_545 = bitcast i8* %_544 to i8***
%_546 = load i8**, i8*** %_545
%_547 = getelementptr i8*, i8** %_546, i32 9
%_548 = load i8*, i8** %_547
%_549 = bitcast i8* %_548 to i1 (i8*,i1)*
%_550 = call i1 %_549(i8* %_544, i1 0)
store i1 %_550, i1* %ntb
ret i1 1
}

define i32 @Tree.Search(i8* %this, i32 %.v_key){
%v_key = alloca i32
store i32 %.v_key, i32* %v_key
%current_node = alloca i8*
store i8* null, i8** %current_node
%ifound = alloca i32
store i32 0, i32* %ifound
%cont = alloca i1
store i1 0, i1* %cont
%key_aux = alloca i32
store i32 0, i32* %key_aux
store i8* %this, i8** %current_node
store i1 1, i1* %cont
store i32 0, i32* %ifound
;WhileStatement
br label %tag_58
tag_58:
%_551 = load i1, i1* %cont
br i1 %_551, label %tag_59, label %tag_60
tag_59:
%_552 = load i8*, i8** %current_node
%_553 = bitcast i8* %_552 to i8***
%_554 = load i8**, i8*** %_553
%_555 = getelementptr i8*, i8** %_554, i32 5
%_556 = load i8*, i8** %_555
%_557 = bitcast i8* %_556 to i32 (i8*)*
%_558 = call i32 %_557(i8* %_552)
store i32 %_558, i32* %key_aux
%_559 = load i32, i32* %v_key
%_560 = load i32, i32* %key_aux
%_561 = icmp slt i32 %_559, %_560
;IfStatement
br i1 %_561, label %tag_61, label %tag_62
tag_61:
%_562 = load i8*, i8** %current_node
%_563 = bitcast i8* %_562 to i8***
%_564 = load i8**, i8*** %_563
%_565 = getelementptr i8*, i8** %_564, i32 8
%_566 = load i8*, i8** %_565
%_567 = bitcast i8* %_566 to i1 (i8*)*
%_568 = call i1 %_567(i8* %_562)
;IfStatement
br i1 %_568, label %tag_64, label %tag_65
tag_64:
%_569 = load i8*, i8** %current_node
%_570 = bitcast i8* %_569 to i8***
%_571 = load i8**, i8*** %_570
%_572 = getelementptr i8*, i8** %_571, i32 4
%_573 = load i8*, i8** %_572
%_574 = bitcast i8* %_573 to i8* (i8*)*
%_575 = call i8* %_574(i8* %_569)
store i8* %_575, i8** %current_node
br label %tag_66
tag_65:
store i1 0, i1* %cont
br label %tag_66
tag_66:
br label %tag_63
tag_62:
%_576 = load i32, i32* %key_aux
%_577 = load i32, i32* %v_key
%_578 = icmp slt i32 %_576, %_577
;IfStatement
br i1 %_578, label %tag_67, label %tag_68
tag_67:
%_579 = load i8*, i8** %current_node
%_580 = bitcast i8* %_579 to i8***
%_581 = load i8**, i8*** %_580
%_582 = getelementptr i8*, i8** %_581, i32 7
%_583 = load i8*, i8** %_582
%_584 = bitcast i8* %_583 to i1 (i8*)*
%_585 = call i1 %_584(i8* %_579)
;IfStatement
br i1 %_585, label %tag_70, label %tag_71
tag_70:
%_586 = load i8*, i8** %current_node
%_587 = bitcast i8* %_586 to i8***
%_588 = load i8**, i8*** %_587
%_589 = getelementptr i8*, i8** %_588, i32 3
%_590 = load i8*, i8** %_589
%_591 = bitcast i8* %_590 to i8* (i8*)*
%_592 = call i8* %_591(i8* %_586)
store i8* %_592, i8** %current_node
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
%_593 = load i32, i32* %ifound
ret i32 %_593
}

define i1 @Tree.Print(i8* %this){
%ntb = alloca i1
store i1 0, i1* %ntb
%current_node = alloca i8*
store i8* null, i8** %current_node
store i8* %this, i8** %current_node
%_594 = bitcast i8* %this to i8***
%_595 = load i8**, i8*** %_594
%_596 = getelementptr i8*, i8** %_595, i32 19
%_597 = load i8*, i8** %_596
%_598 = bitcast i8* %_597 to i1 (i8*,i8*)*
%_599 = load i8*, i8** %current_node
%_600 = call i1 %_598(i8* %this, i8* %_599)
store i1 %_600, i1* %ntb
ret i1 1
}

define i1 @Tree.RecPrint(i8* %this, i8* %.node){
%node = alloca i8*
store i8* %.node, i8** %node
%ntb = alloca i1
store i1 0, i1* %ntb
%_601 = load i8*, i8** %node
%_602 = bitcast i8* %_601 to i8***
%_603 = load i8**, i8*** %_602
%_604 = getelementptr i8*, i8** %_603, i32 8
%_605 = load i8*, i8** %_604
%_606 = bitcast i8* %_605 to i1 (i8*)*
%_607 = call i1 %_606(i8* %_601)
;IfStatement
br i1 %_607, label %tag_73, label %tag_74
tag_73:
%_608 = bitcast i8* %this to i8***
%_609 = load i8**, i8*** %_608
%_610 = getelementptr i8*, i8** %_609, i32 19
%_611 = load i8*, i8** %_610
%_612 = bitcast i8* %_611 to i1 (i8*,i8*)*
%_613 = load i8*, i8** %node
%_614 = bitcast i8* %_613 to i8***
%_615 = load i8**, i8*** %_614
%_616 = getelementptr i8*, i8** %_615, i32 4
%_617 = load i8*, i8** %_616
%_618 = bitcast i8* %_617 to i8* (i8*)*
%_619 = call i8* %_618(i8* %_613)
%_620 = call i1 %_612(i8* %this, i8* %_619)
store i1 %_620, i1* %ntb
br label %tag_75
tag_74:
store i1 1, i1* %ntb
br label %tag_75
tag_75:
%_621 = load i8*, i8** %node
%_622 = bitcast i8* %_621 to i8***
%_623 = load i8**, i8*** %_622
%_624 = getelementptr i8*, i8** %_623, i32 5
%_625 = load i8*, i8** %_624
%_626 = bitcast i8* %_625 to i32 (i8*)*
%_627 = call i32 %_626(i8* %_621)
call void (i32) @print_int(i32 %_627)
%_628 = load i8*, i8** %node
%_629 = bitcast i8* %_628 to i8***
%_630 = load i8**, i8*** %_629
%_631 = getelementptr i8*, i8** %_630, i32 7
%_632 = load i8*, i8** %_631
%_633 = bitcast i8* %_632 to i1 (i8*)*
%_634 = call i1 %_633(i8* %_628)
;IfStatement
br i1 %_634, label %tag_76, label %tag_77
tag_76:
%_635 = bitcast i8* %this to i8***
%_636 = load i8**, i8*** %_635
%_637 = getelementptr i8*, i8** %_636, i32 19
%_638 = load i8*, i8** %_637
%_639 = bitcast i8* %_638 to i1 (i8*,i8*)*
%_640 = load i8*, i8** %node
%_641 = bitcast i8* %_640 to i8***
%_642 = load i8**, i8*** %_641
%_643 = getelementptr i8*, i8** %_642, i32 3
%_644 = load i8*, i8** %_643
%_645 = bitcast i8* %_644 to i8* (i8*)*
%_646 = call i8* %_645(i8* %_640)
%_647 = call i1 %_639(i8* %this, i8* %_646)
store i1 %_647, i1* %ntb
br label %tag_78
tag_77:
store i1 1, i1* %ntb
br label %tag_78
tag_78:
ret i1 1
}

define i32 @Tree.accept(i8* %this, i8* %.v){
%v = alloca i8*
store i8* %.v, i8** %v
%nti = alloca i32
store i32 0, i32* %nti
call void (i32) @print_int(i32 333)
%_648 = load i8*, i8** %v
%_649 = bitcast i8* %_648 to i8***
%_650 = load i8**, i8*** %_649
%_651 = getelementptr i8*, i8** %_650, i32 0
%_652 = load i8*, i8** %_651
%_653 = bitcast i8* %_652 to i32 (i8*,i8*)*
%_654 = call i32 %_653(i8* %_648, i8* %this)
store i32 %_654, i32* %nti
ret i32 0
}

define i32 @Visitor.visit(i8* %this, i8* %.n){
%n = alloca i8*
store i8* %.n, i8** %n
%nti = alloca i32
store i32 0, i32* %nti
%_655 = load i8*, i8** %n
%_656 = bitcast i8* %_655 to i8***
%_657 = load i8**, i8*** %_656
%_658 = getelementptr i8*, i8** %_657, i32 7
%_659 = load i8*, i8** %_658
%_660 = bitcast i8* %_659 to i1 (i8*)*
%_661 = call i1 %_660(i8* %_655)
;IfStatement
br i1 %_661, label %tag_79, label %tag_80
tag_79:
%_662 = getelementptr i8, i8* %this, i32 16
%_663 = bitcast i8* %_662 to i8**
%_664 = load i8*, i8** %n
%_665 = bitcast i8* %_664 to i8***
%_666 = load i8**, i8*** %_665
%_667 = getelementptr i8*, i8** %_666, i32 3
%_668 = load i8*, i8** %_667
%_669 = bitcast i8* %_668 to i8* (i8*)*
%_670 = call i8* %_669(i8* %_664)
store i8* %_670, i8** %_663
%_671 = getelementptr i8, i8* %this, i32 16
%_672 = bitcast i8* %_671 to i8**
%_673 = load i8*, i8** %_672
%_674 = bitcast i8* %_673 to i8***
%_675 = load i8**, i8*** %_674
%_676 = getelementptr i8*, i8** %_675, i32 20
%_677 = load i8*, i8** %_676
%_678 = bitcast i8* %_677 to i32 (i8*,i8*)*
%_679 = call i32 %_678(i8* %_673, i8* %this)
store i32 %_679, i32* %nti
br label %tag_81
tag_80:
store i32 0, i32* %nti
br label %tag_81
tag_81:
%_680 = load i8*, i8** %n
%_681 = bitcast i8* %_680 to i8***
%_682 = load i8**, i8*** %_681
%_683 = getelementptr i8*, i8** %_682, i32 8
%_684 = load i8*, i8** %_683
%_685 = bitcast i8* %_684 to i1 (i8*)*
%_686 = call i1 %_685(i8* %_680)
;IfStatement
br i1 %_686, label %tag_82, label %tag_83
tag_82:
%_687 = getelementptr i8, i8* %this, i32 8
%_688 = bitcast i8* %_687 to i8**
%_689 = load i8*, i8** %n
%_690 = bitcast i8* %_689 to i8***
%_691 = load i8**, i8*** %_690
%_692 = getelementptr i8*, i8** %_691, i32 4
%_693 = load i8*, i8** %_692
%_694 = bitcast i8* %_693 to i8* (i8*)*
%_695 = call i8* %_694(i8* %_689)
store i8* %_695, i8** %_688
%_696 = getelementptr i8, i8* %this, i32 8
%_697 = bitcast i8* %_696 to i8**
%_698 = load i8*, i8** %_697
%_699 = bitcast i8* %_698 to i8***
%_700 = load i8**, i8*** %_699
%_701 = getelementptr i8*, i8** %_700, i32 20
%_702 = load i8*, i8** %_701
%_703 = bitcast i8* %_702 to i32 (i8*,i8*)*
%_704 = call i32 %_703(i8* %_698, i8* %this)
store i32 %_704, i32* %nti
br label %tag_84
tag_83:
store i32 0, i32* %nti
br label %tag_84
tag_84:
ret i32 0
}

define i32 @MyVisitor.visit(i8* %this, i8* %.n){
%n = alloca i8*
store i8* %.n, i8** %n
%nti = alloca i32
store i32 0, i32* %nti
%_705 = load i8*, i8** %n
%_706 = bitcast i8* %_705 to i8***
%_707 = load i8**, i8*** %_706
%_708 = getelementptr i8*, i8** %_707, i32 7
%_709 = load i8*, i8** %_708
%_710 = bitcast i8* %_709 to i1 (i8*)*
%_711 = call i1 %_710(i8* %_705)
;IfStatement
br i1 %_711, label %tag_85, label %tag_86
tag_85:
%_712 = getelementptr i8, i8* %this, i32 16
%_713 = bitcast i8* %_712 to i8**
%_714 = load i8*, i8** %n
%_715 = bitcast i8* %_714 to i8***
%_716 = load i8**, i8*** %_715
%_717 = getelementptr i8*, i8** %_716, i32 3
%_718 = load i8*, i8** %_717
%_719 = bitcast i8* %_718 to i8* (i8*)*
%_720 = call i8* %_719(i8* %_714)
store i8* %_720, i8** %_713
%_721 = getelementptr i8, i8* %this, i32 16
%_722 = bitcast i8* %_721 to i8**
%_723 = load i8*, i8** %_722
%_724 = bitcast i8* %_723 to i8***
%_725 = load i8**, i8*** %_724
%_726 = getelementptr i8*, i8** %_725, i32 20
%_727 = load i8*, i8** %_726
%_728 = bitcast i8* %_727 to i32 (i8*,i8*)*
%_729 = call i32 %_728(i8* %_723, i8* %this)
store i32 %_729, i32* %nti
br label %tag_87
tag_86:
store i32 0, i32* %nti
br label %tag_87
tag_87:
%_730 = load i8*, i8** %n
%_731 = bitcast i8* %_730 to i8***
%_732 = load i8**, i8*** %_731
%_733 = getelementptr i8*, i8** %_732, i32 5
%_734 = load i8*, i8** %_733
%_735 = bitcast i8* %_734 to i32 (i8*)*
%_736 = call i32 %_735(i8* %_730)
call void (i32) @print_int(i32 %_736)
%_737 = load i8*, i8** %n
%_738 = bitcast i8* %_737 to i8***
%_739 = load i8**, i8*** %_738
%_740 = getelementptr i8*, i8** %_739, i32 8
%_741 = load i8*, i8** %_740
%_742 = bitcast i8* %_741 to i1 (i8*)*
%_743 = call i1 %_742(i8* %_737)
;IfStatement
br i1 %_743, label %tag_88, label %tag_89
tag_88:
%_744 = getelementptr i8, i8* %this, i32 8
%_745 = bitcast i8* %_744 to i8**
%_746 = load i8*, i8** %n
%_747 = bitcast i8* %_746 to i8***
%_748 = load i8**, i8*** %_747
%_749 = getelementptr i8*, i8** %_748, i32 4
%_750 = load i8*, i8** %_749
%_751 = bitcast i8* %_750 to i8* (i8*)*
%_752 = call i8* %_751(i8* %_746)
store i8* %_752, i8** %_745
%_753 = getelementptr i8, i8* %this, i32 8
%_754 = bitcast i8* %_753 to i8**
%_755 = load i8*, i8** %_754
%_756 = bitcast i8* %_755 to i8***
%_757 = load i8**, i8*** %_756
%_758 = getelementptr i8*, i8** %_757, i32 20
%_759 = load i8*, i8** %_758
%_760 = bitcast i8* %_759 to i32 (i8*,i8*)*
%_761 = call i32 %_760(i8* %_755, i8* %this)
store i32 %_761, i32* %nti
br label %tag_90
tag_89:
store i32 0, i32* %nti
br label %tag_90
tag_90:
ret i32 0
}


