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

@.Test_vtable = global [2 x i8*] [ 
	i8* bitcast (i32 (i8*)* @Test.start to i8*),
	i8* bitcast (i1 (i8*)* @Test.next to i8*)
]

define i32 @main() {
%_0 = call i8* @calloc(i32 1, i32 17)
%_1 = bitcast i8* %_0 to i8***
%_2 = getelementptr [2 x i8*], [2 x i8*]* @.Test_vtable, i32 0, i32 0
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

define i32 @Test.start(i8* %this){
%_9 = getelementptr i8, i8* %this, i32 8
%_10 = bitcast i8* %_9 to i8**
%_11 = call i8* @calloc(i32 1, i32 17)
%_12 = bitcast i8* %_11 to i8***
%_13 = getelementptr [2 x i8*], [2 x i8*]* @.Test_vtable, i32 0, i32 0
store i8** %_13, i8*** %_12
store i8* %_11, i8** %_10
%_14 = getelementptr i8, i8* %this, i32 16
%_15 = bitcast i8* %_14 to i1*
%_16 = getelementptr i8, i8* %this, i32 8
%_17 = bitcast i8* %_16 to i8**
%_18 = load i8*, i8** %_17
%_19 = bitcast i8* %_18 to i8***
%_20 = load i8**, i8*** %_19
%_21 = getelementptr i8*, i8** %_20, i32 1
%_22 = load i8*, i8** %_21
%_23 = bitcast i8* %_22 to i1 (i8*)*
%_24 = call i1 %_23(i8* %_18)
store i1 %_24, i1* %_15
ret i32 0
}

define i1 @Test.next(i8* %this){
%b2 = alloca i1
store i1 0, i1* %b2
;AndExpression
;AndExpression
br i1 1, label %tag_1, label %tag_0
tag_0:
br label %tag_3
tag_1:
%_25 = icmp slt i32 7, 8
br label %tag_2
tag_2:
br label %tag_3
tag_3:
%_26 = phi i1  [ 0, %tag_0 ], [ %_25, %tag_2 ]
br i1 %_26, label %tag_5, label %tag_4
tag_4:
br label %tag_7
tag_5:
%_27 = getelementptr i8, i8* %this, i32 16
%_28 = bitcast i8* %_27 to i1*
%_29 = load i1, i1* %_28
%_30 = xor i1 1, %_29
br label %tag_6
tag_6:
br label %tag_7
tag_7:
%_31 = phi i1  [ 0, %tag_4 ], [ %_30, %tag_6 ]
store i1 %_31, i1* %b2
%_32 = load i1, i1* %b2
ret i1 %_32
}


