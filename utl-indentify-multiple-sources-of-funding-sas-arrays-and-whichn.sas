%let pgm=utl-indentify-multiple-sources-of-funding-sas-arrays-and-whichn;

%stop_submission;

Indentify multiple sources of funding sas arrays and whichn

github
https://tinyurl.com/turmtytw
https://github.com/rogerjdeangelis/utl-indentify-multiple-sources-of-funding-sas-arrays-and-whichn


SAS-L
https://listserv.uga.edu/scripts/wa-UGA.exe?A2=SAS-L;3758325b.2507A&S=

PROCESS

   1 SORCES OF FUNDING

     CHC MHC HO PH

      1   0   1  1
      1   0   0  0

   2  Two or more sources of funding must exist or funding is unfunded.

   3  Concatenate the mutiple source founfd and output the number of sources

      WANT
                      NUM
      CHC MHC HO PH  SOURCES   SOURCES

       1   0   1  1    3       CHC-HO-PH
       1   0   0  0    1       UNFUNDED

NOTE: I added row_id for thr sql and transpose solutions..
      I dropped row_id for the pure datastep solutions

      FIVE SOLUTIONS

        1 sas identify first source
        2 sas identify mutiple sources
        3 sas transpose
        4 r sql (ho r arrays)
          (also works in python, octave/matlab, excel)
        5 r sq with r arrays
          to use with python, octave/matlab, excel)
           send the generated code to sas via a macro variable and pate in other languages)

/**************************************************************************************************************************/
/*                 INPUT               |      PROCESS                                |OUTPUT                              */
/*                 =====               |      =======                                |======                              */
/*WORK.HAVE                            | 1 SAS FIRST SOURCE                          |                       NUM          */
/*               ROW                   | ==================                          | FUNDING  CHC MHC HO PH SRC         */
/*CHC MHC HO PH  ID                    |                                             |                                    */
/*                                     | data want;                                  | UNFUNDED  1   0   0  0  1          */
/* 1   0   0  0   1                    |  length funding $20;                        | UNFUNDED  0   1   0  0  1          */
/* 0   1   0  0   2                    |                                             | UNFUNDED  1   0   0  0  1          */
/* 1   0   0  0   3                    |  set sd1.have(drop=row_id);                 | CHC       1   0   1  1  3          */
/* 1   0   1  1   4                    |                                             | UNFUNDED  0   0   1  0  1          */
/* 0   0   1  0   5                    |  array funds _numeric_;                     | UNFUNDED  0   0   1  0  1          */
/* 0   0   1  0   6                    |  numsrc =sum(of funds(*));                  | CHC       1   0   1  0  2          */
/* 1   0   1  0   7                    |  first_index = whichn(1, of funds(*));      | CHC       1   0   0  1  2          */
/* 1   0   0  1   8                    |                                             | UNFUNDED  1   0   0  0  1          */
/* 1   0   0  0   9                    |  if numsrc <2 then                          | CHC       1   0   1  0  2          */
/* 1   0   1  0  10                    |    funding="UNFUNDED";                      | UNFUNDED  1   0   0  0  1          */
/* 1   0   0  0  11                    |  else                                       | UNFUNDED  1   0   0  0  1          */
/* 1   0   0  0  12                    |    funding =                                |                                    */
/*                                     |     vname(funds(first_index));              |                                    */
/*  proc format;                       |  drop first_index;                          |                                    */
/*   invalue onezero                   | run;quit;                                   |                                    */
/*     'TRUE'  = 1                     |                                             |                                    */
/*     'FALSE' = 0                     | proc print data=want;                       |                                    */
/*   ;                                 | run;quit;                                   |                                    */
/*  run;                               |                                             |                                    */
/*                                     |------------------------------------------------------------------------------    */
/* options                             |                                             |                          NUM       */
/*  validvarname=upcase;               | 2 SAS ALL SOURCES(variation of ops solution)| FUNDING   CHC MHC HO PH  SRC       */
/* libname sd1 "d:/sd1";               | ============================================|                                    */
/* data sd1.have;                      |                                             | UNFUNDED   1   0   0  0   1        */
/* input                               | data want;                                  | UNFUNDED   0   1   0  0   1        */
/*    CHC : onezero6.                  |  length funding $20 ;                       | UNFUNDED   1   0   0  0   1        */
/*    MHC : onezero6.                  |  set sd1.have(drop=row_id);                 | CHC-HO-PH  1   0   1  1   3        */
/*    HO  : onezero6.                  |  array funds _numeric_;                     | UNFUNDED   0   0   1  0   1        */
/*    PH  : onezero6. ;                |  numsrc=sum(of funds(*));                   | UNFUNDED   0   0   1  0   1        */
/* row_id=_n_;                         |  funding="";                                | CHC-HO     1   0   1  0   2        */
/* cards4;                             |  if numsrc <2 then funding="UNFUNDED";      | CHC-PH     1   0   0  1   2        */
/* TRUE FALSE FALSE FALSE              |  else do;                                   | UNFUNDED   1   0   0  0   1        */
/* FALSE TRUE FALSE FALSE              |   do idx=1 to dim(funds);                   | CHC-HO     1   0   1  0   2        */
/* TRUE FALSE FALSE FALSE              |    if funds(idx) = 1 then                   | UNFUNDED   1   0   0  0   1        */
/* TRUE FALSE TRUE TRUE                |     funding=                                | UNFUNDED   1   0   0  0   1        */
/* FALSE FALSE TRUE FALSE              |      catx('-',funding,vname(funds(idx)));   |                                    */
/* FALSE FALSE TRUE FALSE              |    end;                                     |                                    */
/* TRUE FALSE TRUE FALSE               |  end;                                       |                                    */
/* TRUE FALSE FALSE TRUE               |  output;                                    |                                    */
/* TRUE FALSE FALSE FALSE              |  funding='';                                |                                    */
/* TRUE FALSE TRUE FALSE               |  drop idx;                                  |                                    */
/* TRUE FALSE FALSE FALSE              | run;quit;                                   |                                    */
/* TRUE FALSE FALSE FALSE              |                                             |                                    */
/* ;;;;                                | proc print data=want;                       |                                    */
/* run;;quit;                          | run;quit;                                   |                                    */
/*                                     |----------------------------------------------------------------------------------*/
/*                                     |                                             |                                    */
/*                                     | 3 SAS TRANSPOSE                             |  FUNDS        TOT                  */
/*                                     | ===============                             |                                    */
/*                                     |                                             |  CHC           1                   */
/*                                     | proc transpose data=ad1.have                |  MHC           1                   */
/*                                     |    out=xpo(rename=(                         |  CHC           1                   */
/*                                     |       col1=numsrc _name_=var)               |  CHC-HO-PH     3                   */
/*                                     |    where=(numsrc ne 0));                    |  HO            1                   */
/*                                     | by row_id;                                  |  HO            1                   */
/*                                     | run;quit;                                   |  CHC-HO        2                   */
/*                                     |                                             |  CHC-PH        2                   */
/*                                     | data roll;                                  |  CHC           1                   */
/*                                     |   length funds $20;                         |  CHC-HO        2                   */
/*                                     |   retain tot 0 funds;                       |  CHC           1                   */
/*                                     |   set xpo;                                  |  CHC           1                   */
/*                                     |   by row_id notsorted;                      |                                    */
/*                                     |   if first.row_id then do;                  |                                    */
/*                                     |     tot=0;                                  |                                    */
/*                                     |     funds="";                               |                                    */
/*                                     |   end;                                      |                                    */
/*                                     |   funds=catx('-',funds,var);                |                                    */
/*                                     |   tot=tot+1;                                |                                    */
/*                                     |   if last.row_id then output;               |                                    */
/*                                     |   drop numsrc var row_id;                   |                                    */
/*                                     | run;quit;                                   |                                    */
/*                                     -----------------------------------------------------------------------------------*/
/*                                     |                                             |                                    */
/*                                     | 4 R SQL (no arrays)                         | R                                  */
/*                                     | ===================                         | > want;                            */
/*                                     |                                             |    row_id sources     funds        */
/*                                     | proc datasets lib=sd1 nolist nodetails;     | 1       1       1       CHC        */
/*                                     |  delete want;                               | 2       2       1       MHC        */
/*                                     | run;quit;                                   | 3       3       1       CHC        */
/*                                     |                                             | 4       4       3 CHC-HO-PH        */
/*                                     | %utl_rbeginx;                               | 5       5       1        HO        */
/*                                     | parmcards4;                                 | 6       6       1        HO        */
/*                                     | library(haven)                              | 7       7       2    CHC-HO        */
/*                                     | library(sqldf)                              | 8       8       2    CHC-PH        */
/*                                     | source("c:/oto/fn_tosas9x.R")               | 9       9       1       CHC        */
/*                                     | options(sqldf.dll = "d:/dll/sqlean.dll")    | 10     10       2    CHC-HO        */
/*                                     | have<-read_sas("d:/sd1/have.sas7bdat")      | 11     11       1       CHC        */
/*                                     | print(have)                                 | 12     12       1       CHC        */
/*                                     | want<-sqldf("                               |                                    */
/*                                     | with                                        | SAS                                */
/*                                     |   xpo as (                                  |                                    */
/*                                     |   select * from (                           | ROW_ID    SOURCES    FUNDS         */
/*                                     |   select row_id, 'CHC' as var               |                                    */
/*                                     |     ,CHC as val from have union all         |    1         1       CHC           */
/*                                     |   select row_id, 'MHC' as var               |    2         1       MHC           */
/*                                     |     ,MHC as val from have union all         |    3         1       CHC           */
/*                                     |   select row_id, 'HO'  as var               |    4         3       CHC-HO-PH     */
/*                                     |     ,HO  as val from have union all         |    5         1       HO            */
/*                                     |   select row_id, 'PH'  as var               |    6         1       HO            */
/*                                     |     ,PH  as val from have                   |    7         2       CHC-HO        */
/*                                     |   )                                         |    8         2       CHC-PH        */
/*                                     |   where val=1                               |    9         1       CHC           */
/*                                     |   order by row_id )                         |   10         2       CHC-HO        */
/*                                     | select                                      |   11         1       CHC           */
/*                                     |   row_id                                    |   12         1       CHC           */
/*                                     |  ,sum(val) as sources                       |                                    */
/*                                     |  ,group_concat(var,'-') as funds            |                                    */
/*                                     | from                                        |                                    */
/*                                     |   xpo                                       |                                    */
/*                                     | group                                       |                                    */
/*                                     |   by row_id                                 |                                    */
/*                                     | ")                                          |                                    */
/*                                     | want;                                       |                                    */
/*                                     | fn_tosas9x(                                 |                                    */
/*                                     |       inp    = want                         |                                    */
/*                                     |      ,outlib ="d:/sd1/"                     |                                    */
/*                                     |      ,outdsn ="want"                        |                                    */
/*                                     |      )                                      |                                    */
/*                                     | ;;;;                                        |                                    */
/*                                     | %utl_rendx;                                 |                                    */
/*                                     |                                             |                                    */
/*                                     | proc print data=sd1.want;                   |                                    */
/*                                     | run;quit;                                   |                                    */
/*                                     |----------------------------------------------------------------------------------*/
/*                                     | 5 sql r arrays                              |                                    */
/*                                     |                                             |R                                   */
/*                                     | proc datasets lib=sd1 nolist nodetails;     | > want;                            */
/*                                     |  delete want;                               |    row_id sources     funds        */
/*                                     | run;quit;                                   | 1       1       1       CHC        */
/*                                     |                                             | 2       2       1       MHC        */
/*                                     | %utl_rbeginx;                               | 3       3       1       CHC        */
/*                                     | parmcards4;                                 | 4       4       3 CHC-HO-PH        */
/*                                     | library(haven)                              | 5       5       1        HO        */
/*                                     | library(sqldf)                              | 6       6       1        HO        */
/*                                     | source("c:/oto/fn_tosas9x.R")               | 7       7       2    CHC-HO        */
/*                                     | options(sqldf.dll = "d:/dll/sqlean.dll")    | 8       8       2    CHC-PH        */
/*                                     | have<-read_sas("d:/sd1/have.sas7bdat")      | 9       9       1       CHC        */
/*                                     | print(have)                                 | 10     10       2    CHC-HO        */
/*                                     | colnams<-colnames(have);                    | 11     11       1       CHC        */
/*                                     | str(colnams);                               | 12     12       1       CHC        */
/*                                     | colnams<-colnams[-length(colnams)]          |                                    */
/*                                     | colnams                                     | SAS                                */
/*                                     | phrases <- paste(                           | row_id sources     funds           */
/*                                     |   sprintf(                                  |      1       1       CHC           */
/*                                     |    "select                                  |      2       1       MHC           */
/*                                     |        row_id                               |      3       1       CHC           */
/*                                     |      ,'%1$s' as var                         |      4       3 CHC-HO-PH           */
/*                                     |       ,%1$s   as val                        |      5       1        HO           */
/*                                     |     from                                    |      6       1        HO           */
/*                                     |       have", colnams)                       |      7       2    CHC-HO           */
/*                                     |    ,collapse = " union all "                |      8       2    CHC-PH           */
/*                                     |   )                                         |      9       1       CHC           */
/*                                     | phrases <- paste(                           |     10       2    CHC-HO           */
/*                                     |    'select                                  |     11       1       CHC           */
/*                                     |         row_id                              |     12       1       CHC           */
/*                                     |        ,var                                 |                                    */
/*                                     |        ,val                                 |                                    */
/*                                     |     from                                    |                                    */
/*                                     |        ( ',phrases, ' )                     |                                    */
/*                                     |     where                                   |                                    */
/*                                     |        val=1                                |                                    */
/*                                     |     order                                   |                                    */
/*                                     |        by row_id' )                         |                                    */
/*                                     | phrases                                     |                                    */
/*                                     | xpo<-sqldf(phrases)                         |                                    */
/*                                     | want<-sqldf("                               |                                    */
/*                                     |     select                                  |                                    */
/*                                     |       row_id                                |                                    */
/*                                     |      ,sum(val) as sources                   |                                    */
/*                                     |      ,group_concat(var,'-') as funds        |                                    */
/*                                     |     from                                    |                                    */
/*                                     |       xpo                                   |                                    */
/*                                     |     group                                   |                                    */
/*                                     |       by row_id                             |                                    */
/*                                     | ")                                          |                                    */
/*                                     | want;                                       |                                    */
/*                                     | ;;;;                                        |                                    */
/*                                     | %utl_rendx;                                 |                                    */
/**************************************************************************************************************************/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

 proc format;
  invalue onezero
    'TRUE'  = 1
    'FALSE' = 0
  ;
 run;

options
 validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
input
   CHC : onezero6.
   MHC : onezero6.
   HO  : onezero6.
   PH  : onezero6. ;
row_id=_n_;
cards4;
TRUE FALSE FALSE FALSE
FALSE TRUE FALSE FALSE
TRUE FALSE FALSE FALSE
TRUE FALSE TRUE TRUE
FALSE FALSE TRUE FALSE
FALSE FALSE TRUE FALSE
TRUE FALSE TRUE FALSE
TRUE FALSE FALSE TRUE
TRUE FALSE FALSE FALSE
TRUE FALSE TRUE FALSE
TRUE FALSE FALSE FALSE
TRUE FALSE FALSE FALSE
;;;;
run;;quit;

/**************************************************************************************************************************/
/*                ROW                                                                                                     */
/* CHC MHC HO PH  ID                                                                                                      */
/*                                                                                                                        */
/*  1   0   0  0   1                                                                                                      */
/*  0   1   0  0   2                                                                                                      */
/*  1   0   0  0   3                                                                                                      */
/*  1   0   1  1   4                                                                                                      */
/*  0   0   1  0   5                                                                                                      */
/*  0   0   1  0   6                                                                                                      */
/*  1   0   1  0   7                                                                                                      */
/*  1   0   0  1   8                                                                                                      */
/*  1   0   0  0   9                                                                                                      */
/*  1   0   1  0  10                                                                                                      */
/*  1   0   0  0  11                                                                                                      */
/*  1   0   0  0  12                                                                                                      */
/**************************************************************************************************************************/

/*                   _     _            _   _  __          __ _          _
/ |  ___  __ _ ___  (_) __| | ___ _ __ | |_(_)/ _|_   _   / _(_)_ __ ___| |_   ___  ___  _   _ _ __ ___ ___
| | / __|/ _` / __| | |/ _` |/ _ \ `_ \| __| | |_| | | | | |_| | `__/ __| __| / __|/ _ \| | | | `__/ __/ _ \
| | \__ \ (_| \__ \ | | (_| |  __/ | | | |_| |  _| |_| | |  _| | |  \__ \ |_  \__ \ (_) | |_| | | | (_|  __/
|_| |___/\__,_|___/ |_|\__,_|\___|_| |_|\__|_|_|  \__, | |_| |_|_|  |___/\__| |___/\___/ \__,_|_|  \___\___|
                                                  |___/
Note row_id is dropped
*/

data want;
 length funding $20;

 set sd1.have(drop=row_id);

 array funds _numeric_;
 numsrc =sum(of funds(*));
 first_index = whichn(1, of funds(*));

 if numsrc <2 then
   funding="UNFUNDED";
 else
   funding =
    vname(funds(first_index));
 drop first_index;
run;quit;

proc print data=want;
run;quit;

/**************************************************************************************************************************/
/*  FUNDING     CHC    MHC    HO    PH    NUMSRC                                                                          */
/*                                                                                                                        */
/*  UNFUNDED     1      0      0     0       1                                                                            */
/*  UNFUNDED     0      1      0     0       1                                                                            */
/*  UNFUNDED     1      0      0     0       1                                                                            */
/*  CHC          1      0      1     1       3                                                                            */
/*  UNFUNDED     0      0      1     0       1                                                                            */
/*  UNFUNDED     0      0      1     0       1                                                                            */
/*  CHC          1      0      1     0       2                                                                            */
/*  CHC          1      0      0     1       2                                                                            */
/*  UNFUNDED     1      0      0     0       1                                                                            */
/*  CHC          1      0      1     0       2                                                                            */
/*  UNFUNDED     1      0      0     0       1                                                                            */
/*  UNFUNDED     1      0      0     0       1                                                                            */
/**************************************************************************************************************************/

/*___                    _     _            _   _  __
|___ \   ___  __ _ ___  (_) __| | ___ _ __ | |_(_)/ _|_   _
  __) | / __|/ _` / __| | |/ _` |/ _ \ `_ \| __| | |_| | | |
 / __/  \__ \ (_| \__ \ | | (_| |  __/ | | | |_| |  _| |_| |
|_____| |___/\__,_|___/ |_|\__,_|\___|_| |_|\__|_|_|  \__, |
                                                      |___/
                 _   _       _
 _ __ ___  _   _| |_(_)_ __ | | ___   ___  ___  _   _ _ __ ___ ___  ___
| `_ ` _ \| | | | __| | `_ \| |/ _ \ / __|/ _ \| | | | `__/ __/ _ \/ __|
| | | | | | |_| | |_| | |_) | |  __/ \__ \ (_) | |_| | | | (_|  __/\__ \
|_| |_| |_|\__,_|\__|_| .__/|_|\___| |___/\___/ \__,_|_|  \___\___||___/
                      |_|
*/

data want;
 length funding $20 ;
 set sd1.have(drop=row_id);
 array funds _numeric_;
 numsrc=sum(of funds(*));
 funding="";
 if numsrc <2 then funding="UNFUNDED";
 else do;
  do idx=1 to dim(funds);
   if funds(idx) = 1 then
    funding=
     catx('-',funding,vname(funds(idx)));
   end;
 end;
 output;
 funding='';
 drop idx;
run;quit;

/**************************************************************************************************************************/
/* FUNDING      CHC    MHC    HO    PH    NUMSRC                                                                          */
/*                                                                                                                        */
/* UNFUNDED      1      0      0     0       1                                                                            */
/* UNFUNDED      0      1      0     0       1                                                                            */
/* UNFUNDED      1      0      0     0       1                                                                            */
/* CHC-HO-PH     1      0      1     1       3                                                                            */
/* UNFUNDED      0      0      1     0       1                                                                            */
/* UNFUNDED      0      0      1     0       1                                                                            */
/* CHC-HO        1      0      1     0       2                                                                            */
/* CHC-PH        1      0      0     1       2                                                                            */
/* UNFUNDED      1      0      0     0       1                                                                            */
/* CHC-HO        1      0      1     0       2                                                                            */
/* UNFUNDED      1      0      0     0       1                                                                            */
/* UNFUNDED      1      0      0     0       1                                                                            */
/**************************************************************************************************************************/

/*____                   _                                                       _
|___ /   ___  __ _ ___  | |_ _ __ __ _ _ __  ___ _ __   ___  ___  ___  ___  __ _| |
  |_ \  / __|/ _` / __| | __| `__/ _` | `_ \/ __| `_ \ / _ \/ __|/ _ \/ __|/ _` | |
 ___) | \__ \ (_| \__ \ | |_| | | (_| | | | \__ \ |_) | (_) \__ \  __/\__ \ (_| | |
|____/  |___/\__,_|___/  \__|_|  \__,_|_| |_|___/ .__/ \___/|___/\___||___/\__, |_|
  */                                                                          |_|

proc transpose data=sd1.have
   out=xpo(rename=(
      col1=numsrc _name_=var)
   where=(numsrc ne 0));
by row_id;
run;quit;

data roll;
  length funds $20;
  retain tot 0 funds;
  set xpo;
  by row_id notsorted;
  if first.row_id then do;
    tot=0;
    funds="";
  end;
  funds=catx('-',funds,var);
  tot=tot+1;
  if last.row_id then output;
  drop numsrc var row_id;
run;quit;

/**************************************************************************************************************************/
/* FUNDS        TOT                                                                                                       */
/*                                                                                                                        */
/* CHC           1                                                                                                        */
/* MHC           1                                                                                                        */
/* CHC           1                                                                                                        */
/* CHC-HO-PH     3                                                                                                        */
/* HO            1                                                                                                        */
/* HO            1                                                                                                        */
/* CHC-HO        2                                                                                                        */
/* CHC-PH        2                                                                                                        */
/* CHC           1                                                                                                        */
/* CHC-HO        2                                                                                                        */
/* CHC           1                                                                                                        */
/* CHC           1                                                                                                        */
/**************************************************************************************************************************/

/*  _                      _    ___                                                __
| || |    _ __   ___  __ _| |  / / |__   ___    _ __   __ _ _ __ _ __ __ _ _   _ __\ \
| || |_  | `__| / __|/ _` | | | || `_ \ / _ \  | `__| / _` | `__| `__/ _` | | | / __| |
|__   _| | |    \__ \ (_| | | | || | | | (_) | | |   | (_| | |  | | | (_| | |_| \__ \ |
   |_|   |_|    |___/\__, |_| | ||_| |_|\___/  |_|    \__,_|_|  |_|  \__,_|\__, |___/ |
                        |_|    \_\                                         |___/   /_/
*/

proc datasets lib=sd1 nolist nodetails;
 delete want;
run;quit;

%utl_rbeginx;
parmcards4;
library(haven)
library(sqldf)
source("c:/oto/fn_tosas9x.R")
options(sqldf.dll = "d:/dll/sqlean.dll")
have<-read_sas("d:/sd1/have.sas7bdat")
print(have)
want<-sqldf("
with
  xpo as (
  select * from (
  select row_id, 'CHC' as var
    ,CHC as val from have union all
  select row_id, 'MHC' as var
    ,MHC as val from have union all
  select row_id, 'HO'  as var
    ,HO  as val from have union all
  select row_id, 'PH'  as var
    ,PH  as val from have
  )
  where val=1
  order by row_id )
select
  row_id
 ,sum(val) as sources
 ,group_concat(var,'-') as funds
from
  xpo
group
  by row_id
")
want;
fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="want"
     )
;;;;
%utl_rendx;

proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/*  R                                                                                                                     */
/*  > want;                                                                                                               */
/*     row_id sources     funds                                                                                           */
/*  1       1       1       CHC                                                                                           */
/*  2       2       1       MHC                                                                                           */
/*  3       3       1       CHC                                                                                           */
/*  4       4       3 CHC-HO-PH                                                                                           */
/*  5       5       1        HO                                                                                           */
/*  6       6       1        HO                                                                                           */
/*  7       7       2    CHC-HO                                                                                           */
/*  8       8       2    CHC-PH                                                                                           */
/*  9       9       1       CHC                                                                                           */
/*  10     10       2    CHC-HO                                                                                           */
/*  11     11       1       CHC                                                                                           */
/*  12     12       1       CHC                                                                                           */
/*                                                                                                                        */
/*  SAS                                                                                                                   */
/*                                                                                                                        */
/*  ROW_ID    SOURCES    FUNDS                                                                                            */
/*                                                                                                                        */
/*     1         1       CHC                                                                                              */
/*     2         1       MHC                                                                                              */
/*     3         1       CHC                                                                                              */
/*     4         3       CHC-HO-PH                                                                                        */
/*     5         1       HO                                                                                               */
/*     6         1       HO                                                                                               */
/*     7         2       CHC-HO                                                                                           */
/*     8         2       CHC-PH                                                                                           */
/*     9         1       CHC                                                                                              */
/*    10         2       CHC-HO                                                                                           */
/*    11         1       CHC                                                                                              */
/*    12         1       CHC                                                                                              */
/**************************************************************************************************************************/

/*___                                _ _   _
| ___|   _ __   ___  __ _  __      _(_) |_| |__    _ __   __ _ _ __ _ __ __ _ _   _ ___
|___ \  | `__| / __|/ _` | \ \ /\ / / | __| `_ \  | `__| / _` | `__| `__/ _` | | | / __|
 ___) | | |    \__ \ (_| |  \ V  V /| | |_| | | | | |   | (_| | |  | | | (_| | |_| \__ \
|____/  |_|    |___/\__, |   \_/\_/ |_|\__|_| |_| |_|    \__,_|_|  |_|  \__,_|\__, |___/
                       |_|                                                    |___/
*/

proc datasets lib=sd1 nolist nodetails;
 delete want;
run;quit;

%utl_rbeginx;
parmcards4;
library(haven)
library(sqldf)
source("c:/oto/fn_tosas9x.R")
options(sqldf.dll = "d:/dll/sqlean.dll")
have<-read_sas("d:/sd1/have.sas7bdat")
print(have)
colnams<-colnames(have);
str(colnams);
colnams<-colnams[-length(colnams)]
colnams
phrases <- paste(
  sprintf(
   "select
       row_id
     ,'%1$s' as var
      ,%1$s   as val
    from
      have", colnams)
   ,collapse = " union all "
  )
phrases <- paste(
   'select
        row_id
       ,var
       ,val
    from
       ( ',phrases, ' )
    where
       val=1
    order
       by row_id' )
phrases
xpo<-sqldf(phrases)
want<-sqldf("
    select
      row_id
     ,sum(val) as sources
     ,group_concat(var,'-') as funds
    from
      xpo
    group
      by row_id
")
want;
;;;;
%utl_rendx;

proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/* R                                                                                                                      */
/*  row_id sources     funds                                                                                              */
/*       1       1       CHC                                                                                              */
/*       2       1       MHC                                                                                              */
/*       3       1       CHC                                                                                              */
/*       4       3 CHC-HO-PH                                                                                              */
/*       5       1        HO                                                                                              */
/*       6       1        HO                                                                                              */
/*       7       2    CHC-HO                                                                                              */
/*       8       2    CHC-PH                                                                                              */
/*       9       1       CHC                                                                                              */
/*      10       2    CHC-HO                                                                                              */
/*      11       1       CHC                                                                                              */
/*      12       1       CHC                                                                                              */
/*                                                                                                                        */
/* SAS                                                                                                                    */
/* ROW_ID    SOURCES    FUNDS                                                                                             */
/*                                                                                                                        */
/*    1         1       CHC                                                                                               */
/*    2         1       MHC                                                                                               */
/*    3         1       CHC                                                                                               */
/*    4         3       CHC-HO-PH                                                                                         */
/*    5         1       HO                                                                                                */
/*    6         1       HO                                                                                                */
/*    7         2       CHC-HO                                                                                            */
/*    8         2       CHC-PH                                                                                            */
/*    9         1       CHC                                                                                               */
/*   10         2       CHC-HO                                                                                            */
/*   11         1       CHC                                                                                               */
/*   12         1       CHC                                                                                               */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
