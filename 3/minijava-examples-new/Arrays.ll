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

define i32 @main() {
%x = alloca i32*
store i32* null, i32** %x
%_0 = add i32 1, 2
%_1 = icmp sge i32 %_0, 1
br i1 %_1, label %tag_1, label %tag_0
tag_0:
call void @throw_nsz()
br label %tag_1
tag_1:
%_2 = call i8* @calloc(i32 %_0, i32 4)
%_3 = bitcast i8* %_2 to i32*
store i32 2, i32* %_3
store i32* %_3, i32** %x
%_4 = load i32*, i32** %x
%_5 = load i32, i32* %_4
%_6 = icmp sge i32 0, 0
%_7 = icmp slt i32 0, %_5
%_8 = and i1 %_6, %_7
br i1 %_8, label %tag_3, label %tag_2
tag_2:
call void @throw_oob()
br label %tag_3
tag_3:
%_9 = add i32 1, 0
%_10 = getelementptr i32, i32* %_4, i32 %_9
store i32 1, i32* %_10
%_11 = load i32*, i32** %x
%_12 = load i32, i32* %_11
%_13 = icmp sge i32 1, 0
%_14 = icmp slt i32 1, %_12
%_15 = and i1 %_13, %_14
br i1 %_15, label %tag_5, label %tag_4
tag_4:
call void @throw_oob()
br label %tag_5
tag_5:
%_16 = add i32 1, 1
%_17 = getelementptr i32, i32* %_11, i32 %_16
store i32 2, i32* %_17
%_19 = load i32*, i32** %x
%_20 = load i32, i32* %_19
%_21 = icmp sge i32 0, 0
%_22 = icmp slt i32 0, %_20
%_23 = and i1 %_21, %_22
br i1 %_23, label %tag_7, label %tag_6
tag_6:
call void @throw_oob()
br label %tag_7
tag_7:
%_24 = add i32 1, 0
%_25 = getelementptr i32, i32* %_19, i32 %_24
%_26 = load i32, i32* %_25
%_27 = load i32*, i32** %x
%_28 = load i32, i32* %_27
%_29 = icmp sge i32 1, 0
%_30 = icmp slt i32 1, %_28
%_31 = and i1 %_29, %_30
br i1 %_31, label %tag_9, label %tag_8
tag_8:
call void @throw_oob()
br label %tag_9
tag_9:
%_32 = add i32 1, 1
%_33 = getelementptr i32, i32* %_27, i32 %_32
%_34 = load i32, i32* %_33
%_18 = add i32 %_26, %_34
call void (i32) @print_int(i32 %_18)
ret i32 0
}


