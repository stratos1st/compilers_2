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

@.A_vtable = global [1 x i8*] [ 
	i8* bitcast (i32 (i8*)* @A.getData to i8*)
]

define i32 @main() {
%i = alloca i32
store i32 0, i32* %i
%j = alloca i32
store i32 0, i32* %j
store i32 10, i32* %i
store i32 20, i32* %j
%_3 = add i32 1, 2
%_2 = add i32 %_3, 3
%_4 = load i32, i32* %i
%_1 = add i32 %_2, %_4
%_5 = load i32, i32* %j
%_0 = add i32 %_1, %_5
call void (i32) @print_int(i32 %_0)
%_9 = mul i32 1, 2
%_8 = mul i32 %_9, 3
%_10 = load i32, i32* %i
%_7 = mul i32 %_8, %_10
%_11 = load i32, i32* %j
%_6 = mul i32 %_7, %_11
call void (i32) @print_int(i32 %_6)
%_15 = mul i32 1, 2
%_14 = mul i32 %_15, 3
%_16 = load i32, i32* %i
%_13 = sub i32 %_14, %_16
%_17 = load i32, i32* %j
%_12 = add i32 %_13, %_17
call void (i32) @print_int(i32 %_12)
%_22 = call i8* @calloc(i32 1, i32 8)
%_23 = bitcast i8* %_22 to i8***
%_24 = getelementptr [1 x i8*], [1 x i8*]* @.A_vtable, i32 0, i32 0
store i8** %_24, i8*** %_23
%_25 = bitcast i8* %_22 to i8***
%_26 = load i8**, i8*** %_25
%_27 = getelementptr i8*, i8** %_26, i32 0
%_28 = load i8*, i8** %_27
%_29 = bitcast i8* %_28 to i32 (i8*)*
%_30 = call i32 %_29(i8* %_22)
%_21 = mul i32 1, %_30
%_20 = mul i32 %_21, 3
%_31 = load i32, i32* %i
%_19 = sub i32 %_20, %_31
%_18 = add i32 %_19, 20
call void (i32) @print_int(i32 %_18)
ret i32 0
}

define i32 @A.getData(i8* %this){
ret i32 100
}


