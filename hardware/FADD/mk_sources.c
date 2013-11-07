#include<stdio.h>
#include<stdlib.h>
#include<stdint.h>
#include<time.h>

typedef union floatint{
	struct{
		unsigned int ex : 23;
		unsigned int fr :  8;
		unsigned int si :  1;
	};
	uint32_t u;
	float f;
}ufi;

void fprint_bit(ufi u32,FILE *fp){//bit情報の表示
	int i=31;
	while(i>=0){
		fprintf(fp,"%d",((u32.u >> (i))&0x00000001));
		i--;
	}
	fprintf(fp,"\n");
}

int main(int argc, char *argv[]){
	int cases;
	int i=0;
	FILE *afile;
	FILE *bfile;
	FILE *answerfile;
	ufi a;
	ufi b;
	ufi r;
	if (argc <= 2) srand((unsigned) time(NULL));
	cases=(atoi(argv[1]));
	afile=fopen("alist.txt","w");
	bfile=fopen("blist.txt","w");
	answerfile=fopen("faddanswer.txt","w");
	while(i<cases){
	a.f=(float)rand();
	b.f=(float)rand();
	r.f=a.f+b.f;
	fprint_bit(a,afile);
	fprint_bit(b,bfile);
	fprint_bit(r,answerfile);
	i++;
	}
	fclose(afile);fclose(bfile);fclose(answerfile);
	return(0);
}
