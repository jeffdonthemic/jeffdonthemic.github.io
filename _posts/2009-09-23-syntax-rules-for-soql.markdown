---
layout: post
title:  Syntax Rules for SOQL
description: One of my fellow Appirian added the following BNF notation for the syntax rules of SOQL to the Salesforce wiki. I hadnt seen this before so its really going to come in handy. You can use it to debug syntax errors or more fully understand what syntax is valid in SOQL. Thought it might make for some interesting Evernote fodder. QUERY --= SELECT (COUNT() | (FIELD ( , FIELD)*)) FROM UNQUALIFIEDNAME (AS ? UNQUALIFIEDNAME)? (USING UNQUALIFIEDNAME)?  (PARENT_ALIAS_EXPR)* (WHERE CONDITIONEXPR )? (ORDER 
date: 2009-09-23 08:18:59 +0300
image:  '/images/slugs/syntax-rules-for-soql.jpg'
tags:   ["salesforce"]
---
<p>One of my fellow Appirian added the following BNF notation for the syntax rules of SOQL to the Salesforce wiki. I hadn't seen this before so it's really going to come in handy. You can use it to debug syntax errors or more fully understand what syntax is valid in SOQL. Thought it might make for some interesting Evernote fodder.</p>
<pre>QUERY ::= 'SELECT' ('COUNT()' | (FIELD ( ',' FIELD)*))
'FROM' UNQUALIFIEDNAME ('AS' ? UNQUALIFIEDNAME)? ('USING' UNQUALIFIEDNAME)?
 (PARENT_ALIAS_EXPR)*
('WHERE' CONDITIONEXPR )?
('ORDER BY' ORDERBYEXPR)?
('LIMIT' POSINTEGER )?
FIELD ::= NAME | 'toLabel' '(' NAME ')' | '(' QUERY ')'
PARENT_ALIAS_EXPR ::= ',' QUALIFIEDNAME ('AS' ? UNQUALIFIEDNAME)?
 ('USING' UNQUALIFIEDNAME)?
CONDITIONEXPR ::= ANDEXPR | OREXPR | NOTEXPR | SIMPLEEXPR
ANDEXPR ::= SIMPLEEXPR 'AND' SIMPLEEXPR ('AND' SIMPLEEXPR)*
OREXPR ::= SIMPLEEXPR 'OR' SIMPLEEXPR ('OR' SIMPLEEXPR)*
NOTEXPR ::= 'NOT' SIMPLEEXPR
SIMPLEEXPR ::= '(' CONDITIONEXPR ')' | FIELDEXPR | SETEXPR
FIELDEXPR ::= NAME OPERATOR VALUE | NAME MATHOPERATOR NAME OPERATOR VALUE
SETEXPR ::= NAME ('includes' | 'excludes' | 'in' | 'not' 'in') '(' VALUE
(',' VALUE)* ')'
ORDERBYEXPR ::= NAME ('asc' | 'desc')? ('nulls' ('first'|'last'))?
 (',' NAME ('asc' | 'desc')? ('nulls' ('first'|'last'))?)*
OPERATOR ::= '=' | '!=' | '<' | '<=' | '>' | '>=' | 'like'
MATHOPERATOR ::= '+' | '-'
VALUE ::= STRING_LITERAL | NUMBER | DATE | DATETIME | NULL | TRUE | FALSE |
 DATEFORMULA | CURRENCY
DATEFORMULA ::= YESTERDAY | TODAY | TOMORROW | LAST_WEEK | THIS_WEEK |
 NEXT_WEEK | THIS_MONTH | LAST_MONTH | NEXT_MONTH | LAST_90_DAYS |
 NEXT_90_DAYS | LAST_N_DAYS ':' INTEGER | NEXT_N_DAYS ':' INTEGER |
 THIS_QUERTER | LAST_QUARTER | NEXT_QUARTER | NEXT_N_QUARTERS ':'
 INTEGER | LAST_N_QUARTERS ':' INTEGER | THIS_YEAR | LAST_YEAR |
 NEXT_YEAR | THIS_FISCAL_QUARTER | NEXT_N_YEARS ':' INTEGER |
 LAST_N_YEARS ':' INTEGER | LAST_FISCAL_QUARTER | NEXT_FISCAL_QUARTER |
 NEXT_N_FISCAL_QUARTERS ':' INTEGER | LAST_N_FISCAL_QUARTERS ':' INTEGER |
 THIS_FISCAL_YEAR | LAST_FISCAL_YEAR | NEXT_FISCAL_YEAR |
 NEXT_N_FISCAL_YEARS ':' INTEGER | LAST_N_FISCAL_YEARS ':' INTEGER
UNQUALIFIEDNAME ::= LETTER (NAMECHAR)*
QUALIFIEDNAME ::= UNQUALIFIEDNAME ('.' UNQUALIFIEDNAME)*
NAME ::= QUALIFIEDNAME | UNQUALIFIEDNAME
LETTER ::= 'a'..'z' | 'A'..'Z'
NAMECHAR ::= LETTER | DIGIT | '_'
DATE ::= YEAR '-' MONTH '-' DAY
DATETIME ::= DATE 'T' HOUR ':' MINUTE ':' SECOND ('Z' | (('+' |'-')
 TZHOUR ( ':' TZMINUTE)? ))
YEAR ::= DIGIT DIGIT DIGIT DIGIT
MONTH ::= '0' '1'..'9' | '1' ('0' | '1' | '2')
DAY ::= '0' '1'..'9' | '1'..'2' DIGIT | '3' ('0' | '1')
HOUR ::= '0'..'1' DIGIT | '2' '0'..'3'
MINUTE ::= '0'..'5' DIGIT
TZHOUR ::= DIGIT | TZHOUR DIGIT
TZMINUTE ::= DIGIT | TZMINUTE DIGIT
SECOND ::= '0'..'5' DIGIT ( '.' POSINTEGER )?
CURRENCY ::= (LETTER)* NUMBER
NULL ::= 'null'
TRUE ::= 'true'
FALSE ::= 'false'
NUMBER ::= '.' POSINTEGER | INTEGER '.' POSINTEGER
INTEGER ::= ('+' | '-')? POSINTEGER
POSINTEGER ::= DIGIT+
DIGIT ::= '0'..'9'
STRING_LITERAL ::= "'" (ESC_CHAR | ~("'"))* "'"
ESC_CHAR ::= '\' ('n' | 'r' | 't' | '"' | "'" | '\')
WS ::= S+
S ::= ' ' | S ' ' | ''</pre>
