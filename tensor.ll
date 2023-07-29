; ModuleID = 'Practice'
source_filename = "Practice"
target triple = "x86_64-apple-macosx12.0.0"

; @param 0 = number of dimensions of the tensor
; @param 1 = pointer to array that describes shape of tensor
; @param 2 = pointer to tensor data 
%Tensor = type { i32, ptr, ptr }

@str1 = private constant [4 x i8] c"%d \00" 
@x = private constant [2 x i8] c"x\00"
@newline = private constant [2 x i8] c"\0A\00"

define i32 @main(){

    ; instantiate tensor
    %tensor1 = alloca %Tensor, align 8

    ; store the number of dimensions 
    store i32 2, ptr %tensor1, align 8

    ; initialize the dimensional data
    %dims = alloca [2 x i32], align 8
    store i32 2, ptr %dims, align 8
    %1 = getelementptr inbounds i32, ptr %dims, i32 1
    store i32 3, ptr %1, align 8

    ; store the list of dimensions in the struct
    %2 = getelementptr inbounds %Tensor, ptr %tensor1, i64 0, i32 1
    store ptr %dims, ptr %2, align 8


    ; initialize data
    %data_t1 = alloca [2 x [3 x i32]], align 8
    ; Store values in the array elements
    ; Initialize the elements of the 2D array
    %row0 = getelementptr [2 x [3 x float]], [2 x [3 x float]]* %data_t1, i32 0, i32 0
    store [3 x float] [float 1.0, float 2.0, float 3.0], [3 x float]* %row0
    %row1 = getelementptr [2 x [3 x float]], [2 x [3 x float]]* %data_t1, i32 0, i32 1
    store [3 x float] [float 4.0, float 5.0, float 6.0], [3 x float]* %row1
    ; store the data in the struct 
    %3 = getelementptr inbounds %Tensor, ptr %tensor1, i32 2
    store ptr %data_t1, ptr %3, align 8 

    %dims_index_addr = load ptr , ptr %2, align 8 ; get the pointer to the first element of the dimensions array
    %dims_index_addr_int = ptrtoint ptr %dims_index_addr to i64 ; convert this address to i64
    %data_index_addr = ptrtoint ptr %data_t1 to i64
    call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str1), i64 %dims_index_addr_int)

    
 ;   call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str1), i64 %data_index_addr)
    call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @newline)) 
    call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @newline)) 


    call void @printTensor(ptr %tensor1)
    ret i32 0
}

; @param %tensor = the tensor whose elements we wish to print 
define void @printTensor(ptr %tensor) {

entry:
  %0 = getelementptr inbounds %Tensor, ptr %tensor, i64 0, i32 0
  %num_dims = load i32, ptr %0

  
  %1 = getelementptr inbounds %Tensor, ptr %tensor, i64 0, i32 1 ; get pointer to pointer start of dimensions array 
  %2 = load ptr, ptr %1 ; get pointer to start of dimensions array
  %dims_index_addr = ptrtoint ptr %2 to i64
  %val = load i32, ptr %2
  

  ;call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str1), i32 %num_dims)
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str1), i64 %dims_index_addr)
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @newline))



    ret void
}

declare i32 @printf(i8*, ...)