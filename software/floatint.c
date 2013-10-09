#include<stdio.h>
#include<stdlib.h>
#include<stdint.h>

typedef union floatint{
	struct{
		unsigned int ex: 23;
	       	unsigned int fr :  8;
		unsigned int si :  1;
	};
	uint32_t u;
	float f;
}ufi;

void print_bit(ufi u32){//bit情報の表示
	int i=31;
	while(i>=0){
		printf("%d",((u32.u >> i)&0x00000001));
		if (i%4==0/*i==31||i==23*/) printf(" ");
		i--;
	}
	printf("\n");
}

ufi fadd(ufi a, ufi b){
	ufi r;
	ufi q;
	int x;
	int i;
	uint32_t ee;
//	print_bit(a);print_bit(b);printf("大きい方をaに格納\n");
	if ((a.u << 1)<(b.u <<1)){r.u=b.u; b.u=a.u; a.u=r.u;}//絶対値が大きい方がaになる


//	print_bit(a);print_bit(b);printf("指数の差だけ右にシフト\n");
	x=((a.u&0x7FFFFFFF)>>23) - ((b.u&0x7FFFFFFF)>>23) -1;
//	printf("x=%d\n",x);
	if(x<0) r.u=(((b.u & 0x007FFFFF)^0x00800000) << (-x));
	else {
		if(x<32) r.u=(((b.u & 0x007FFFFF)^0x00800000) >> x);//指数の差だけ右へシフト
		else r.u=0;
	} 
	q.u=a.u;
	q.si=0;
	q.fr=0x01;
	q.u=q.u << 1;



//	print_bit(q);print_bit(r);printf("演算\n");
	if(a.si==b.si) ee=q.u+r.u; else ee=q.u-r.u; //演算

	i=25;
	while((ee&(0x00000001<<i))==0) {i--;}
	i=i-23;


	r.si=a.si;
	r.fr=a.fr+i-1;

//	printf("i=%d, ee=",i);q.u=0x0;q.u=ee;print_bit(q);
	if(i<0) {
		r.ex=(ee<<(-i))&0x007FFFFF;
	}
	else {
		if (i==2) {ee=ee+4*((ee&0x2)&((ee&0x1)^(ee&0x3)));}
		else {
			if (i==1) {ee=ee+2*((ee&0x1)&(ee&0x2));}
		}
		r.ex=(ee>>(i))&0x007FFFFF;
	}



	return(r);
}

int main() {
	int n=0;
	int i=0;
	ufi a;
	ufi b;
	ufi r;
	ufi q;
	while(n<10000){//0018
		a.u=(float)(rand());
		b.u=(float)(rand());
		r.f=a.f+b.f;
		q=fadd(a,b);
		if(r.u==q.u){i++;}
		else{
			print_bit(a);print_bit(b);
			printf("WRONG_ANSWER = ");print_bit(q);
			printf("CORRECT_ANSWER:");print_bit(r);
			printf("\n\n");
		}
		n++;
	}
	printf("RESULT:%f%%",(100*((float)i/(float)n)));
	return(0);
}
