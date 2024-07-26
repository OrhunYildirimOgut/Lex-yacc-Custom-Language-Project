%{
void yyerror (char *s);
int yylex();
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

%}

%start Peakasso
%token programIdentifier
%token Canvas_Init_Section_Identifier
%token Brush_Declaration_Section_Identifier
%token Drawing_Section_Identifier
%token Brush_Identifier
%token ID
%token int_lit
%token Semicolon
%token colon
%token ConstToken
%token CanvasX
%token CanvasY
%token CursorX
%token CursorY
%token Const_Identifier
%token Equals
%token Comma
%token RENEW_BRUSH_IDENTIFIER
%token PAINT_CANVAS_IDENTIFIER
%token message
%token MOVE_IDENTIFIER
%token TO
%token PLUS
%token MINUS
%token exhibitCanvasIdentifier


%%
Peakasso: 
	programIdentifier ID Semicolon Canvas_Init_Section Brush_Declaration_Section Drawing_Section
;	

Canvas_Init_Section:
	Canvas_Init_Section_Identifier colon Canvas_Size_Init Cursor_Pos_Init
;

Brush_Declaration_Section:
	Brush_Declaration_Section_Identifier colon Variable_Def
;

Drawing_Section:
	Drawing_Section_Identifier colon Statement_List
;

Canvas_Size_Init:
	Const_Identifier CanvasX Equals int_lit Semicolon Const_Identifier CanvasY Equals int_lit Semicolon
;

Cursor_Pos_Init:
	CursorX Equals int_lit Semicolon CursorY Equals int_lit Semicolon
;

Variable_Def:
	Brush_Identifier Brush_List
;

Brush_List:
	Brush_Name Semicolon | Brush_Name Comma Brush_List | ID Comma Brush_List | ID Semicolon
;

Brush_Name:
	ID Semicolon | ID Equals int_lit int_lit | ID Semicolon int_lit int_lit
;

Statement_List :
	Statement | Statement_List Statement ;
;

Statement: 
	 Renew_Stmt 
	| Paint_Stmt 
	| Exhibit_Stmt 
	| Cursor_Move_Stmt 
;

Renew_Stmt: 
	RENEW_BRUSH_IDENTIFIER message Brush_Name
;

Paint_Stmt: 
	PAINT_CANVAS_IDENTIFIER Brush_Name
;

Exhibit_Stmt: 
	exhibitCanvasIdentifier Semicolon
;

Cursor_Move_Stmt:
	MOVE_IDENTIFIER Cursor TO Expression Semicolon
;

Cursor:
	CursorX | CursorY
;

Expression: 
	Term 
	| Cursor Operator Term 
;

Operator:
	PLUS 
	| MINUS	
;

Term: 
	Factor
;

Factor: 
	int_lit | Cursor | CanvasX | CanvasY
;

%%          


int main (void) {

	return yyparse ( );
	
}

void yyerror (char *s) {

	printf("Error Occured.Program Terminated.\n");

}
