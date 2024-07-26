%{
#include "y.tab.h"
#include <string.h>
void yyerror (char *s);
int yylex();
char IDHolder[256];
int CanvasXVar;
int CanvasYVar;
int CursorXVar;
int CursorYVar;
int *VarCursor;
int NumberOfStructures = 0;
int value;
int lock1 = 0;
int lock2 = 0;
int RenewLock = 0;
int RenewHold=0;
int DrawingSectionLock = 0;
int kilit;
int renewPos;
int paintLock =0;
int paintPos;
int renewPos;
int holdCurserX=0;
int holdCurserY=0;
int paintSection=0;
int posXHolder[100];
int posYHolder[100];
char nameHolder[100][100];
int indexx1=0;
int indexx2=0;
int brushController=0;
int counter=0;
int operatorCheck=0;
char first;
int hold;
int sayac=0;

char **canvas;

struct Brushes {
  char *Name;
  int X;
  int Y;
};

struct Brushes arrOfBrushes[100];

%}

%%


; 					{
						
						return Semicolon;
					}

: 					{
						
						return colon;
					}

, 					{
						
 						return Comma;
					}

PROGRAM 				{
						for(int k = 0; k < 100; k++){
							posXHolder[k] = 1;
							posYHolder[k] = 1;
						}
						return programIdentifier;
					}

CANVAS-INIT-SECTION 			{
						return Canvas_Init_Section_Identifier;
					}

BRUSH-DECLARATION-SECTION 		{
						
						canvas = (char **) malloc(CanvasXVar * sizeof(char *));
						for (int i = 0; i < CanvasXVar; i++) {
							canvas[i] = (char *) malloc(CanvasYVar * sizeof(char));
						}
						for (int i = 0; i < CanvasXVar; i++) {
							for (int j = 0; j < CanvasYVar; j++) {
								canvas[i][j] = ' ';
							}
						}
						brushController=-1; 
						return Brush_Declaration_Section_Identifier;
					}


	
DRAWING-SECTION 			{
						
						brushController = 0; 
						DrawingSectionLock = 1;
						return Drawing_Section_Identifier;
					}

CONST 					{
						
						return Const_Identifier;
					}
					
CanvasX 				{
						
						VarCursor = &CanvasXVar;
						return CanvasX;
					}

CanvasY 				{
						
						VarCursor = &CanvasYVar; 
						return CanvasY;
					}

CursorX 				{
						
						holdCurserX=-1;
						if(holdCurserY==-1){
						first='Y';
						} 
						else{
						first='X';
						}
						VarCursor = &CursorXVar; 
						return CursorX;
					}

CursorY 				{
						
						VarCursor = &CursorYVar;
						if(holdCurserX==-1){
						first='X';
						}
						else{
						first='Y';
						}  
						holdCurserY=-1;
						return CursorY;
					}

BRUSH 					{
						
						
						return Brush_Identifier;
					}

RENEW-BRUSH 				{
						
						RenewLock = 1;
						RenewHold = -1;
						kilit=99;
						return RENEW_BRUSH_IDENTIFIER;
					}

PAINT-CANVAS				{
						paintLock = 1;
						
						paintSection=-1;
						return PAINT_CANVAS_IDENTIFIER;
					}
					
EXHIBIT-CANVAS 				{			
        								
								for (int i = 0; i < CanvasYVar; i++) {
        								for (int j = 0; j < CanvasXVar; j++) {
            									printf("%c", canvas[i][j]);
        								}
        									printf("\n");
    											  		}
								
        											  
       										
								
							
						return exhibitCanvasIdentifier;
					}		

= 					{
						
						return Equals;
					}

MOVE					{
						
						return MOVE_IDENTIFIER;
					}

TO					{
						
						return TO;
					}

PLUS					{
						
						operatorCheck=1; 
						return PLUS;
					} 

MINUS					{	
						
						operatorCheck=-1;
						return MINUS;
					}	 

[a-zA-Z]+[a-zA-Z0-9]+			{
						if(lock1 == 0){
							strcpy(IDHolder, yytext); 
							
							lock1 = lock1 + 1;
						} 
						else if(DrawingSectionLock == 0){			
							arrOfBrushes[NumberOfStructures].Name = yytext;
							strcpy(nameHolder[indexx1],yytext);
							indexx1++;
						}
						else if(RenewLock == 1 && kilit==99){
							for(int i=0;i<NumberOfStructures;i++){							
								if (strstr(arrOfBrushes[i].Name,yytext) != NULL) {
									renewPos=i;
									break;
								}			
							}
							kilit=0;
						}
						if(indexx1 - indexx2 >1){
							indexx2++;	
						}
							
						if(paintSection==-1){
								
								for(int i=0;i<indexx1;i++){							
								if (strcmp(nameHolder[i],yytext) == 0) {
									paintPos=i;
									break;
								}		
							}
								for(int i=0;i<indexx1;i++){							
								if (strcmp(nameHolder[i],yytext) == 0) {
									sayac++;
								}		
							}	
								if(sayac==0){
								printf("Use of undeclared variable in statements.");
								return 0;
								}						
								else{
								for(int i=CursorYVar;i<CursorYVar+posXHolder[paintPos];i++){
									for(int j=CursorXVar;j<CursorXVar+posYHolder[paintPos];j++){
										canvas[i][j]='*';
																   }							
														           }
								sayac=0;							           
								}
								
							
						paintSection=0;					
						}
						if(RenewHold==-1){
						for(int i=0;i<indexx1;i++){							
								if (strcmp(nameHolder[i],yytext) == 0) {
									renewPos=i;
									break;
								}			
							}
						}					
						return ID;	
					}

[0-9]+ 				{		

						value = atoi(yytext);
						if(lock2 < 4){
							if(lock2 < 2){
								if(value<5 || value>200){
									printf("Given value is not in valid ranges(5-200). Value is setted to 100.\n");
									value=100;												
								}
							}				
							*VarCursor = value;
							lock2 = lock2 + 1;
						} 
						if(brushController==-1 && counter%2==0){
							posXHolder[indexx2]=value;
							counter++;
						}
						else if(brushController==-1 && counter%2==1){
							posYHolder[indexx2]=value;
							counter++;
							indexx2++;
													
						}
						
						if(first=='X' && operatorCheck==1 && holdCurserY==0){
							CursorXVar=CursorXVar+value;
							if(CursorXVar>CanvasXVar-1){
								printf("Cursor moved out of the Canvas. Cursor will use old value.\n");
								CursorXVar=CursorXVar-value;
							}
							holdCurserX=0;
							operatorCheck=0;
						}
						else if(first=='X' && operatorCheck==-1 && holdCurserY==0){
							CursorXVar=CursorXVar-value;
							if(CursorXVar<0){
								printf("Cursor moved out of the Canvas. Cursor will use old value.\n");
								CursorXVar=CursorXVar+value;
							}
							holdCurserX=0;
							operatorCheck=0;
						}
						else if(first=='Y' && operatorCheck==1 && holdCurserX==0){
							CursorYVar=CursorYVar+value;
							if(CursorYVar>CanvasYVar-1){
						printf("Cursor moved out of the Canvas. Cursor will use old value.\n");
						CursorYVar=CursorYVar-value;
						}
						holdCurserY=0;
						operatorCheck=0;
						}
						else if(first=='Y' && operatorCheck==-1 && holdCurserX==0){
						CursorYVar=CursorYVar-value;
						if(CursorYVar<0){
						printf("Cursor moved out of the Canvas. Cursor will use old value.\n");
						CursorYVar=CursorYVar+value;
						}
						holdCurserY=0;
						operatorCheck=0;
						}
						else if(first=='Y' && operatorCheck==-1 && holdCurserX==-1){			
						hold=CursorXVar-value;
						if(hold<0){
						printf("Cursor moved out of the Canvas. Cursor will use old value.\n");
						}
						else{
						CursorYVar=CursorXVar-value;
						}
						holdCurserY=0;
						operatorCheck=0;
						holdCurserX=0;
						}
						else if(first=='Y' && operatorCheck==1 && holdCurserX==-1){			
						if(CursorXVar+value>CanvasYVar-1){
						printf("Cursor moved out of the Canvas. Cursor will use old value.\n");
						}
						else{
						CursorYVar=CursorXVar+value;
						}
						holdCurserY=0;
						operatorCheck=0;
						holdCurserX=0;
						}
						else if(first=='X' && operatorCheck==-1 && holdCurserY==-1){			
						hold=CursorYVar-value;
						if(hold<0){
						printf("Cursor moved out of the Canvas. Cursor will use old value.\n");
						}
						else{
						CursorXVar=CursorYVar-value;
						}
						holdCurserY=0;
						operatorCheck=0;
						holdCurserX=0;
						}
						else if(first=='X' && operatorCheck==1 && holdCurserY==-1){			
						if(CursorYVar+value>CanvasXVar-1){
						printf("Cursor moved out of the Canvas. Cursor will use old value.\n");
						}
						else{
						CursorXVar=CursorYVar+value;
						}
						holdCurserY=0;
						operatorCheck=0;
						holdCurserX=0;
						}
						if(holdCurserX==-1 && operatorCheck==0){
						if(value>CanvasXVar-1){
						printf("Cursor moved out of the Canvas. Cursor will use old value.\n");
						}
						else{
						CursorXVar=value;
						}
						holdCurserX=0;
						}
						if(holdCurserY==-1 && operatorCheck==0){
						if(value>CanvasYVar-1){
						printf("Cursor moved out of the Canvas. Cursor will use old value.\n");
						}
						else{
						CursorYVar=value;
						}
						holdCurserY=0;
						}
						if(RenewHold==-1){
						posXHolder[renewPos]=value;
						posYHolder[renewPos]=value;
						RenewHold=0;
						}
											
					 	return int_lit;
					}

[a-zA-Z]+ 				{
						if(DrawingSectionLock == 0){			
							arrOfBrushes[NumberOfStructures].Name = yytext;
							strcpy(nameHolder[indexx1],yytext);
							indexx1++;
						}
						else if(RenewLock == 1 && kilit==99){
							for(int i=0;i<NumberOfStructures;i++){							
								if (strstr(arrOfBrushes[i].Name,yytext) != NULL) {
									renewPos=i;
									break;
								}			
							}
							kilit=0;
						}
						if(indexx1 - indexx2 >1){
							indexx2++;	
						}
							
						if(paintSection==-1){
								
								for(int i=0;i<indexx1;i++){							
								if (strcmp(nameHolder[i],yytext) == 0) {
									paintPos=i;
									break;
								}		
							}
								for(int i=0;i<indexx1;i++){							
								if (strcmp(nameHolder[i],yytext) == 0) {
									sayac++;
								}		
							}	
								if(sayac==0){
								printf("Use of undeclared variable in statements.");
								return 0;
								}						
								else{
								for(int i=CursorYVar;i<CursorYVar+posXHolder[paintPos];i++){
									for(int j=CursorXVar;j<CursorXVar+posYHolder[paintPos];j++){
										canvas[i][j]='*';
																   }							
														           }
								sayac=0;							           
								}
								
							
						paintSection=0;					
						}
						if(RenewHold==-1){
						for(int i=0;i<indexx1;i++){							
								if (strcmp(nameHolder[i],yytext) == 0) {
									renewPos=i;
									break;
								}			
							}
						}					
						return ID;	
					}

[ \t\n]+  				/* ignore whitespaces */;

’([^']*)’				{ 
						return message;
					}
		
!!.* 					{
						
					}
%%

int yywrap (void) {
return 1;
}
