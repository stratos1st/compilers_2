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
	i8* bitcast (i8* (i8*)* @Test.next to i8*)
]

define i32 @main() {
%_0 = call i8* @calloc(i32 1, i32 24)
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
%_9 = getelementptr i8, i8* %this, i32 16
%_10 = bitcast i8* %_9 to i32**
%_11 = add i32 1, 10
%_12 = icmp sge i32 %_11, 1
br i1 %_12, label %tag_1, label %tag_0
tag_0:
call void @throw_nsz()
br label %tag_1
tag_1:
%_13 = call i8* @calloc(i32 %_11, i32 4)
%_14 = bitcast i8* %_13 to i32*
store i32 10, i32* %_14
store i32* %_14, i32** %_10
%_15 = getelementptr i8, i8* %this, i32 8
%_16 = bitcast i8* %_15 to i8**
%_17 = call i8* @calloc(i32 1, i32 24)
%_18 = bitcast i8* %_17 to i8***
%_19 = getelementptr [2 x i8*], [2 x i8*]* @.Test_vtable, i32 0, i32 0
store i8** %_19, i8*** %_18
store i8* %_17, i8** %_16
%_20 = getelementptr i8, i8* %this, i32 8
%_21 = bitcast i8* %_20 to i8**
%_22 = getelementptr i8, i8* %this, i32 8
%_23 = bitcast i8* %_22 to i8**
%_24 = load i8*, i8** %_23
%_25 = bitcast i8* %_24 to i8***
%_26 = load i8**, i8*** %_25
%_27 = getelementptr i8*, i8** %_26, i32 1
%_28 = load i8*, i8** %_27
%_29 = bitcast i8* %_28 to i8* (i8*)*
%_30 = call i8* %_29(i8* %_24)
%_31 = bitcast i8* %_30 to i8***
%_32 = load i8**, i8*** %_31
%_33 = getelementptr i8*, i8** %_32, i32 1
%_34 = load i8*, i8** %_33
%_35 = bitcast i8* %_34 to i8* (i8*)*
%_36 = call i8* %_35(i8* %_30)
store i8* %_36, i8** %_21
ret i32 0
}

define i8* @Test.next(i8* %this){
%_37 = getelementptr i8, i8* %this, i32 8
%_38 = bitcast i8* %_37 to i8**
%_39 = call i8* @calloc(i32 1, i32 24)
%_40 = bitcast i8* %_39 to i8***
%_41 = getelementptr [2 x i8*], [2 x i8*]* @.Test_vtable, i32 0, i32 0
store i8** %_41, i8*** %_40
store i8* %_39, i8** %_38
%_42 = getelementptr i8, i8* %this, i32 8
%_43 = bitcast i8* %_42 to i8**
%_44 = load i8*, i8** %_43
ret i8* %_44
}


