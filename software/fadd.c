#include<stdio.h>
#include<stdlib.h>
#include<stdint.h>
#include<time.h>
#include<string.h>

typedef union floatint{
	struct{
		unsigned int ex : 23;
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

ufi fadd(ufi a, ufi b,int mode){
	ufi r;
	ufi q;
	int x=0;
	int i=0;
	int round=0;
	uint32_t ee=0;
	if (mode==1) {print_bit(a);print_bit(b);printf("大きい方をaに格納\n");}
	if ((a.u << 1)<(b.u <<1)){r.u=b.u; b.u=a.u; a.u=r.u;}//絶対値が大きい方がaになる


	if(mode==1){print_bit(a);print_bit(b);printf("指数の差だけ右にシフト\n");}
	x=((a.u&0x7FFFFFFF)>>23) - ((b.u&0x7FFFFFFF)>>23) -1;
	if(mode==1){printf("x=%d\n",x);}
	if(x<0) r.u=(((b.u & 0x007FFFFF)|0x00800000) << (-x));
	else {
		if(x<24) {
			r.u=(((b.u & 0x007FFFFF)|0x00800000) >> x);//指数の差だけ右へシフト
			round=(b.u & (0x007FFFFF >> (23-x) ))>0;}
		else {r.u=0; round=1;}
	}
	q.u=a.u;
	q.si=0;
	q.fr=0x01;
	q.u=q.u << 1;



	if(mode==1){print_bit(q);print_bit(r);printf("演算\n");}
	if(a.si==b.si) ee=q.u+r.u; else ee=q.u-r.u; //演算

	i=25;
	while((ee&(0x00000001<<i))==0) {i--;}
	i=i-23;


	r.si=a.si;
	if (a.fr<=1-i) r.fr=0; else r.fr=a.fr+i-1;
	if(mode==1){
		printf("i=%d\n",i);
		printf("ee=            ");q.u=0x0;q.u=ee;print_bit(q);
	}
	if(i<=0) {
		r.ex=(ee<<(-i))&0x007FFFFF;
	}
	else {
		if (i==2) {ee=ee+4*(((ee >> 1)&0x1)&((ee&0x1)|((ee >> 2)&0x1)|round ));}
		else {
			if (i==1) 
			{
				if(a.si==b.si) ee=ee+2*((ee&0x1)&( ((ee >> 1)&0x1)|round ));
				else           ee=ee+2*((ee&0x1)&( ((ee >> 1)&0x1)&~(round) )); 
			}
		}
		if((ee>>i )>=0x1000000){r.fr=r.fr+1;r.ex=0; }
		else r.ex=(ee>>(i))&0x007FFFFF;
	}
	if (r.fr==0xFF) r.ex=0;


	return(r);
}

int main(int argc, char *argv[]) {
	int n=0;
	int i=0;
	ufi a;
	ufi b;
	ufi r;
	if (argc > 1) srand((unsigned) time(NULL));
	ufi q;
	while(n<100000){//0018
		a.u=/*0x8506BF00;//1000 0101 0000 0110 1011 1111 0000 0000*/ -(float)rand();
		b.u=/*0x030C859C;//0000 0011 0000 1100 1000 0101 1001 1100*/ (float)rand();  
		r.f=a.f+b.f;
		q=fadd(a,b,0);
		if(r.u==q.u||(r.fr==0&&q.fr==0)||(r.fr==0xFF&&q.fr==0xFF)){i++;}
		else{
			if((a.fr!=0&&b.fr!=0&&a.fr!=0xFF&&b.fr!=0xFF)){
				fadd(a,b,1);
				printf("WRONG_ANSWER = ");print_bit(q);
				printf("CORRECT_ANSWER:");print_bit(r);
				printf("\n\n");
			}
			else{i++;}
		}
		n++;
	}
	printf("RESULT:%f%%\n",(100*((float)i/(float)n)));
	return(0);
}


/**MEMO**
  0000 1100 1111 1111 1101 0000 1111 0000 
  0000 0111 1011 1100 0011 1111 1000 0000 
 */
