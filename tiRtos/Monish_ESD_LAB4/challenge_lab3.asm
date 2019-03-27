	.global operation

operation:
			MOVS r5,r2
			BMI negative_c
			MOVS r5,r1
			BMI negative_b
loop1:
			MOV r4,r1
			SUBS r5,r1,r2
			MOV r1,r5
			BPL	loop1
			B multiply
negative_b:
loop2:
			ADDS r5,r1,r2
			MOV r1,r5
			BMI	loop2
			MOV r4,r1
			B multiply
negative_c:
			MOVS r5,r1
			BMI both_negative
loop3:
			ADDS r5,r1,r2
			MOV r1,r5
			BPL loop3
			MOV r4,r1
			B multiply
both_negative:
loop4:
			MOV r4,r1
			SUBS r5,r1,r2
			MOV r1,r5
			BMI loop4
multiply:
			MUL	r1,r0,r4
			MOV r0,r1
	        BX lr
