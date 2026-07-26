# ABAP 7.5+ / S4HANA 新特性语法指南 (S4HANA Syntax Guide)

ABAP Syntax 
2020.08.01
Contents
1 New Keyword in ABAP5
DATA5
FIELD-SYMBOL6
NEW6
REF6
VALUE7
BASE8
FOR9
LET12
CONV13
SWITCH13
COND14
CORRESPONDING14
MOVE-CORRESPONDING（DEEP）18
REDUCE21
GROUP BY （FOR LOOP）24
FILTER26
EXACT28
2 Open SQL30
CONSTANT30
Host Variable / Expression31
Aggregate Expressions32
Built-In Functions（Num）33
Built-In Functions（String）34
Built-In Functions（Date/Time）36
Built-In Functions（Time Stamp）37
Built-In Functions（Time Zone）37
Built-In Functions（Date/Time Conversion）38
CASE39
NULL Value39
CAST41
CDS with Parameters42
Internal Table43
JOIN Expression44
WHERE Condition44
OFFSET45
Strict Mode46
3 Data Processing47
String Template47
Format Option47
CURRENCY48
COUNTRY 48
ALPHA 48
NUMBER/DATE/TIME 48
TIMESTAMP49
TIMEZONE49
WIDTH50
ALIGN50
PAD50
CASE 50
SIGN51
EXPONENT51
DECIMALS52
ZERO 52
XSD52
STYLE53
String Functions54
STRLEN 54
DISTANCE55
FIND 55
FIND_END56
FIND_ANY_OF56
FIND_ANY_NOT_OF56
COUNT 57
COUNT_ANY_OF57
COUNT_ANY_NOT_OF57
CONTAINS57
CONTAINS_ANY_OF57
CONTAINS_ANY_NOT_OF57
XSDBOOL 58
REPLACE 58
INSERT 59
CMAX/CMIN59
CONDENSE 60
CONCAT_LINES_OF 60
ESCAPE61
MATCH 61
REPEAT61
REVERSE 62
TRANSLATE62
TO_MIXED62
FORM_MIXED62
TO_UPPER/TO_LOWER 62
SHIFT_LEFT/SHIFT_RIGHT63
SUBSTRING 64
SUBSTRING_FROM64
SUBSTRING_AFTER64
SUBSTRING_BEFORE64
SUBSTRING_TO64
SEGMENT 65
Numeric Functions66
Internal Table Expressions67
OPTIONAL 68
DEFAULT 68
Internal Table Functions68
LINES 69
LINE_EXISTS 69
LINE_INDEX 69
4 Special Usages70
TRY… CATCH…70
CATCH … INTO …70
RETRY70
RAISE EXCEPTION71
CLEANUP71
CATCH BEFORE UNWIND72
RESUME73
Call Method74
Demo Output74
Demo Input75
Fixed point arithmetic76
1 New Keyword in ABAP
 DATA
ZDEMO_01_001
新语法允许在语句内部动态声明变量，该作用域与普通定义的变量范围一致
ABAP、ICON 这些类型池语句不再需要通过TYPE-POOL声明
DATA(lv_true_false) = abap_false.
DATA(lv_icon) = icon_material. 
通过赋值的方式来动态声明变量，系统会根据所赋的值来确定变量类型（虽然可以用，但是不建议使用，因为到后面你自己都会忘记是什么类型）
其中，字符类型会参照数据长度来指定（其中，此方法不通用，无法通过赋值动态声明浮点数）
DATA(lv_char) = 'This is a sentence'. 
DATA(lv_integer) = 15. 
动态声明内表/结构，字段类型与 SELECT LIST 对应的字段一致，在包含常量字段时，需要赋别名，以指定内表/结构中的字段名（常用）
SELECT matnr, maktx FROM makt INTO TABLE @DATA(lt_data).
SELECT SINGLE matnr, 'Constant' AS field  FROM makt  INTO @DATA(lwa_data).  
在 LOOP 内表时动态声明结构，可以避免使用带表头的内表（常用）
LOOP AT gt_data INTO DATA(lwa_data).
  ... 
ENDLOOP. 
在常见的操作语句中动态声明变量，多数情况下可以在 INTO 语句后使用，如下为连接/拆分字符串示例
CONCATENATE 'Text' '-' '01' INTO DATA(lv_concat). 
SPLIT lv_concat AT '-' INTO DATA(lv_part1) DATA(lv_part2).SPLIT lv_concat AT '-' INTO TABLE DATA(lt_data).
在调用方法时动态声明变量来接收传出参数，可以避免因类型不一致而导致的dump。
go_splitter_row->get_container( EXPORTING row = 1                                          column = 1                                RECEIVING container = DATA(go_cont) ).
注释：Data动态声明的内表无法接受crossponding传递的数据。动态声明不是万能的，谨慎使用。使用最好加注释备注声明的结构
 FIELD-SYMBOL
ZDEMO_01_002
与DATA关键字类似，FIELD-SYMBOL允许在语句内部动态声明字段符号
在 LOOP 时动态声明字段符号，需要区分的是，普通定义使用的是 FIELD-SYMBOLS
LOOP AT gt_data ASSIGNING (<fs_data>).
  ...ENDLOOP. 
在 ASSIGN 时动态声明字段符号并分配
ASSIGN (lv_fieldname) TO FIELD-SYMBOL(<fs_field>). 
 NEW
ZDEMO_01_003
使用 NEW 创建（实例化）引用对象，用来代替CREATE OBJECT
使用 NEW 关键字时，如果等号左侧的对象还没有确定类型，则必须在 NEW 关键字后指定类型，如 GO_GRID_NEW；
如果是已经预定义的对象，则可以用 # 代替，如 GO_GRID
例：注释：测试未成功。i_parent 是类方法，go_con不知道如何定义。
DATA(go_grid_new) = NEW cl_gui_alv_grid( i_parent = go_con ).DATA: go_grid TYPE REF TO cl_gui_alv_grid.go_grid = NEW #( i_parent = go_con ). 
 REF
ZDEMO_01_004
使用 REF 定义引用变量，用来代替 CREATE DATA
在使用 REF时，不需要提前声明变量，也不用指定类型，类型默认会与被指向的变量保持一致
例：
TYPES:BEGIN OF lty_data,        matnr TYPE mara-matnr,        mtart TYPE mara-mtart,        matkl TYPE mara-matkl,        text1 TYPE char50,      END OF lty_data.DATA(lwa_data) = VALUE lty_data( matnr = 'MATERIAL-001'                                 mtart = 'FOOD'                                 matkl = '1010'                                 text1 = 'FIRST' ).DATA(lv_ref) = REF #( lwa_data ).lv_ref->* = VALUE #( matnr = 'MATERIAL-002'                     mtart = 'WATR'                     matkl = '1020’ ).
lv_ref->text1 = 'SECOND'.
注释：
注意，使用了REF定义引用变量，则引用变量无法通过工作区-字段访问，只能通过引用变量—>字段访问。下段注释为错误写法WRITE:/ LV_REF-MATNR,LV_REF-MTART,LV_REF-MATKL,LV_REF-TEXT1.
测试结果：
 VALUE
ZDEMO_01_005
新语法中，可以使用 VALUE 作为赋值语句，主要用来为内表、结构、变量等对象赋值
参数类型引用同NEW关键字，在VALUE子句中，字段可以分开赋值，也可以使用结构整体赋值，为内表赋值时，需要用小括号将一行的数据包在一起
例：注意：value会默认覆盖原来的数据。经过测试，觉得覆盖一词并不准确，可以认为是重新赋值。原来有的不同的数据会被删除。参考demo：ZDEMO_01_018
TYPES:BEGIN OF lty_data,        matnr TYPE mara-matnr,        mtart TYPE mara-mtart,        matkl TYPE mara-matkl,        text1 TYPE char50,      END OF lty_data.      DATA: lt_data TYPE TABLE OF lty_data.DATA(lwa_data) = VALUE lty_data( matnr =                                  mtart = 'FOOD'                                 matkl = '1020'                                 text1 = 'FIRST material' ).lt_data = VALUE #( ( lwa_data )“预定义的数据类型可以用#代替                   ( matnr = 'MATERIAL-002'                     mtart = 'FOOD'                     matkl = '1020'                     text1 = 'SECOND material' ) ). 
测试结果：
此外，VALUE语句作为结构时，可以直接在特定语句中使用
APPEND VALUE #( value = 'TEST' ) TO lt_data.
MODIFY lt_data FROM VALUE #( checkbox = 'X' ) TRANSPORTING checkbox WHERE checkbox IS INITIAL.
测试结果：
 BASE
ZDEMO_01_006
在使用 VALUE 作为赋值语句时，默认会覆盖原有的数据，通过BASE子句基于原有数据进行赋值
在结构赋值语句中使用 BASE 时，原有字段的数据会被保留，但是当在VALUE语句中对同一字段再次赋值时，该字段数据会被覆盖
例：
DATA(lwa_data) = VALUE gty_data( matnr = 'MATERIAL-001'                                 mtart = 'FOOD' ).lwa_data = VALUE #( BASE lwa_data                    mtart = 'WATR'                    matkl = '1020'                    text1 = 'FIRST material' ).
测试结果：
在内表赋值语句中使用 BASE 时，内表原有的数据会被保留，新增条目会被追加到内表中，效果同 Append Line
例：
lt_data = VALUE #( ( lwa_data ) ).lt_data = VALUE #( BASE lt_data                   ( matnr = 'MATERIAL-002'                     mtart = 'FOOD'                     matkl = '1030'                     text1 = 'SECOND material' ) ).
测试结果：
注意：使用 BASE 语句时，尽量保持前后结构一致，在使用不同的结构时，可能不报错但数据会错位
 FOR
ZDEMO_01_007
在内表赋值语句中，可以使用FOR语句从其他内表中批量引入数据并处理
注意：建议理清楚逻辑再尝试使用for语句。其实就是表的loop遍历，对每一层loop的工作区进行修改然后传值。重点是where后面的条件语句。
使用FOR语句时，需要为内表定义临时工作区，如LWA_DATA，仅允许在当前语句中使用，赋值过程中会使用到该工作区，但在WHERE条件里，只能直接使用内表的字段名，需要注意的是，WHERE后面接的条件语句必须使用小括号包起来，INDEX INTO 定义的临时变量可用来记录当前操作行的序列，作用与LOOP语句中的系统变量 SY-TABIX 类似
例：
TYPES: lty_table TYPE TABLE OF lty_data WITH DEFAULT KEY.
lt_data = VALUE #( ( matnr = 'MATERIAL-001'                     mtart = 'WATR'                     matkl = '1020'                     text1 = 'FIRST material' )                   ( matnr = 'MATERIAL-002'                     mtart = 'FOOD'                     matkl = '1030'                     text1 = 'SECOND material' )                   ( matnr = 'MATERIAL-003'                     mtart = 'WATR'                     matkl = '1040'                     text1 = 'THIRD material' ) ).DATA(lt_for) = VALUE lty_table( FOR lwa_data IN lt_data
                                INDEX INTO lv_index 
                                WHERE ( mtart = 'WATR' )                                ( matnr = lwa_data-matnr                                  mtart = lwa_data-mtart                                  matkl = CONV #( lv_index )                                  text1 = lwa_data-text1 ) ).
测试结果
在FOR语句中允许将结构作为整体直接进行赋值，但是结构必须与表行兼容，可以用于从内表中获取特定条件的数据
DATA(lt_for) = VALUE lty_table( FOR lwa_data IN lt_data                                 WHERE ( mtart = 'WATR' )                                ( lwa_data ) ).
测试结果：
 
如果结构与表行不兼容，可以嵌套使用CORRESPONDING语句进行赋值，如下例（ CORRESPONDING具体用法可参考后续示例 ）
TYPES:BEGIN OF lty_data_new,        matnr TYPE mara-matnr,        matkl TYPE mara-matkl,      END OF lty_data_new.TYPES: lty_table_new TYPE TABLE OF lty_data_new WITH DEFAULT KEY.
DATA(lt_for) = VALUE lty_table_new( FOR lwa_data IN lt_data                                    WHERE ( mtart = 'WATR' )                                    ( CORRESPONDING #( lwa_data ) ) ).
测试结果：
结构字段过多时，一般建议使用整体赋值，如果少部分字段存在特殊的赋值逻辑，可嵌套使用VALUE以及BASE语句进行处理，将例1的逻辑转换如下：
DATA(lt_for) = VALUE lty_table( FOR lwa_data IN lt_data                                INDEX INTO lv_index                                WHERE ( mtart = 'WATR' )                                ( VALUE #( BASE lwa_data                                           matkl = CONV #( lv_index ) ) ) ).
测试结果：
 LET
ZDEMO_01_008
使用 LET 引入短生命周期变量，可以用来简化部分冗余代码
LET关键字可以使用在VALUE，SWITCH，COND等语句中；
与 FOR 语句类似，LET 语句中定义的临时变量同样只能在当前语句中使用，在其他语句中使用时会检查出语法错误
例：
lwa_line = VALUE #( LET                    lwa_data = VALUE #( lt_data[ matnr = 'MATERIAL-001' ] OPTIONAL )                    lv_string = 'Date:' && sy-datum                     IN                    matnr = lwa_data-matnr                    mtart = lwa_data-mtart                    matkl = lwa_data-matkl                    text1 = lv_string ). 
测试结果：
 CONV
ZDEMO_01_009
数据类型的转换可以用 CONV 实现，部分类型不再需要通过中间变量来转换
合理的使用 CONV 可以避免因为类型不一致而导致的 dump 问题，例如下例的LV_RESULT，即在调用方法时做参数的类型转换
另外，在接口中处理传入参数时，一般情况下也会对数据的类型做对应的转换，但不是所有类型都可以互相转换，例如将含有非数字的 CHAR 类型数据强制转换成 INT 类型时，会抛出异常CX_SY_CONVERSION_ERROR
例：
DATA(lv_string) = '001001.001'.DATA(lv_int) = CONV i( lv_string ).DATA(lv_float) = CONV f( lv_string ).
DATA(lv_division) = 1 / 3.DATA(lv_div) = CONV decfloat34( 1 / 3 ).浮点类型无法直接定义，可以通过类似的方法转化。lv_result = me->get_char20( CONV #( me->get_string( ) ) ).
测试结果：
 SWITCH
ZDEMO_01_010
动态赋值语句，通常根据同一变量的不同数据来动态处理，用法类似于 CASE 语句
注释：查询了f1，没有finally类似的关键字，不存在when语句结束必定会执行语句的功能
SWITCH语句的判断条件相对单一，WHEN关键字后只能使用常量，THEN/ELSE后面可以使用表达式进行赋值
例：
DATA(lv_indicator) = 1.DATA(lv_day) = SWITCH char10( lv_indicator                              WHEN 1 THEN 'Monday'                              WHEN 2 THEN 'Tuesday'                              WHEN 3 THEN 'Wednesday'                              WHEN 4 THEN 'Thursday'                              WHEN 5 THEN 'Friday'                              WHEN 6 THEN 'Saturday'                              WHEN 7 THEN 'Sunday'                              ELSE '404' && '-Error' ). 
测试结果：
 COND
ZDEMO_01_011
动态赋值语句，可以根据不同条件来动态处理，用法类似于CASE/IF语句
COND语句中允许使用较为复杂的判断条件，因此VALUE语句中动态赋值通常会使用COND
例：
DATA(lv_indicator) = 7.DATA(lv_day) = COND char10( WHEN lv_indicator = 1 THEN 'Monday'                            WHEN lv_indicator = 2 THEN 'Tuesday'                            WHEN lv_indicator = 3 THEN 'Wednesday'                            WHEN lv_indicator = 4 THEN 'Thursday'                            WHEN lv_indicator = 5 THEN 'Friday'                            WHEN lv_indicator = 6 THEN 'Saturday'                            WHEN lv_indicator = 7 AND sy-langu EQ 'E'  THEN 'Sunday'                            WHEN lv_indicator = 7 AND sy-langu EQ 'F'  THEN 'Dimanche'                            ELSE '404' && '-Error' ). 
测试结果：
 CORRESPONDING
ZDEMO_01_012
结构赋值语句，CORRESPONDING语句允许控制组件映射关系
在ABAP 7.40之前，主要通过 MOVE-CORRESPONDING 来传递结构化数据，但需要保持结构内部组件名称一致，否则数据将不会被传递，而使用 CORRESPONDING 后，该语句在保持同名组件自动进行数据传递的基础上，MAPPING 可以允许我们将不同名称的组件映射到一起，EXCEPT 可以规避掉我们不需要传值的一些字段
例：
lt_data = VALUE #( ( matnr = 'Material-001'                     mtart = 'WATR'                     matkl = '1020'                     text1 = 'First Material' )                   ( matnr = 'Material-002'                     mtart = 'WATR'                     matkl = '1030'                     text1 = 'Second Material' ) ).DATA(lt_table) = CORRESPONDING lty_table( lt_data                                          MAPPING matnr_c = matnr                                          EXCEPT  matkl ). 
测试结果：
注释：测试未成功。F1中使用方法与新语法不一致。详情参考demo：DEMO_CORRESPONDING_MAPPING。
在 MAPPING 语句中，需要注意两边的字段类型，以免类型不兼容而导致程序 dump
使用DEEP处理深层结构数据，相当于MOVE CORRESPONDING [ EXPANDING NESTED TABLES ]
例：
TYPES: BEGIN OF lty_prod_mat,         matnr TYPE matnr,         mtart TYPE mtart,         matkl TYPE matkl,         bismt TYPE bismt,       END OF lty_prod_mat.DATA: BEGIN OF ls_prod_mats,        section     TYPE char10,        t_materials TYPE TABLE OF lty_prod_mat,      END OF ls_prod_mats.TYPES: BEGIN OF lty_sales_mat,         matnr TYPE matnr,         bismt TYPE bismt,         mtart TYPE mtart,         matkl TYPE matkl,       END OF lty_sales_mat.DATA: BEGIN OF ls_sales_mats,        t_materials TYPE TABLE OF lty_sales_mat,        section     TYPE char10,      END OF ls_sales_mats.SELECT matnr mtart matkl bismt FROM mara  INTO CORRESPONDING FIELDS OF TABLE ls_sales_mats-t_materials UP TO 3 ROWS.ls_prod_mats = CORRESPONDING #( DEEP ls_sales_mats ).
测试结果：
使用BASE保留初始数据，为内表赋值时相当于MOVE CORRESPONDING [ KEEPING TARGET LINES ]，为结构赋值时类似于VALUE [ BASE ]
例：
lt_data = VALUE #( ( matnr = 'Material-001'                     mtart = 'WATR'                     matkl = '1020'                     text1 = 'First Material' )                   ( matnr = 'Material-002'                     mtart = 'WATR'                     matkl = '1030'                     text1 = 'Second Material' ) ).lt_table = VALUE #( ( matnr = 'Material-001'                      mtart = 'FOOD' )                    ( matnr = 'Material-002'                      mtart = 'WATR') ).lt_table = CORRESPONDING #( BASE ( lt_table ) lt_data EXCEPT matkl ).
测试结果：
CORRESPONDING中可以从两个内表中引入数据，FORM子句后的内表结构需要定义为排序表或哈希表
该语法不能与DEEP/BASE关键字同时使用，但是可以使用MAPPING/EXCEPT
如下例所示，以表1为基表，根据USING定义的关联条件去表2查找数据，如果查找到，则将表2的该条数据复写到表1对应的记录上并返回，否则直接返回表1的数据
MAPPING/EXCEPT作用于表2数据复写到表1对应记录的过程中，特定条件下可以用来实现读取数据并更新内表的操作，但是需要定义非标准表，有一定的局限性
例：
TYPES:BEGIN OF lty_data,        index TYPE char4,        text1 TYPE char10,        text2 TYPE char10,      END OF lty_data.DATA: lt_tmp1 TYPE SORTED TABLE OF lty_data WITH UNIQUE KEY index,      lt_tmp2 TYPE SORTED TABLE OF lty_data WITH UNIQUE KEY index,      lt_data TYPE TABLE OF lty_data.lt_tmp1 = VALUE #( ( index = '0001' text1 = 'X' )                   ( index = '0004' text1 = 'X' )                   ( index = '0009' text1 = 'X' )                   ( index = '0021' text1 = 'X' ) ).lt_tmp2 = VALUE #( ( index = '0001' text2 = 'Y' )                   ( index = '0002' text2 = 'Y' )                   ( index = '0003' text2 = 'Y' )                   ( index = '0004' text2 = 'Y' ) ).lt_data = CORRESPONDING #( lt_tmp1 FROM lt_tmp2 USING index = index ).“from后表的数据传递给前表，按照using后条件操作”
lt_data = CORRESPONDING #( lt_tmp1 FROM lt_tmp2 USING index = index EXCEPT text1 ).“可以使用mapping和except”
测试结果：
 MOVE-CORRESPONDING（DEEP）
ZDEMO_01_013
在 ABAP 7.40 后，MOVE-CORRESPONDING语句针对深层结构赋值进行了扩展，并且允许保留结构在被赋值前的数据
在深层结构中使用 MOVE-CORRESPONDING传递数据时，需要保持嵌套的深层次结构一致，包括字段名以及顺序等，否则数据会错位
例：
TYPES: BEGIN OF lty_prod_mat,         matnr TYPE matnr,         mtart TYPE mtart,         matkl TYPE matkl,         bismt TYPE bismt,       END OF lty_prod_mat.DATA: BEGIN OF ls_prod_mats,        section     TYPE char10,        t_materials TYPE TABLE OF lty_prod_mat,      END OF ls_prod_mats.DATA: BEGIN OF ls_sales_mats,        section     TYPE char10,        t_materials TYPE TABLE OF lty_prod_mat,      END OF ls_sales_mats.SELECT matnr mtart matkl bismt FROM mara  INTO CORRESPONDING FIELDS OF TABLE ls_sales_mats-t_materials
 UP TO 3 ROWS.MOVE-CORRESPONDING ls_sales_mats TO ls_prod_mats. 
测试结果：
使用 EXPANDING NESTED TABLES 避免因结构不一致而导致的数据异常，对于深层结构，只有相同名称的字段被复制，且不需要它们顺序相同，但是该语句只考虑第一级的深层次结构，不适用于更深层次的数据
例：
TYPES: BEGIN OF lty_sales_mat,         matnr TYPE matnr,         bismt TYPE bismt,           mtart TYPE mtart,         matkl TYPE matkl,       END OF lty_sales_mat. DATA: BEGIN OF ls_sales_mats,        t_materials TYPE TABLE OF lty_sales_mat,        section     TYPE char10,      END OF ls_sales_mats. 
MOVE-CORRESPONDING ls_sales_mats TO ls_prod_mats.MOVE-CORRESPONDING ls_sales_mats TO ls_prod_mats EXPANDING NESTED TABLES. 
测试结果：
在使用 MOVE-CORRESPONDING 时，默认都会先清空目标结构的数据，再将数据填充到结构里面，当我们需要保留目标结构原有的数据时，可以使用 KEEPING TARGET LINES 语句，该语句适用于表结构赋值，且不会修改原有的记录，仅添加需要填充的数据
例：
SELECT matnr mtart matkl bismt
  FROM mara
  INTO CORRESPONDING FIELDS OF TABLE ls_sales_mats-t_materials
  UP TO 4 ROWS.
 
SELECT matnr mtart matkl bismt
  FROM mara
  INTO CORRESPONDING FIELDS OF TABLE ls_prod_mats-t_materials
  UP TO 1 ROWS.
 
MOVE-CORRESPONDING ls_sales_mats-t_materials TO ls_prod_mats-t_materials KEEPING TARGET LINES. 
测试结果：
 REDUCE
ZDEMO_01_014
REDUCE赋值语句一般用于需要循环处理的数据。
注意：和value赋值语句中的for类似，但是更加复杂，使用前注意理清楚逻辑，不建议使用。
一般情况下，我们可以使用 REDUCE 来统计内表中特定条件的记录条数，或是汇总/拼接内表的部分字段
例：
lt_data = VALUE #( ( matnr = 'Material-001'                     mtart = 'WATR'                     matkl = '1020'                     int   = 10086 )                   ( matnr = 'Material-002'                     mtart = 'WATR'                     matkl = '1030'                     int   = 666 ) ).lv_lines = REDUCE #( INIT lv_result = 0                     FOR ls_data IN lt_data WHERE ( matkl = '1020' )                      NEXT lv_result = lv_result + 1 ).
测试结果：
REDUCE语句中可以使用UNTIL关键字，在使用时需要注意 NEXT 语句至少会被执行一次，作用类似于DO循环，限制条件可以自行定义
例：
lv_count = REDUCE #( INIT lv_compt = 0                     FOR i = 1 UNTIL i > lines( lt_data )                     NEXT lv_compt = lv_compt + VALUE #( lt_data[ i ]-int OPTIONAL ) ).
测试结果：
REDUCE语句返回值为结构时，常用来汇总字段或作其他处理（例如取最大值/最小值/平均值等）
例：
TYPES:BEGIN OF lty_result,        sum   TYPE s_distance, 
        count TYPE i,        max   TYPE s_distance,        min   TYPE s_distance,      END OF lty_result.TYPES: lty_table TYPE TABLE OF lty_result WITH DEFAULT KEY.SELECT distance FROM spfli INTO TABLE @DATA(lt_table) UP TO 5 ROWS WHERE distance > 0.DATA(lwa_result) = REDUCE #( INIT lwa_tmp = VALUE lty_result( )                             FOR lwa_table IN lt_table                             INDEX INTO lv_index                             NEXT lwa_tmp = VALUE #( BASE lwa_tmp                                                     sum   = lwa_tmp-sum + lwa_table-distance                                                     count = lwa_tmp-count + 1                                                     max   = nmax( val1 = lwa_tmp-max val2 = lwa_table-distance )                                                     min   = COND #( WHEN lv_index = 1 THEN lwa_table-distance                                                                     ELSE nmin( val1 = lwa_tmp-min val2 = lwa_table-distance ) ) ) ).
测试结果：
REDUCE语句返回值为内表时，常用来汇总内表记录，可适用于深层嵌套的内表
例：
TYPES:BEGIN OF lty_field,        row TYPE i,        col TYPE i,      END OF lty_field.TYPES:lty_field_tab TYPE TABLE OF lty_field WITH DEFAULT KEY.TYPES:BEGIN OF lty_data,        check TYPE char1,        field TYPE lty_field_tab,      END OF lty_data.
DATA: lt_data TYPE TABLE OF lty_data.
lt_data[] = VALUE #( ( check = abap_true                       field = VALUE #( ( row = 1 col = 1 )                                        ( row = 1 col = 3 )                                        ( row = 1 col = 5 ) ) )                     ( check = abap_false                       field = VALUE #( ( row = 2 col = 1 )                                        ( row = 2 col = 2 )                                        ( row = 2 col = 3 ) ) )                     ( check = abap_true                       field = VALUE #( ( row = 3 col = 2 )                                        ( row = 3 col = 4 )                                        ( row = 3 col = 6 ) ) ) ).DATA(lt_fields) = REDUCE #( INIT lt_temp = VALUE lty_field_tab( )                            FOR ls_data IN lt_data                            WHERE ( check = abap_true )                            NEXT lt_temp = VALUE #( BASE lt_temp                                                    FOR ls_field IN ls_data-field                                                    ( ls_field ) ) ).
测试结果：
 GROUP BY （FOR LOOP）
ZDEMO_01_015
在 LOOP 语句中使用 GROUP BY 实现分组处理数据
在 LOOP 中使用 GROUP BY 后，LWA_DATA 中不会存储相应的数据，同样，如果使用 FIELD-SYMBOL，也不会被分配，如果需要修改内表数据，只能通过每个组进行修改，对内表数据进行分组时，可通过 ASCENDING / DESCENDING 按组排序，否则按前后的顺序依次输出；
GROUP BY 在需要使用多个字段进行分组时：GROUP BY  (  KEY1 = field1  KEY2 = field2  …  )
例：
lt_data = VALUE #( ( matnr = 'Material-001'                     mtart = 'FOOD'                     matkl = '1020'                     text1 = 'FIRST' )                   ( matnr = 'Material-002'                     mtart = 'WATR'                     matkl = '1030'                     text1 = 'SECOND' )                   ( matnr = 'Material-003'                     mtart = 'WATR'                     matkl = '1020'                     text1 = 'THIRD' ) ). 
LOOP AT lt_data INTO DATA(lwa_data) GROUP BY lwa_data-matkl INTO DATA(g1).  lt_table = VALUE #( FOR lwa_table IN GROUP g1 ( lwa_table ) ).ENDLOOP. 
测试结果：
如果需要根据自定义条件进行分组，可以使用 COND 语句将特定条件转换成字符或数字再进行分组
例：
lt_data = VALUE #( ( matnr = 'Material-001'                     mtart = 'FOOD'                     matkl = '1020'                     text1 = 'FIRST' )                   ( matnr = 'Material-002'                     mtart = 'WATR'                     matkl = '1030'                     text1 = 'SECOND' )                   ( matnr = 'Material-003'                     mtart = 'WATR'                     matkl = '1010'                     text1 = 'THIRD' ) ). LOOP AT lt_data INTO DATA(lwa_data)                GROUP BY COND string( WHEN lwa_data-matkl = '1020' THEN 'A'                                      ELSE 'B' ) DESCENDING INTO DATA(g1).  lt_table = VALUE #( FOR lwa_table IN GROUP g1 ( lwa_table ) ).ENDLOOP. 
测试结果：
修改内表数据示例如下，第一层 LOOP 遍历的是每个组，第二层遍历的是对应组里的数据，我们需要在第二层做变更
例：
lt_data = VALUE #( ( matnr = 'Material-001'                     matkl = '1020'                     text1 = 100 )                   ( matnr = 'Material-002'                     matkl = '1030'                     text1 = 200 )                   ( matnr = 'Material-003'                     matkl = '1020'                     text1 = 300 ) ). LOOP AT lt_data INTO DATA(lwa_data) GROUP BY lwa_data-matkl ASCENDING INTO DATA(g1).  DATA(lv_count) = REDUCE #( INIT lv_index = 0 
                             FOR lwa_group IN GROUP g1                             NEXT lv_index = lv_index + lwa_group-text1 ).  LOOP AT GROUP g1 ASSIGNING FIELD-SYMBOL(<fs_line>).    <fs_line>-text1 = lv_count.  ENDLOOP.ENDLOOP.
测试结果：
 FILTER
ZDEMO_01_016
使用 FILTER 根据条件来过滤内表数据
使用 FILTER 时，待过滤的内表结构至少需要有一个用于访问的 SORTED KEY 或 HASHED KEY，否则不能通过语法检查，另外，在 WHERE 条件中运算符两边的字段类型需要完全兼容，否则也不能通过语法检查；
根据条件进行过滤的功能可以使用 VALUE 嵌套 FOR 语句实现，而且不用考虑内表的键值问题
例：
DATA:lt_data TYPE TABLE OF lty_data WITH KEY matnr WITH NON-UNIQUE SORTED KEY matkl COMPONENTS matkl. 
lt_data = VALUE #( ( matnr = 'Material-001'                     matkl = '1020'                     text1 = 100 )                   ( matnr = 'Material-002'                     matkl = '1030'                     text1 = 200 )                   ( matnr = 'Material-003'                     matkl = '1020'                     text1 = 300 ) ).DATA(lt_filter) = FILTER #( lt_data USING KEY matkl WHERE matkl = CONV matkl( '1020' ) ).“conv对值进行类型转换”
data(lt_filter2) = FILTER #( lt_data USING KEY matkl WHERE matkl (运算符) CONV matkl( '1020' ) ).“可以填入比较运算符”
测试结果：
参照内表来过滤数据时，被参照的内表仍然需要有 SORTED KEY 或 HASHED KEY，对于过滤数据的内表没有键值要求；
在 FILTER 语句中可以通过 EXCEPT 关键字来指定是需要过滤数据还是保留数据；
该语法可以实现 FOR ALL ENTRIES IN，但是需要将数据全部取出，影响性能，不建议使用，且在 ABAP 7.52 后，允许将内表作为数据源，可以用来代替 FOR ALL ENTRIES IN 使用
例：
DATA: lt_data TYPE SORTED TABLE OF lty_data WITH UNIQUE KEY matnr,      lt_temp TYPE TABLE OF lty_data.lt_data = VALUE #( ( matnr = 'Material-001' matkl = '1020' )                   ( matnr = 'Material-002' matkl = '1030' )                   ( matnr = 'Material-003' matkl = '1020' ) ).lt_temp = VALUE #( ( matnr = 'Material-002' matkl = '1000' )                   ( matnr = 'Material-002' matkl = ’1040' )                   ( matnr = 'Material-004' matkl = '1020' ) ).DATA(lt_filter) = FILTER #( lt_temp IN lt_data WHERE matnr = matnr ).
DATA(lt_except) = FILTER #( lt_temp EXCEPT IN lt_data WHERE matnr = matnr ).  
测试结果：
 EXACT
ZDEMO_01_017
关键字 EXACT 可以用来检查操作语句返回值是否存在丢失，如果存在丢失则会抛出异常
抛出异常的范围比CONV更广，例如将CHAR10的数据赋值到CHAR1时，因此在使用时需要注意异常的捕获，如果没有特殊的处理或属性需求，可以直接使用父类异常 CX_SY_CONVERSION_ERROR 进行捕获
判断数值语句是否被精确计算，如下实际抛出的异常是CX_SY_CONVERSION_ROUNDING，获取到该异常类中的属性字段VALUE的数据
例：
TRY .    DATA(lv_data) = EXACT #( 3 * ( 1 / 3 ) ).  CATCH cx_sy_conversion_rounding INTO DATA(lo_except).    DATA(lv_result) = lo_except->value.ENDTRY.
测试结果：
字段类型不兼容时，如下实际抛出的异常是 CX_SY_CONVERSION_NO_NUMBER，这里获取的是父类CX_SY_CONVERSION_ERROR中的返回信息
例：
TYPES lty_num TYPE n LENGTH 10.TRY .  DATA(lv_num) = EXACT lty_num( '4 Apples' ).CATCH cx_sy_conversion_error INTO DATA(lo_convert).  DATA(lv_error) = lo_convert->get_text( ).ENDTRY. 
测试结果：
ENUM枚举
ZDEMO_01_019
1ENUM 定义一个结构样式的集合，包含枚举类型的枚举值。如果某个字段参考枚举类型，则字段定义必须为枚举集里面的枚举类型，否则报错。
实例1：
TYPES:BEGIN OF ENUM colors1,  black,  red,  gold,END OF ENUM colors1.DATA mycolor1 TYPE colors1.mycolor1 = black. 注释：如果此处修改为mycolor1 = orange.则无法激活，报错。
 实例2：
TYPES:BEGIN OF ENUM colors2 STRUCTURE colors2_values,  red1,  white1,  blue1,END OF ENUM colors2 STRUCTURE colors2_values.DATA mycolor2 TYPE colors2.mycolor2 = colors2_values-red1.
实例3:
TYPES:BEGIN OF ENUM colors3 STRUCTURE colors3_values BASE TYPE int1,   red2 VALUE IS INITIAL,   green2 VALUE 42,   blue2 VALUE 255,END OF ENUM colors3 STRUCTURE colors3_values.DATA mycolor3 TYPE colors3.mycolor3 = colors3_values-green2.
Ipow预定义函数
ZDEMO_01_020
语法
... ipow( base = arg exp = n ) ...
它用于求arg的n次幂，arg和n都为数字表达式。arg可以为任意数值类型，n为可以为i类型的数据或可以转换为i类型的其它数据类型。如果arg的值为0，则n必须大于或等于0。
它的返回类型可以有多种类型：
如果它用于非数学表达式，它的返回类型由arg的类型决定。
如果它用于数学表达式，它先将arg转化为整个数据表达式的类型，再用转换后的结果进行计算。
如果arg是一个数字表达式，ipow与运算符一样计算表达式的结果。
注意
ipow可以替代arg ** n，如果arg的类型不为f，如果是f类型，它会导致计算结果更加精确。
在很多情况下，ipow比操作符“**”拥有更好的效率。
判断方法
ZDEMO_01_021
... meth( ... ) ...
判断方法调用是一个关系表达式的唯一操作数是一个功能方法调用meth( ... )。如果调用的方法返回值不为空，则关系表达式的值为真；如果方法返回的值为空，则关系表达式的值为假。功能方法调用的结果（功能方法的返回值）可以是任何类型。检查基于类型的初始值判断。
与其它关系表达式一样，判断方法调用可以是一个完整的逻辑表达式，也可以是逻辑表达式的一部分。这意味着它可以指定为控制语句或其它语句的条件、布尔函数或条件表达式的参数、或与布尔操作的连接。
注意
带abap_bool类型的返回值的判断方法尤其适合作为判断方法调用。在判断方法调用中调用一个判断方法模拟了一个方法调用，它的返回值有的真的布尔数据类型在ABAP中不存在
通常，功能方法调用meth( ... )可以指定为单独的方法或者链式方法调用。如果第一次调用的方法为实例方法，这个功能方法调用也可以用实例操作符NEW和对象转换操作符CAST来创建实例
除了专有的判断函数和过时的简写形式，判断方法调用是唯一可以创建单个操作数的关系表达式
对于其它表达式或数据对象，完整判断表达式IS INITIAL或比较必须用来检查空值，并且这通常不推荐用于多个表达式
●语法
新的布尔函数xsdbool返回类型为c长度为1的值为“X”或空，返回值取决于参数中的逻辑表达式的真值。它扩展了现有的带string类型返回值的函数boolc，这与文本字段的比较和对初始值的检查中，会产生难以预料的结果
xsdbool的返回值引用了特殊的ABAP字典类型XSDBOOLEAN。这意味着它在CALL TRANFORMATION解析和封装asXML和asJSON中被当成一个真值处理，ABAP中的“X”和“”在XML和JSON被赋值为true和false
现在调用boolc会出现语法警告
xsdbool可以被指定为一般表达式位置或字符型表达式位置
●注意
xsdbool的结果可以用来当成类型abap_bool的值和常量abap_true和abap_false进行比较
xsdbool一般不能直接用处理函数（例如translate）实现，因为类型c的文本字段尾部空格会被忽略，false逻辑表达式的结果就会被忽略。带string返回类型的函数boolc的结果更适合转换这些类型
缩写xsd代表XML schema数据类型
Is instance of
ZDEMO_01_022
●语法
... oref IS [NOT] INSTANCE OF class|intf 
判断表达式IS INSTANCE OF的检查如下：
是否非空对象引用变量oref的动态类型更加特殊或等于比较类型
是否空对象引用变量oref的静态类型更加特殊或等于比较类型
比较的类型必须是对象类型，也就是说用class指定的类或用intf指定的接口可以在这儿使用。oref是一个静态类型为类或接口的对象引用变量。oref是一个和般表达式位置
在以下情况时，表达式的值为true，或使用NOT时为false：
对象引用变量oref不为空，并且指向一个对象，这个对象对应的类满足以下条件：
指定类class时，对象oref为class类型或它的子类类型
指定接口intf时，对象oref为实现接口intf的类类型
对象引用变量oref为空，它的静态类型满足以下条件
为class类型或它的子类类
包含接口intf作为一个组件
●示例
结合概念逐个的分析，这个例子
Cls1类型为一个普通的对象类型，intf为类cls里面的一个公共方法，通过IS INSTANCE OF做比较，返回表达式false.
Cls2为实例化的一个cls类的对象，根据概念“指定接口intf时，对象oref为实现接口intf的类类型，返回值为true”，对象cls2为实现接口的类cls的实例化类型，所以返回值为true.
Cls3为接口intf的一个直接引用变量，满足“包含接口intf作为一个组件”，所以返回值为true
Cls4为类cls的一个引用变量，为实现接口intf的类的类型，所以返回值为true
Case type of 
ZDEMO_01_023
●语法
CASE TYPE OF oref   [WHEN TYPE class|intf [INTO target1].     [statement_block1]]   [WHEN TYPE class|intf [INTO target2].     [statement_block2]]   ...   [WHEN OTHERS.     [statement_blockn]] ENDCASE. 
对象引用变量的特殊分支语句。它检查非空数据引用变量oref的动态类型及和空数据引用变量oref的静态类型。oref是一个静态类型为类或接口的引用变量，它是一个一般表达式位置
类class或接口intf必须在WHEN TYPE后面指定。类class或接口intf比较以下更通用时，对应的语句块statement_block会执行：
非空数据引用变量oref的动态类型
空数据引用变量oref的静态类型
如果没有任何一个WHEN TYPE分支被执行，则WHEN OTHERS后面的语句块statement_block会执行。
●注意
1、分支语句CASE TYPE OF与IF与IS INSTANCE OF的组合语句相同。以上语法等同于以下语法：
IF oref IS INSTANCE OF class|intf.   [statement_block1] ELSEIF oref IS INSTANCE OF class|intf.   [statement_block2] ... ELSE.   [statement_blockn] ENDIF.
2、这个控制结构必须在前面指定更特殊的类或接口、在后面指定更通用的类或接口以确保相关的语句块执行
●示例
例子分析，首先定义了一个c1的类，然后由c2继承c1，c3继承c2,c2为c1的子类，c3为c2的子类，oref为c2实例化的一个对象
CASE TYPE OF oref
  WHEN TYPE c3
实际上就相当于 oref IS INSTANCE OF c3的一个用法
而WHEN TYPE C2
   Ref2 ? = oref
也与
  WHEN TYPE c2 INTO ref2语义相同
2 Open SQL
CONSTANT
常量字段可以用来为内表中的部分字段赋初始值
例：
SELECT carrid, 'S' AS status  FROM scarr    UP TO 5 ROWS  INTO TABLE @DATA(lt_scarr). 
测试结果：
当数字太大，不在INT4类型范围内时，会被解释为DEC类型；
当只需要判断数据库表中是否存在特定的记录并且不用取表数据时，可以用常量字段代替
例：
DATA(lv_carrier) = CONV s_carr_id( 'AA' ).SELECT SINGLE @abap_true  FROM scarr WHERE carrid = @lv_carrier  INTO @DATA(lv_exist).IF lv_exist = abap_true.  "...ENDIF. 
测试结果：
上例也可以用COUNT( * ) / COUNT(*) 代替，使用COUNT( * ) 来查找特定记录时，可以不指定INTO语句，即不需要声明变量来存储数据，直接判断SUBRC的返回值
例：
DATA(lv_carrier) = CONV s_carr_id( 'AA' ).SELECT COUNT( * )  FROM scarr WHERE carrid = @lv_carrier.IF sy-subrc IS INITIAL.  DATA(lv_success) = 'X'.ELSE.  DATA(lv_error) = 'X'.ENDIF.
测试结果：
Typed Literals （refer F1）  
可以使用INTO table @DATA(lv_exist)新建变量接收数据，可以用类型文字语法在sql中新建all  built-in ABAP Dictionary types常量；
SELECT *        FROM dbtab        WHERE char_col = char`hallo`          AND int_col = int8`123`
 Host Variable / Expression
在查询语句中使用 @ 作为转义符
通常在查询语句中，程序声明（非数据库层级）的变量前需要使用转义符 @ 进行标识，这些 Host Variable 通常被用作 Open SQL 语句中的操作数
在查询语句内部声明结构/内表时，应该在 DATA 前使用转义符
此外，在使用 Host Expression（在 Open SQL 中作为操作数使用的一些表达式） 时，也需要添加转义字符，如下例所示
（注：表达式内部的变量不需要再使用转义符，且不能使用表达式外部的数据库对象）
例：
SELECT matnr,       @( COND #( WHEN sy-langu = 'E' THEN 'Material'                  WHEN sy-langu = '1' THEN '物料' ) ) AS desc  FROM mara  INTO TABLE @DATA(lt_data)    UP TO @( CONV #( '005' ) ) ROWS. SELECT matnr, maktx  FROM makt WHERE spras = @sy-langu   AND matnr = @( VALUE #( lt_data[ 5 ]-matnr OPTIONAL ) )  INTO TABLE @DATA(lt_desc). 
测试结果：
Aggregate Expressions
聚合表达式用于对一组值执行计算并返回单一的值，可以使用在SELECT或HAVING子句中，不能用在WHERE子句
WHERE与HAVING的区别：
WHERE 子句的搜索条件在进行分组操作之前应用；而 HAVING 的搜索条件则在进行分组操作之后应用
常见的聚合表达式如下，表达式内部可选用DISTINCT对数据去重后再进行处理：
AVG：返回结果集的平均值，返回类型默认为浮点型，可通过AS语句返回指定类型，如DEC，CURR，QUAN或FLTP
MAX：返回结果集的最大值
MIN：返回结果集的最小值
SUM：返回结果集的汇总值
COUNT：返回结果集的条目数，通常情况下使用COUNT( * ) / COUNT(*)，需要使用DISTINCT时则要指定字段名
例：
TYPES:BEGIN OF lty_data,        num   TYPE char2,        value TYPE i,      END OF lty_data.DATA: lt_data TYPE TABLE OF lty_data.lt_data = VALUE #( ( num = '01' value = 10 )                   ( num = '01' value = 27 )                   ( num = '02' value = 16 )                   ( num = '02' value = 35 )                   ( num = '02' value = 16 )                   ( num = '03' value = 19 )                   ( num = '04' value = 12 )                   ( num = '04' value = 25 ) ).
SELECT num,       MAX( value ) AS max,       MIN( value ) AS min,       AVG( value AS DEC( 12,2 ) ) AS avg,       SUM( value ) AS sum,       COUNT(*) AS count,       AVG( DISTINCT value AS DEC( 12,2 ) ) AS avg_dis,       SUM( DISTINCT value ) AS sum_dis,       COUNT( DISTINCT value ) AS count_dis  FROM @lt_data AS a GROUP BY num ORDER BY num  INTO TABLE @DATA(lt_result).
测试结果：
更多聚合函数，尽在F1：
... AVG,   MEDIAN,   MAX,   MIN,   SUM,   PRODUCT,   STDDEV,   VAR,   CORR,   CORR_SPEARMAN,
   STRING_AGG,   COUNT,   GROUPING( col ),   ALLOW_PRECISION_LOSS( ... ) 
Built-In Functions
    在sql语句中使用函数（expresiveness）处理数据，参考F1；
 Built-In Functions（Num）
在 SELECT LIST 使用内嵌表达式来处理数值，使用时需注意传入参数的类型
常见的数值表达式如下：
ABS：获取绝对值
CEIL：向上取整
FLOOR：向下取整
DIV：除法计算，取整数位
DIVISION：除法计算，保留 N 位小数
MOD：除法计算，取余数
ROUND：计算舍入值
例：
DATA(lv_dec) = CONV zdec_3_demo( '-123.456' ).SELECT SINGLE       @lv_dec AS original,       abs( @lv_dec ) AS abs,       ceil( @lv_dec ) AS ceil,       floor( @lv_dec ) AS floor,       div( -4 , -3 ) AS div,       division( -4 , -3 , 2 ) AS division,       mod( -4 , -3 ) AS mod,       round( @lv_dec , 2 ) AS round_po,       round( @lv_dec , -2 ) AS round_ne  FROM sflight  INTO @DATA(lwa_data). 
测试结果：
 Built-In Functions（String）
在 SELECT LIST 使用内嵌表达式来处理字符串, 通常情况下字符串返回结果不能超过255个字符，如果字符长度异常，语法检查时会有错误提示
CONCAT：连接字符串，参数固定为2个，各个表达式之间可以嵌套使用，CONCAT内部也可以使用 &&
&&：连接字符串，参数没有个数限制，但不能将其他内嵌表达式当作参数使用，仅作为操作符使用，在非SELECT语句中也可以被使用
CONCAT_WITH_SPACE：连接字符串，并用 N 个空格分隔，该表达式结果不能超过1333个字符
INSTR：遍历字符串，查找指定字符 s1 并返回第一次出现的位置，没有查到则返回0
LEFT/RIGHT：从字符串左/右侧开始取出 N 位字符，忽略前导/尾部的空格
LENGTH：计算字符串长度
例：
SELECT concat( carrid , currcode ) AS concat,
       carrid && currcode AS concat_sign,       concat_with_space( carrid , currcode , 1 ) AS with_space,       instr( carrid , 'BA' ) AS instr,       left( carrname , 4 ) AS left,
       right( carrname , 4 ) AS right,       length( carrname ) AS length  FROM scarr  INTO TABLE @DATA(lt_data)    UP TO 5 ROWS. 
测试结果：
LOWER/UPPER：将字符串转换成小写/大写
LPAD/RPAD：在字符串左侧/右侧填充指定字符 s1，直到字符串长度为 N，如果初始值长度>=N，则不会填充，但是超过 N 位的字符会被截断
LTRIM/RTRIM：从字符串左侧/右侧开始逐个删除指定字符 s1，直到出现其他字符为止，默认会删除尾部的空格
REPLACE：将字符串中所有的指定字符 s1 用其他字符 s2 代替
SUBSTRING：从字符串第 N 位开始截取长度为 M 的字符，系统会默认检查截取范围是否超出该字段最大长度，以避免造成DUMP
例：
SELECT lower( carrid ) AS lower,       upper( carrid ) AS upper,       lpad( carrid , 5 , 'B' ) AS lpad,       rpad( carrid , 5 , 'B' ) AS rpad,       ltrim( carrid , 'A' ) AS ltrim,       rtrim( carrid , 'A' ) AS rtrim,       replace( carrid , 'A' , '@' ) AS replace,       substring( carrname , 5 , 10 ) AS substring   FROM scarr  INTO TABLE @DATA(lt_data)    UP TO 3 ROWS. 
测试结果：
 Built-In Functions（Date/Time）
在 SELECT LIST 使用内嵌表达式来处理日期/时间
DATS_IS_VALID/TIMS_IS_VALID：校验日期/时间有效性，有效时返回 1，否则返回 0
DATS_DAYS_BETWEEN：计算日期d1和d2相隔的天数
DATS_ADD_DAYS：为指定日期加上N天
DATS_ADD_MONTHS：为指定日期加上N月
例：
DATA(lv_date) = CONV datum( '20181022' ). 
SELECT fldate AS original_date,       dats_is_valid( fldate ) AS valid_date,       tims_is_valid( @sy-uzeit ) AS valid_time,        dats_days_between( fldate , @lv_date ) AS between,       dats_add_days( fldate , 10 ) AS add_days,       dats_add_months( fldate , 3 ) AS add_months  FROM sflight  INTO TABLE @DATA(lt_data)    UP TO 3 ROWS. 
测试结果：
 Built-In Functions（Time Stamp）
在 SELECT LIST 使用内嵌表达式来处理时间戳
TSTMP_IS_VALID：校验时间戳有效性，有效时返回 1，否则返回 0
TSTMP_CURRENT_UTCTIMESTAMP：返回当前时间戳
TSTMP_SECONDS_BETWEEN：计算时间戳 t1 和 t2 相隔的秒数，需要用赋值语句进行传参，可以添加相应的错误处理
TSTMP_ADD_SECONDS：为指定时间戳加上 N 秒，N 必须为 timestamp 类型
例：
DATA(lv_stamp_now) = CONV timestamp( '20190603133559' ).DATA(lv_stamp_past) = CONV timestamp( '20190602161408' ).SELECT tstmp_is_valid( @lv_stamp_now ) AS valid_stamp,       tstmp_current_utctimestamp( ) AS current_stamp,       tstmp_seconds_between( tstmp1 = @lv_stamp_past,                              tstmp2 = @lv_stamp_now,                              on_error = @sql_tstmp_seconds_between=>set_to_null ) AS between,       tstmp_add_seconds( tstmp = @lv_stamp_now,                          seconds = @( CONV timestamp( 999 ) ),                          on_error = @sql_tstmp_add_seconds=>set_to_null ) AS add_second  FROM sflight  INTO TABLE @DATA(lt_data)    UP TO 1 ROWS.
测试结果：
 Built-In Functions（Time Zone）
在 SELECT LIST 使用内嵌表达式来处理时区
ABAP_USER_TIMEZONE：获取用户时区，不传参时默认获取当前用户当前 Client 的时区
ABAP_SYSTEM_TIMEZONE：获取系统时区，不传参时默认获取当前 Client 的时区
例：
SELECT abap_user_timezone( user = @( CONV uname( 'JIANGRE' ) ),                           client = '130',                           on_error = @sql_abap_user_timezone=>set_to_null ) AS user_zone,       abap_system_timezone( client = '130',                             on_error = @sql_abap_system_timezone=>set_to_null ) AS sys_zone  FROM sflight  INTO TABLE @DATA(lt_data)    UP TO 1 ROWS. 
测试结果：
 Built-In Functions（Date/Time Conversion）
在 SELECT LIST 使用内嵌表达式来转换日期/时间/时间戳
TSTMP_TO_DATS：将时间戳转换成对应时区的日期
TSTMP_TO_TIMS：将时间戳转换成对应时区的时间
TSTMP_TO_DST：根据时间戳获取对应时区的夏令时标识
DATS_TIMS_TO_TSTMP：将日期和时间根据时区转换成时间戳
例：
DATA(lv_stamp) = CONV timestamp( '20190603133559' ).SELECT tstmp_to_dats( tstmp = @lv_stamp,                      tzone = @( CONV tznzone( 'CET' ) ) ) AS dats,       tstmp_to_tims( tstmp = @lv_stamp,                      tzone = @( CONV tznzone( 'CET' ) ) ) AS tims,       tstmp_to_dst( tstmp = @lv_stamp,                     tzone = @( CONV tznzone( 'CET' ) ) ) AS dst,       dats_tims_to_tstmp( date = @sy-datum,                           time = @sy-uzeit,                           tzone = @( CONV tznzone( 'CET' ) ) ) AS tstmp  FROM sflight  INTO TABLE @DATA(lt_data)    UP TO 1 ROWS. 
测试结果：
 CASE
在 SELECT 语句中使用 CASE 作为条件语句，与一般条件判断使用的 CASE 类似，但有所区别
该语句不仅可以用于单值判断，也可以根据复杂条件进行判断；
此外，WHEN OTHERS 不再适用，需要使用 ELSE 代替，语句结束时使用 END，而不是 ENDCASE，且需要定义别名
例：
SELECT CASE currcode       WHEN 'EUR' THEN carrname       ELSE url       END AS case_simple,       CASE       WHEN currcode = 'EUR' THEN url       WHEN carrname <> ' '  THEN carrname       ELSE carrid && '@' && currcode       END AS case_complex  FROM scarr  INTO TABLE @DATA(lt_data)    UP TO 5 ROWS. 
测试结果：
 NULL Value
使用条件语句判断并处理 NULL 值
在使用 LEFT / RIGHT OUTER JOIN 关联外表时，如果主表中存在记录，但在外表中没有关联到数据，则外表的这部分字段的值在取数过程中始终为 NULL，在取数完成后传入数据对象时，NULL 会再转换成系统兼容的值，通常为初始值；
NULL 值用于数值计算或是字符串处理时返回结果仍为NULL值，可以在条件语句中用 IS [ NOT ] NULL 判断以及处理
现在表缓存支持真null值了，null值不再被转换为类型初始值；
is initial，类型初始值；
例：
DATA: lr_carrid TYPE RANGE OF s_carr_id.lr_carrid = VALUE #( sign = 'I' option = 'EQ' ( low = 'AA' )                                              ( low = 'CO' ) ).SELECT DISTINCT       r~carrid,       CASE       WHEN t~seatsocc IS NULL THEN 'IS NULL'       WHEN t~seatsocc IS NOT NULL THEN 'IS NOT NULL'       END AS field_status  FROM scarr AS r  LEFT OUTER JOIN sflight AS t ON t~carrid = r~carrid  INTO TABLE @DATA(lt_data) WHERE r~carrid IN @lr_carrid. 
测试结果：
使用内嵌表达式 COALESCE( arg1, arg2, arg3 ... argn )处理NULL值
该表达式用来返回第一个非 NULL 字段，参数至少有2个，至多255个，如果参数都为 NULL，则返回 NULL
例：
DATA: lr_carrid TYPE RANGE OF s_carr_id.lr_carrid = VALUE #( sign = 'I' option = 'EQ' ( low = 'AA' )                                              ( low = 'CO' ) ).SELECT r~carrid,       SUM( 1 ) AS total_lines,       SUM( t~seatsocc ) AS actual_occ,       SUM( t~seatsocc + 1 ) AS total_occ,       SUM( coalesce( t~seatsocc + 1 , 1 ) ) AS correct_occ   FROM scarr AS r  LEFT OUTER JOIN sflight AS t ON t~carrid = r~carrid  INTO TABLE @DATA(lt_data) WHERE r~carrid IN @lr_carrid GROUP BY r~carrid. 
测试结果：
 CAST
在查询语句中使用 CAST 实现字段的类型转换
以获取指定日期的汇率为例，汇率表中存储的日期不能直接使用，例如日期20180831 对应存储的数据为 79819168，所以我们在使用时需要转换类型
在程序中，我们可以调用 FM 来获取汇率，这里只用来测试 CAST 的使用，在CDS View中可能会被使用
例：
DATA(lv_date) = CONV datum( '20180830' ).SELECT MIN( CAST( CAST( @lv_date AS NUMC ) AS INT4 ) -            ( 99999999 - CAST( CAST( gdatu AS NUMC ) AS INT4 ) ) ) AS time_differ,       ukurs AS exchange_rate  FROM tcurr  INTO TABLE @DATA(lt_data) WHERE kurst = 'M'   AND fcurr = 'CNY'   AND tcurr = 'EUR' GROUP BY gdatu, ukursHAVING MIN( CAST( CAST( @lv_date AS NUMC ) AS INT4 ) -            ( 99999999 - CAST( CAST( gdatu AS NUMC ) AS INT4 ) ) ) >= 0 ORDER BY time_differ DESCENDING. 
DATA(lv_exchange_rate) = VALUE #( lt_rate[ 1 ]-exchange_rate OPTIONAL ).
测试结果：
转换规则（ ABAP 7.53 ）如下图：
X：没有特殊限制
Y：初始长度不能小于目标长度
Z：目标长度必须足够显示源数据类型的值
C：初始长度必须等于目标长度
Figure 1 VIP, Very Important Picture
 CDS with Parameters
现支持 SELECT 传入 Parameter 从 CDS View 中获取数据
在查询语句中，参数必须紧接在对应的数据源后边，作为一个整体来使用，否则不能通过语法检查
测试用CDS View如下图所示，该视图需要传入两个参数 ip_matnr 以及 ip_langu
例：
SELECT *  FROM zcds_demo( ip_matnr = 'DHA_DEMO_1',                  ip_langu = @sy-langu ) AS a   INTO TABLE @DATA(lt_data). 
测试结果：
 From Table
Internal Table
在 ABAP 7.52 后，支持将内表作为数据源使用
内表作为数据源使用时，需要定义别名并使用转义符@，该用法可以用来代替 FOR ALL ENTRIES IN，但FROM 语句中最多使用一个内表
dbtab~*选所有字段；
例：
SELECT carrid, connid, countryfr, cityfrom  FROM spfli INTO TABLE @DATA(lt_table) UP TO 3 ROWS.SELECT s~*  FROM scarr AS s INNER JOIN @lt_table AS l ON l~carrid = s~carrid  INTO TABLE @DATA(lt_data). 
测试结果：
Subquery as data source of MODIFY
以子查询为数据源的MODIFY，insert；
数据簇
可以用数据簇方式对 ABAP/4 程序的任何 复杂内部数据对象进行 分组保存；
将其临时存储在 ABAP/4 内存中，多个进程共享；或长时间存储在数据库中，结构为簇数据库；
PROGRAM SAP_TEST_01.
DATA gv_str(10) VALUE 'QQporting'.
EXPORT gv_str txt2 FROM 'Literal'
  TO MEMORY ID 'text'.
SUBMIT SAP_TEST_02 AND RETURN. " 0  Literal
PROGRAM SAP_TEST_02.
DATA: gv_chr(10) type C value ‘怎么没有数据呢。’.
IMPORT txt2 TO gv_chr FROM MEMORY ID 'text'.
WRITE: / SY-SUBRC, gv_chr. " 4 怎么没有数据呢。
在数据库，多个簇表（逻辑表）对应多个表簇（物理存储），簇表-透明表；
EXPORT lv_ITAB TO DATABASE INDX(HK) ID 'Table'.
SELECT * FROM INDX 
  WHERE RELID = 'HK' AND   SRTFD = 'Table'.
IMPORT DIRECTORY INTO lv_ITAB2 FROM DATABASE INDX(HK) ID 'Table'.
 JOIN Expression
在特定的应用场景中，需要使用字符长度不一致的两个字段进行关联时，可以使用相应的表达式处理，但要注意表达式的位置，一般需要放在等式左边，如下例
例：（NAST-OBJKY类型为CHAR30，EKKO-EBELN类型为CHAR10）
SELECT k~ebeln,       t~kschl  FROM nast AS t INNER JOIN ekko AS k ON left( t~objky, 10 ) = k~ebeln  INTO TABLE @DATA(lt_data).
测试结果：
动态SQL，注意select语句括号没空格；
DATA : lv_select TYPE string ,       lv_dbtab TYPE string ,       BEGIN OF lv_data8,         cnam like scarr-carrname,         int8 type int8,         END OF lv_data8,       lt_data8 like TABLE OF lv_data8.  lv_select = `c~carrname as cnam, int8``99`` as int8` .  lv_dbtab = `( scarr AS c `  & ` INNER JOIN spfli AS p ON p~carrid  = c~carrid )`  .SELECT  (lv_select)  FROM  (lv_dbtab)  INTO TABLE @lt_data8 "@data(lt_data8)  UP TO 5 rows  .
CL_DEMO_OUTPUT=>DISPLAY( LT_DATA8 ).
Common Table Expressions (CTE)
SQL Enhancements：
Higher expresiveness in Open SQL ABAP SQL statements, ABAP 7.53，Open SQL已经被更名为ABAP SQL。这个重命名反映出ABAP SQL的某些部分目前只支持特定的数据库平台（SAP HANA数据库），已经不再是全平台独立的了。游标cursor和存储过程属于native SQL；
Code pushdown through new language features
Reduction of existing limitations
Flexible consumption of CDS modeling entities
在from子句使用子查询；
" CTE, coalensce, max join 50, max sub_query 50;
  DATA: lv_empty(8) TYPE c.
  WITH  +mara( matnr, ersda, nul ) AS 
          ( SELECT matnr, ersda, lvorm  FROM mara  ), "UP TO 3 ROWS
        +m2( matnr, coalesce ) AS 
          ( SELECT matnr, @lv_empty AS coalesce FROM +mara )
  SELECT FROM +mara AS mara LEFT OUTER JOIN  +m2 AS m2 ON mara~matnr = m2~matnr
  FIELDS  mara~matnr, 
          coalesce( '截胡', “ 如果不为空则获取此变量并跳出coalesce，否则看下一个参数；
              CASE m2~coalesce WHEN  @lv_empty THEN mara~nul END, “如果为null则看下一个
              m2~coalesce, “如果为空则看下一个
              'coalesce' ) AS col2
  INTO TABLE @DATA(lt_data6)
  UP TO 8 ROWS
  .
  cl_demo_output=>display( lt_data6 ).
运行效果： 
 WHERE Condition
常用的条件语句，整理如下：
[ NOT ] IN：除了 SELECT-OPTION，也支持多个自定义或者通过子查询获取的值
ANY/SOME/ALL：允许将子查询获取到的结果集作为限制条件使用
[ NOT ] BETWEEN ... AND ...：使用范围条件
[ NOT ] LIKE ... [ ESCAPE ]：使用模糊查询           
IS [ NOT ] NULL：判断是否有关联到相应的记录
IS [ NOT ] INITIAL：判断是否为空值
[ NOT ] EXISTS：根据指定条件到数据库表查询数据，判断查询结果是否存在
like_regexpr：匹配正则表达式
例：
SELECT i~*  FROM scarr AS r  LEFT OUTER JOIN spfli AS i ON i~carrid = r~carrid WHERE i~carrid IN ( 'AA' , 'CO' )
   AND i~carrid IN ( SELECT DISTINCT carrid FROM sflight )    AND i~carrid = ANY ( SELECT DISTINCT carrid FROM sflight )   AND i~carrid NOT BETWEEN 'BA' AND 'CA'   AND ( i~carrid LIKE 'A%' OR i~carrid LIKE 'C%' )   AND r~carrid IS NOT NULL   AND i~carrid IS NOT INITIAL   AND EXISTS ( SELECT carrid FROM sflight WHERE carrid = i~carrid )  INTO TABLE @DATA(lt_data). 
where like_regexpr( pcre = '^[Aa]\s*\w+', value = mara~matnr ) > 0
更多精彩尽在se26: CL_ABAP_MATCHER, CL_ABAP_REGEX; 
 OFFSET
从ABAP 7.51开始，Open SQL中引入了关键字OFFSET，可以指定查询结果的开始位置
指定OFFSET时，结果集必须使用ORDER BY进行排序，与UP TO一起使用可以实现分页查询；
可以用union合并多个查询结果，各个查询结果列的数目、名称、顺序、类型一样，union不能与up to n rows一起使用；
例：
DATA: lv_int TYPE i VALUE 1.cl_demo_input=>request( CHANGING field = lv_int ).
SELECT carrid, connid, fldate  FROM sflight ORDER BY carrid, connid, fldate  INTO TABLE @DATA(lt_data) UP TO 10 ROWSOFFSET @( ( lv_int - 1 ) * 10 ).
测试结果：
SELECT char10, int4
    FROM demo_ddic_types
    WHERE char10 = char`hallowelt`
  union all
  SELECT  char10, int8 as int4
    FROM demo_ddic_types
  union distinct
  SELECT  char10, int8 as int4
    FROM demo_ddic_types
  INTO TABLE @DATA(lt_data7)
* up to 8 rows
  .
 Strict Mode
使用了部分新语法后，系统会以严格模式进行语法检查
每个版本有不同的 Strict Mode，但都会包含旧版本的内容，在语法检查时一般都会有提示性的错误信息，我们只需要按提示做修改即可；
但是有些错误信息可能看不出来是哪些语句的问题，这个时候我们就要自己去检查一下新语法的使用规则
部分检查示例：
SLECT LIST 中的字段需要用 ，分隔
本地对象需要使用转义符@
INTO 语句需要放在 SELECT 语句中的最后一部分；不是在select子句末尾，而是整个查询的末尾，但在up to和offset之前；
英文原文：ABAP SQL in Release 7.53
conclusion
Open SQL总结
select
@lv_x1 as col_01, count(*) as col_02, into, appending, into table, 
single, distinct, union, order by, up to lv_size rows, offset, 
from
for all entries in, with, fields, @lt_itab, 
where
having
group by, GROUPING SETS, 
function
case when else, cast,, max(),, floor(),, substring(),, dats_add_days(),, is null, like, in, coalesce; 
senior
事务，锁，缓存，CDS，mesh指针，，，
参考一个集成的程序：ZDEMO_002；
3 Data Processing
String Template 字符串模板
新语法引入了字符串模板，用于处理字符串连接以及格式转换
字符串模板在 | ... | 之间定义，主要分为两部分，固定文本和变量
其中，变量只能在 { ... } 内使用，大括号之外的所有字符均作为固定文本使用，空格始终不会被忽略，见例1
在使用变量时，可以通过控制语句来指定数据的显示格式，如例2，将日期用系统格式输出
在固定文本中，如果出现 | ，{ } 或 \ 等特殊字符时，需要使用转义符 \，如例3
例1：
（1）
DATA(lv_vbeln) = CONV vbeln( '123456' ). "CONV转换字符格式，将lv_vbeln转换为vbeln的格式：char10lv_vbeln = |{ lv_vbeln ALPHA = IN }|.” ALPHA = IN  增加前导0，ALPHA = Out  删除前导0lv_vbeln = | { lv_vbeln ALPHA = IN }|. "对lv_vbeln重新赋值，第一个|与第一个{之间增加了空格，作为固定文本占据一个字符位置
测试结果：
 
注：在第二次赋值时，因为空格已经占据了第一位字符，导致最后一位字符被截断
系统输出时，前导0不显示
（2）当增加固定文本
data(lv_vbeln1) = conv vbeln('123456').lv_vbeln1 = |0{ lv_vbeln1 }7|.
测试结果：
（3）当增加固定文本和前导0
data(lv_vbeln1) = conv vbeln('123456').lv_vbeln1 = |0{ lv_vbeln1  ALPHA = in }7|. 
测试结果：
例2：
（1）将日期转换为系统格式
这里date= environment是用来格式化日期的，将日期转换成系统格式。
DATA(lv_string) = |Today is { sy-datum DATE = ENVIRONMENT }|. 
测试结果：
（2）对日期进行加减
表达式里必须有日期类型d才能使用DATE = environment，对日期进行加减时还需conv
sy-datlo 用于获取当前时间，输出格式：20210524
(1)
TYPES t_date_tab TYPE table of string with empty key.DATA(date_tab) = VALUE t_date_tab(  ( | { conv d( sy-datlo - 1 ) DATE = environment } | )      "当天日期前一天  ( | {         sy-datlo       DATE = environment } | )      "当天日期  ( | { conv d( sy-datlo + 1 ) DATE = environment } | ) ).    "当天日期后一天cl_demo_output=>DISPLAY( date_tab ).
测试结果：
(2)若是直接用数值取代sy-datlo,无法进行日期计算
TYPES t_date_tab1 TYPE table of string with empty key.DATA(date_tab1) = VALUE t_date_tab1(  ( | { conv d( 20210501 - 1 ) DATE = environment } | )   " 00.00.0000  ( | { conv d( 20210501 + 1 ) DATE = environment } | )   " 00.00.0000  ( | { conv d(  20210501   )  DATE = environment } | )   " 00.00.0000  ( | { conv d( 20210531 - 1 ) DATE = environment } | ) )." 00.00.0000cl_demo_output=>DISPLAY( date_tab1 ).
测试结果：
例3：
当有特殊符号时，在前面增加“\”，如：| 、{ } 或 \
data(lv_vbeln1) = conv vbeln('123').lv_vbeln1 = |\\\|{ lv_vbeln1 }\}7|.
测试结果：
Format Option 格式选项
在字符串模板中可以使用多种格式选项
将字符转换为数值：
DATA:lv_dec(16) TYPE p DECIMALS 2.CALL FUNCTION 'UNITS_STRING_CONVERT'  EXPORTING    units_string = '123,456.78'    dcpfm        = 'X' "这个是根据tcode:su01里的数字格式来设置，sap标准的格式有三种：空，X,Y*   MLLN         = 'M'*   TSND         = 'T'  IMPORTING    units        = lv_dec " UNITS  时参照你输入的l_p来定义的  EXCEPTIONS    invalid_type = 1    OTHERS       = 2.
CURRENCY
根据指定货币 cur 调整数值的小数位，参考表 TCURX 【 CURRENCY = cur 】
DATA(lv_currency) =  |{ lv_dec  CURRENCY = 'AU5' }|.  "五位小数,输出123.45678DATA(lv_currency1) = |{ lv_dec  CURRENCY = 'BHD' }|. "三位小数，输出12345.678
测试结果：
当数值为浮点数时，将不会调整小数点位置，而是在浮点数后增加0
DATA(lv_string) = '123456.78'.DATA(lv_dec1) = CONV  f( lv_string ).
DATA(lv_currency2) = |{ lv_dec1 CURRENCY = 'BHD' }|. "三位小数,输出123456.780
测试结果：
COUNTRY ★
根据指定国家 cty 格式化数据（数值/日期/时间），参考表 T005X 【 COUNTRY = cty 】
表 T005X 中字段XDEZP是十进制格式，是否勾选十进制格式，输出格式会有差别
   DATA(lv_country) = |{ lv_dec COUNTRY = 'CN ' }|.    "数值，没有勾上十进制，"."作为千分号，","作为小数间隔   DATA(lv_country1) = |{ lv_dec COUNTRY = 'AU ' }|.   "数值，勾上了十进制,","作为千分号，"."作为作为小数间隔   DATA(lv_country2) = |{ sy-datum COUNTRY = 'CN ' }|. "日期   DATA(lv_country3) = |{ sy-uzeit COUNTRY = 'CN ' }|. "时间
测试结果：
ALPHA ★
添加/移除前导零，返回值与字段类型一致，可使用CONV转换成其他的类型进行处理。默认不做变更（RAW）【 ALPHA = [ IN | OUT | RAW ]  】
DATA(lv_alpha) = |{ CONV char4( '1' ) ALPHA = IN }|. “添加前导0DATA(lv_alpha1) = |{  '0001' ALPHA = OUT }|.         “移除前导0
测试结果：
NUMBER/DATE/TIME ★
设置数值/日期/时间显示格式
RAW：默认值，【数值】使用 . 作为小数点，且没有千分符 【日期/时间】直接输出内容
ENVIRONMENT：使用系统环境设置
USER：使用用户设置
ISO：仅用于设置【日期/时间】，使用 ISO 标准格式，yyyy-mm-dd / hh:mm:ss
DATA(lv_raw) = |{ lv_dec NUMBER = raw }|.             "默认的数值DATA(lv_number) = |{ lv_dec NUMBER = ENVIRONMENT }|.  "系统环境下的数值DATA(lv_date) = |{ sy-datum DATE = USER }|.           "用户设置的日期DATA(lv_time) = |{ sy-uzeit TIME = ISO }|.            "ISO格式下的时间
测试结果：
TIMESTAMP
设置时间戳格式
SPACE：使用空格连接 ISO 格式下的日期和时间，yyyy-mm-dd hh:mm:ss
ISO：使用 ISO 标准格式，yyyy-mm-ddThh:mm:ss
RAW：无格式，直接输出
USER：使用用户设置
ENVIRONMENT：使用系统环境设置
DATA(lv_stamp) = CONV timestamp( '20190601181609' ).DATA(lv_timestamp_space) = |{ lv_stamp TIMESTAMP = SPACE }|.DATA(lv_timestamp_iso) = |{ lv_stamp   TIMESTAMP = ISO }|.DATA(lv_timestamp_raw) = |{ lv_stamp  }|."当无格式时，在{}中填写TIMESTAMP = RAW则会报错，所有不需要写任何格式DATA(lv_timestamp_USER) = |{ lv_stamp  TIMESTAMP = USER }|.DATA(lv_timestamp_EVI) = |{ lv_stamp   TIMESTAMP = ENVIRONMENT }|.
测试结果：
TIMEZONE 
将时间戳转换成指定时区的时间戳，参考表 TTZZ 【 TIMEZONE = tz 】
例：
DATA(lv_timezone) = |{ lv_stamp TIMEZONE = 'CET' }|.DATA(lv_timezone1) = |{ lv_stamp TIMEZONE = 'JAPAN' }|.
测试结果：
以下格式选项可以用于所有类型
WIDTH
预定义字符串长度，当实际长度超出 len 时，按实际长度取值，否则按长度 len 在右侧填充空格 【 WIDTH = len 】
ALIGN
定义字符串对齐方式，适用于使用了 WIDTH 选项且预定义长度超出实际长度的情况【 ALIGN = [ LEFT | CENTER | RIGHT ] 】
PAD
使用指定字符串中的第一位字符填充剩余的位置，适用于使用了 WIDTH 选项且预定义长度超出实际长度的情况，默认会使用空格填充 【 PAD = c 】
CASE ★
将字符串进行大小写转换，默认为 RAW，该选项不会更改大小写格式,[CASE = [ RAW | LOWER | UPPER ] ]
例：
DATA(lv_width) = |"{ 'A' WIDTH = 2 }BCD"|. “输出结果中A后跟着一个空格，再加上BCDDATA(lv_align) = |"{ 'A' WIDTH = 2 ALIGN = RIGHT }BCD"|. “输出结果中，第一个字符为空格，A在长度为2的字符中靠右，第二个字符为ADATA(lv_pad) = |"{ 'A' WIDTH = 2 ALIGN = RIGHT PAD = '@' }BCD"|.”A靠右，空格用@填充DATA(lv_case) = |"{ 'A' CASE = LOWER }BCD"|. ” ”将A转换为小写a
测试结果：
SIGN 
用来调整数值类型符号的显示
LEFT/RIGHT：不显示正号，将符号放置在数值左侧/右侧
LEFTPLUS/RIGHTPLUS：显示正号，并将符号放置在数值左侧/右侧
LEFTSPACE/RIGHTSPACE：用空格代替正号显示，并将符号放置在数值左侧/右侧
例：
DATA(lv_sign_default) = |"{ -1 }"|.    “输出默认值DATA(lv_sign_left) = |"{ 1 SIGN = LEFT }"|.  “不显示正号，数值放置在左侧DATA(lv_sign_leftplus) = |"{ 1 SIGN = LEFTPLUS }"|.  “显示正号，数值放置在左侧DATA(lv_sign_leftspace) = |"{ 1 SIGN = LEFTSPACE }"|.   “用空格代替正号，将符号放置在左侧DATA(lv_sign_right) = |"{ -1 SIGN = RIGHT }"|.    “符号放置在右侧DATA(lv_sign_rightplus) = |"{ -1 SIGN = RIGHTPLUS }"|. “符号放置在右侧DATA(lv_sign_rightspace) = |"{ -1 SIGN = RIGHTSPACE }"|. “符号放置在右侧
测试结果：
EXPONENT
用于浮点型，设置指数【 EXPONENT = exp 】
DECIMALS
用于数值类型，设置小数位数【 DECIMALS = dec 】
ZERO ★
用于数值类型，设置显示/隐藏零【 ZERO = [ YES | NO ]  】
XSD
当数据参照以下 domain 时，会根据规则转换成相应的 XML 数据【 XSD = [ YES | NO ] 】
例：
DATA(lv_exponent) = |{ CONV f( 1 / 3 ) EXPONENT = -1 }|.DATA(lv_decimal) = |{ CONV f( 1 / 3 ) DECIMALS = 2 }|.DATA(lv_zero) = |{ 0 ZERO = NO }|.DATA(lv_xsd) = |{ CONV xsdboolean( abap_true ) }, { CONV xsdboolean( abap_true ) XSD = YES }|. 
测试结果：
STYLE 
该选项用于设置浮点型格式
SIMPLE：默认选项，使用使用预定义格式
SIGN_AS_POSTFIX：在数值右侧添加负号/空格，并截断小数位尾部的 0
SCALE_PRESERVING：范围保护，小数位尾部的 0 不会被截断
SCIENTIFIC：科学计数法，结果至少有 2 位带符号的指数，如果不指定 EXPONENT 选项，则结果的整数位始终只有一位
SCIENTIFIC_WITH_LEADING_ZERO：整数位只能是 0 ，小数第一位不为 0
SCALE_PRESERVING_SCIENTIFIC：范围保护，类型为 decfloat16 时，指数位数为 3，类型为 decfloat34 时，指数位数为 4
ENGINEERING：整数位范围为 1 - 999 ，指数必须是 3 的整数倍
例：
DATA(lv_f) = CONV f( -1 / 30 ). 
DATA(lv_s1) = |{ lv_f STYLE = SIMPLE }|.DATA(lv_s2) = |{ lv_f STYLE = SIGN_AS_POSTFIX }|.DATA(lv_s3) = |{ lv_f STYLE = SCALE_PRESERVING }|.DATA(lv_s4) = |{ lv_f STYLE = SCIENTIFIC }|.DATA(lv_s5) = |{ lv_f STYLE = SCIENTIFIC_WITH_LEADING_ZERO }|.DATA(lv_s6) = |{ lv_f STYLE = SCALE_PRESERVING_SCIENTIFIC }|.DATA(lv_s7) = |{ lv_f STYLE = ENGINEERING }|. 
测试结果：
 String Functions 字符串函数
使用表达式处理字符串数据
STRLEN ★
获取字符串长度，当字符串类型为 CHAR 时，尾部空格会被忽略，当字符串类型为 STRING 时，尾部空格不会被忽略，仍会按字符被计入长度内
例：
DATA(lv_strlen_c) = strlen( CONV char10( |1234567   | ) ).DATA(lv_strlen_s) = strlen( CONV string( |ACDEFGH   | ) ).
测试结果：
DISTANCE
计算将 text1 改动成 text2 的最少操作次数，每次操作仅允许删除/添加/更改 1 个字符
MAX 参数用来限制最大操作次数，当最少次数大于 max 时，返回 max
例：
DATA(lv_distance) = distance( val1 = '123ABC'  val2 = '124AC' ).DATA(lv_dis_max) = distance( val1 = '123ABC'  val2 = '124ACDE' max = 3 ). ” “这里最小操作次数为4，但规定了max = 3,所以输出值为3
测试结果：
FIND ★
搜索指定字符串并计算偏移量，没有遍历到时返回 1-
可以使用 SUB ( 固定文本 ) 或者 REGEX ( 正则表达式 ) 作为指定条件进行搜索
CASE = [ abap_true | abap_false ]：大小写检查，默认需要检查大小写。case = abap_true需要检查大小写，case = abap_false不需要检查大小写，case = ‘ ’为case = abap_false。
DATA(lv_find_sub)  =  find( val = 'ABA123CAD' sub = 'a' case = ' ')."不区分大小写，查找到第一个值，输出为0
测试结果：
OCC = N：指定字符串在第 N 次出现，当 N 是负数时，从字符串右边开始遍历
DATA(lv_find_sub1) =  find( val = 'ABA123CAD' sub = 'a' case = ' ' occ = 3 ).
"不区分大小写，搜索A第三次出现的位置,输出为7DATA(lv_find_sub2) =  find( val = 'ABA123CAD' sub = 'a' case = abap_true occ = 3 ).
"区分大小写，搜索A第三次出现的位置。没有结果，输出为1-DATA(lv_find_sub3) =  find( val = 'ABA123CAD' sub = 'a' case = abap_false occ = 1 ).
"不区分大小写，搜索A第一次出现的位置，输出为0DATA(lv_find_sub4) =  find( val = 'ABA123CAD' sub = 'A'  occ = -3 ).
"若occ为负数，则从右边开始遍历，比如occ=-3，则从右边数第三个A，为左边数第一个A，偏移量为0 ，输出为0DATA(lv_find_sub5) =  find( val = 'ABA123CAD' sub = '8' ).
"遍历不到，输出为1-DATA(lv_find_sub6) =  find( val = 'ABA123CAD' sub = 'a'  occ = 3 ).
" 这里没有写case,默认case区分大小写，输出为1-
测试结果：
OFF = N  LEN = M：指定搜索区域，从第 N+1 为字符开始长度为 M 的范围
DATA(lv_find_reg)  = find( val = 'ABA123CAD' regex = '\d' off = 0 len = 3 ).
"从第一个字符开始，搜索3个字符，查找数值。未查找到，输出为1-,"\d"在正则表达式中是数字DATA(lv_find_reg1)  = find( val = 'ABA123CAD' regex = '\d' off = 0 len = 6 ).
"从第一个字符开始，搜索六个字符，查找数字。第一个搜索出来的是1，偏移量为3，输出为3DATA(lv_find_reg2) = find( val = 'ABA123CAD' regex = 'A' off = 0 len = 3 ).
"从第一个字符开始，搜索3个字符，查找A。偏移量为0，输出为0DATA(lv_find_reg3) = find( val = 'ABA123CAD' regex = 'a' off = 0 len = 3 ).
"从第一个字符开始，搜索3个字符，查找a。未查找到a，输出为1-DATA(lv_find_reg4) = find( val = 'ABA123CAD' regex = '123' off = 0 len = 6 ).
"从第一个字符开始，搜索6个字符，查找123。偏移量为3，输出为3
测试结果：
参考：
  正则表达式教程： https://www.runoob.com/regexp/regexp-syntax.html
  在线测试工具： http://tool.oschina.net/regex/?optionGlobl=global
FIND_END
与 FIND 用法一致，但是偏移量会计算本身的长度
例：
DATA(lv_find_end_sub) = find_end( val = 'ABA123CAD' sub = 'A' occ = 3 ).DATA(lv_find_end_reg) = find_end( val = 'ABA123CAD' regex = '\d+' ). "\d+"表示一个或多个数字组成
测试结果：
以下两种表达式只能使用 SUB 指定文本，且始终区分大小写
FIND_ANY_OF
搜索指定字符串中的任一字符并返回最小偏移量
FIND_ANY_NOT_OF
搜索非指定字符串中的任意字符并返回最小偏移量
例：
DATA(lv_find_any) = find_any_of( val = 'ABA123CAD' sub = '1B' ).DATA(lv_find_any_not) = find_any_not_of( val = 'ABA123CAD' sub = '1B' ). 
测试结果：
COUNT ★
用法与 FIND 类似，但是返回值是指定字符串出现的次数，因此不能指定 OCC 参数
COUNT_ANY_OF
计算指定字符串中的任一字符出现的总次数
COUNT_ANY_NOT_OF
计算非指定字符串中任意字符出现的总次数
例：
DATA(lv_count) = count( val = 'ABA123CAD' sub = 'a' case = ' ' ).DATA(lv_count_any) = count_any_of( val = 'ABA123CAD' sub = '1B' ).DATA(lv_count_not) = count_any_not_of( val = 'ABA123CAD' sub = '1B' ).
测试结果：
CONTAINS
用法与 FIND 类似，用于判断包含关系，返回值为布尔型数据
当指定 START/END 时，直接从左侧/右侧比较对应长度的字符，用来判断首尾字符是否是sub中的字符，使用正则表达式时不可指定
CONTAINS_ANY_OF
判断是否包含指定字符串中的任一字符
CONTAINS_ANY_NOT_OF
判断是否包含非指定字符串中的任意字符，只有当sub里拥有全部val中的字符时，才会报false
可参照部分与操作符等效的表达式用法，如下图：
例：
DATA(lv_contains) = xsdbool( contains( val = 'ABA123CAD' sub = 'a' case = ' ' ) ).
DATA(lv_contains_start) = xsdbool( contains( val = 'ABA123CAD' start = 'AB' ) ).DATA(lv_contains_end) = xsdbool( contains( val = 'ABA123CAD' end = 'BD' ) ). DATA(lv_contains_any) = xsdbool( contains_any_of( val = 'ABA123CAD' sub = 'E' ) ).DATA(lv_contains_not) = xsdbool( contains_any_not_of( val = 'ABA123CAD' sub = '1B' ) ). 
DATA(lv_contains_not1) = xsdbool( contains_any_not_of( val = 'ABA123CAD' sub = 'ABA123' ) )."true
DATA(lv_contains_not2) = xsdbool( contains_any_not_of( val = 'ABA123CAD' sub = 'ABA123CAD' ) )."false
测试结果：
 
XSDBOOL ★
将布尔型数据 true 转换为 abap_true，false 转换为 abap_false，返回值类型为 char1
REPLACE ★
替换字符串，可以指定位置进行替换，也可以查找指定字符串并替换
WITH = new 指定用于替换的字符串
OCC = N 指定字符串第 N 次出现时进行替换，N 为 0 时表示需要全部替换
其他参数可参照 FIND 表达式
例：
DATA(lv_replace) = replace( val = 'ABA123CAD' off = 0 len = 4 with = '@12@' ).DATA(lv_replace_sub) = replace( val = 'ABA123CAD' sub = 'a' with = '@' case = ' ' ).DATA(lv_replace_reg) = replace( val = 'ABA123CAD' regex = '\d' with = '#' occ = 0 ). 
测试结果：
INSERT ★
插入字符串，可以使用 OFF 指定插入的位置，默认为 0
例：
DATA(lv_insert) = insert( val = 'ABCD' sub = '123' off = 2 ). 
测试结果：
SPLIT
拆分字符串字符串，可以将字符串拆分开来
例：
  DATA: STRING(60),      P1(20) VALUE '',      P2(20) VALUE '',      DEL(3) VALUE '***'.STRING = ' Part 1 *** Part 2'.SPLIT STRING AT DEL INTO P1 P2.WRITE: /'P1:' , P1.WRITE: /'P2:' , P2.
测试结果：
CONCATENATE
 连接字符串，可以将字符串连接起来，如例1
SEPARATED BY 可以在字符间增加连接符，如例2
例1：
DATA: C1(10)  VALUE  'Summer',      C2(10)   VALUE  'holiday ',      C3(30).CONCATENATE C1 C2  INTO C3.
测试结果：
例2：
DATA: C1(10)  VALUE  'Summer',      C2(10)   VALUE  'holiday ',      C3(30),      SEP(3)  VALUE ' - '.CONCATENATE C1 C2  INTO C3 SEPARATED BY SEP.
测试结果：
CMAX/CMIN
返回数个字符串中的最大值/最小值，最多可以有 9 个参数，比较规则：按 0 - 9 ，A - Z，a - z 的顺序从小到大
例：
DATA(lv_cmax) = cmax( val1 = 'aABC' val2 = 'ZABC' val3 = '0123' ).DATA(lv_cmin) = cmin( val1 = 'aABC' val2 = 'ZABC' val3 = '0123' ). 
测试结果：
CONDENSE ★
压缩字符串，默认会移除头部/尾部的空格，其他部分的空格都会被压缩至 1 位
DEL = del 指定需要删除的字符，指定后，从字符串两侧开始遍历并删除字符，直到出现非指定字符
FROM = from  TO = to  处理完 DEL 后，再遍历字符串，将 from 中出现的字符，替换成 to 的第一位字符
在遍历过程中，当同一个字符连续出现时，会被当成一个整体进行替换，所有字符均区分大小写
例：
DATA(lv_condense_space) = condense( |  This  is   test | ).DATA(lv_condense) = condense( val  = '  XXThis ISSS X sTringXX'                              del  = |X |                              from = 'TS'                               to   = 'to' ). 
测试结果：
存在问题，第二个不是这样
CONCAT_LINES_OF ★
将内表中所有的记录连接起来，通过 sep 指定分隔符
例：
DATA: lt_data TYPE TABLE OF char10.lt_data = VALUE #( ( 'ABC' ) ( '123' ) ( 'DEF' ) ).DATA(lv_concat_lines) = concat_lines_of( table = lt_data sep = '@' ). 
测试结果：
ESCAPE
基于规则转义特定字符，FORMAT 用于指定转换规则
例：
DATA(lv_escape_url) = escape( val    = 'http://www.google.com'                              format = cl_abap_format=>e_url_full ).DATA(lv_escape_string) = escape( val    = 'Special characters: |, \, {, }'                                 format = cl_abap_format=>e_string_tpl ). 
测试结果：
MATCH ★
根据正则表达式匹配字符,如果在字符前后增加“.”，怎可以将字符前后的字符一起输出。
DATA(lv_match) = match( val = 'S1S2H3H4' regex = 'S.' occ = 2 ).   "S2,第二次出现的S，“.”是S后面的一个字符DATA(lv_match1) = match( val = 'S1S2H3H4' regex = 'H...' occ = 1 ).  "H3H4DATA(lv_match2) = match( val = 'S1S2H3H4' regex = 'H.' occ = 6 ).  "不出现值，因为没有第6个HDATA(lv_match3) = match( val = 'S1S2H3H4' regex = '1.' occ = 1 ).  "1SDATA(lv_match4) = match( val = 'S1S2H3H4' regex = 'S' occ = 1 ).  "S
测试结果：
REPEAT
循环字符串 N 次
例：
DATA(lv_repeat) = repeat( val = 'ABC' occ = 5 ). 
测试结果：
REVERSE ★
字符串反转
例：
DATA(lv_reverse) = reverse( 'DEMO' ). 
测试结果：
TRANSLATE
按照指定规则替换字符，from 和 to 中的字符一一对应，没有对应关系的字符会被删除
如下例，Y对应A，Z对应C，B没有对应则被删除
DATA(lv_translate) = translate( val  = 'ABCDAB'                                from = 'ACB'                                to   = 'YZ' ). 
测试结果：
下例中，1、2都没有对应，则val中的1和2都被删除
data(lv_translate2) = translate( val = '1234511223'                                 from = '12'                                 to = ''"输出3453
测试结果：
TO_MIXED
处理大小写格式，首个字符大小写与 CASE 参数中的第一个字符一致，从第二个字符开始转换成小写
sep 符号（默认为 _ ）后面的一个字符会被转换成大写，min 可以指定前 N 位中的 sep 符号不起作用
DATA(lv_to_mixed) = to_mixed( val = 'THIS is @A STRIN@G' sep = '@' case = 'X' min = 10 ).
"输出This is @a strinGDATA(lv_to_mixed1) = to_mixed( val = 'THIS is A STRIN@G'  case = 'x' min = 10 ).
"输出this is a strin@g ，这里因为没有sep的值，所以后面的min也没有任何作用DATA(lv_to_mixed2) = to_mixed( val = 'HEllo worLD' case = 'x').
"输出hello worldDATA(lv_to_mixed3) = to_mixed( val = 'HEllo w_orLD' sep = '_' case = 'x').
"输出hello wOrldDATA(lv_to_mixed4) = to_mixed( val = 'HE_llo w_orLD' sep = '_' case = 'x' min = 2 ).
"输出heLlo wOrldDATA(lv_to_mixed5) = to_mixed( val = 'HE_llo w_orLD' sep = '_' case = 'x' min = 3 ).
"输出he_llo wOrlddata(lv_to_mixed6) = to_mixed( val = '@HEllo worLD' sep = '@' case = 'x').
"输出@hello world,首字母当sep和case冲突的时候，以case为准data(lv_to_mixed7) = to_mixed( val = '@HEllo worLD'  case = 'x' sep = '@').
"输出@hello worlddata(lv_to_mixed8) = to_mixed( val = 'H@Ello worLD' sep = '@' case = 'x').
"输出hEllo world，要是sep生效，则生效的sep在输出中消失data(lv_to_mixed9) = to_mixed( val = 'HE@llo worLD' sep = '@' case = 'x').
"输出heLlo world
测试结果：
FORM_MIXED
处理大小写格式，大小写与 CASE 参数中的第一个字符一致（默认大写），在转换前字符是大写的，会在该字符之前添加 sep 符号
DATA(lv_from_mixed) = from_mixed( val = 'This IS a string' )."输出THIS _I_S A STRINGDATA(lv_from_mixed1) = from_mixed( val = 'This IS a string' case = 'x' )."输出this _i_s a stringdata(lv_from_mixed2) = from_mixed( val = 'hello worLD' )."输出HELLO WOR_L_D
测试结果：
TO_UPPER/TO_LOWER ★
将字符串转换成大写/小写
例：
DATA(lv_to_upper) = to_upper( val = 'this IS a string' ).DATA(lv_to_lower) = to_lower( val = 'THIS IS A STRING' ). 
测试结果：
SHIFT_LEFT/SHIFT_RIGHT
将字符串左移/右移 N 位
指定 CIRCULAR 参数时，每次移除的字符需要被添加到另一侧
指定 SUB 参数时，如果 SUB 与字符串左侧/右侧部分字符完全匹配，则移除这些字符
例：
DATA(lv_left_places) = shift_left( val = 'ABCD’ places = 2 ).DATA(lv_left_circular) = shift_left( val  = 'ABCD' circular = 3 ).DATA(lv_left_sub) = shift_left( val = 'ABCD' sub = 'A' ).
DATA(lv_right_places) = shift_right( val = 'ABCD' places = 2 ).DATA(lv_right_circular) = shift_right( val  = 'ABCD' circular = 3 ).DATA(lv_right_sub) = shift_right( val = 'ABCD' sub = 'D' ). 
测试结果：
以下表达式可以用来截取字符串
SUBSTRING ★
从第 off + 1 位开始取长度为 len 的字符串，如果截取范围超出原有字符长度，会抛出异常CX_SY_RANGE_OUT_OF_BOUNDS
SUBSTRING_FROM
从指定文本 sub 或是正则表达式 regex 匹配到的字符串（包含本身）开始截取，默认截至最后一位
 len 指定长度，occ 指定出现次数，case 指定大小写检查,case = abap_true 检查大小写，case = abap_false不检查大小写
DATA(lv_substring_from) = substring_from( val = 'ABCDEFGH' sub = 'DEF' )."DEFGHDATA(lv_substring_from1) = substring_from( val = 'ABCACBABC' sub = 'A'  len = 2 )."ABDATA(lv_substring_from2) = substring_from( val = 'ABCACBABC' sub = 'A' occ = 2 )."ACBABCDATA(lv_substring_from3) = substring_from( val = 'ABCaCABABC' sub = 'a' case = abap_true )."aCABABCDATA(lv_substring_from4) = substring_from( val = 'AbBCbabBC' sub = 'B' case = abap_false ).
"bBCbabBC,当case = abap_false时，不检查大小写DATA(lv_substring_from5) = substring_from( val = 'ABCbabBC' sub = 'b' case = abap_false )."BCbabBCDATA(lv_substring_from6) = substring_from( val = 'ABCaCaABABC' sub = 'a' len = 2 occ = 2 case = abap_true )."aADATA(lv_substring_from7) = substring_from( val = 'ABCaCaABABC' sub = 'A' len = 3 occ = 3 case = abap_true )."ABC
测试结果：
SUBSTRING_AFTER
从指定文本后一位开始截取，不包含本身
DATA(lv_substring_after) = substring_after( val = 'ABCDEFGH' sub = 'DEF' )."GHDATA(lv_substring_after1) = substring_after( val = 'ABCDEFGH' sub = 'eF' case = abap_false  )."GHDATA(lv_substring_after2) = substring_after( val = 'ABCDEFGH' sub = 'g' )."g不在字符中，所以没有数据
测试结果：
SUBSTRING_BEFORE
从第一位字符开始，截取到指定文本前一位，不包含本身
DATA(lv_substring_before) = substring_before( val = 'ABCDEFGH' sub = 'DEF' )."ABCdata(lv_substring_before1) = substring_before( val = '1234' sub = '34' )."12
测试结果：
SUBSTRING_TO
从第一位字符开始，截取到指定文本结束，包含本身
DATA(lv_substring_to) = substring_to( val = 'ABCDEFGH' sub = 'DEF' )."ABCDEFdata(lv_substring_to1) = substring_to( val = '12345' sub = '34' )."1234
测试结果：
SEGMENT ★
根据分隔符获取指定位置的字符串，可以用来拆分字符串，INDEX 用来指定位置，指定位置不存在时，会抛出异常 CX_SY_STRG_PAR_VAL
通过 SEP 指定的分隔符会被当做一个整体进行操作，当分隔符连续出现时，该位置会返回空字符串；
而通过 SPACE 指定的分隔符中，每个字符都会被视作单独的分隔符，且在分隔符连续出现时也不会单独返回空串
例：
DO.  TRY.      lv_sep = segment( val   = 'AB;CD ;EF ; ;GH'                        index = sy-index                        sep = ' ;' ).    CATCH cx_sy_strg_par_val.      EXIT.  ENDTRY.ENDDO. 
DO.  TRY.      lv_space = segment( val   = 'AB  CD - EF_GH'                          index = sy-index                          space = ' -_' ).    CATCH cx_sy_strg_par_val.      EXIT.  ENDTRY.ENDDO.
测试结果：
 
 Numeric Functions 数值函数
常见的数值表达式，整理如下：
ABS：取绝对值
SIGN( N )：N>0时返回 1；N<0时返回 -1；N=0时返回 0
CEIL：向上取整
FLOOR：向下取整
TRUNC：取整数位
FRAC：取小数位
IPOW：计算幂值，可以用来代替 ** 使用，避免部分数据丢失精度
NMAX/NMIN：返回参数中的最大值/最小值，参数最多传入 9 个
ROUND：计算舍入值，DEC 指定舍入位置，可以使用 MODE 指定舍入规则
RESCALE：与 ROUND 用法一致，但是当需要保留的位数大于实际位数时，RESCALE 会在尾部填充 0，而 ROUND 不会
例：
DATA(lv_sign) = sign( lv_num ).DATA(lv_ceil) = ceil( lv_num ).DATA(lv_floor) = floor( lv_num ).DATA(lv_trunc) = trunc( lv_num ).DATA(lv_frac) = frac( lv_num ).
DATA(lv_ipow) = |{ ipow( base = '1.2’ exp = 2 ) } , { ( '1.2' ** 2 ) }|.DATA(lv_nmax) = nmax( val1 = lv_ceil val2 = lv_floor ).DATA(lv_nmin) = nmin( val1 = lv_ceil val2 = lv_floor ).DATA(lv_round) = round( val = lv_num dec = 3 ).DATA(lv_rescale) = rescale( val = lv_num dec = 8 ). 
测试结果：
 Internal Table Expressions  内表表达
新语法中内表的读取方式
内表读取不再需要使用 READ TABLE，直接使用类似于数组的方式去读取
与READ TABLE读表方式类似，可以通过 INDEX 去读取指定位置的行，也可以根据条件去获取行，但无法指定BINARY SEARCH
默认情况下如果没有读到记录，会抛出异常 CX_SY_ITAB_LINE_NOT_FOUND
SELECT  carrid, connid, countryfr, cityfrom  FROM spfli INTO TABLE @DATA(lt_table) UP TO 3 ROWS."carrid  connid  countryfr  cityfrom"AA      0017       US      NEW YORK"AA      0064       US      SAN FRANCISCO"AZ      0555       IT       ROMEDATA(lv_line_index) = lt_table[ 1 ]-carrid.       "AADATA(lv_line_index1) = lt_table[ 3 ]-countryfr.   "ITDATA(lwa_line_field) = lt_table[ carrid = 'AZ'                                 connid = '0555' ].    "AZ 0555 IT ROMEDATA(lwa_line_field1) = lt_table[ carrid = 'AA'         "需要全部的关键词，确认唯一性                                  connid = '0017' ].     "AA 0017 US NEW YORK
测试结果：
OPTIONAL ★
使用 OPTIONAL 语句时，没有读到记录也不会抛异常，而是返回空的结构
DATA(lwa_line_optional) = VALUE #( lt_table[ 4 ] OPTIONAL ). "没有数值，返回的值都是零：   0000DATA(lwa_line_optional1) = VALUE #( lt_table[ 3 ] OPTIONAL ). "输出：AZ 0555 IT ROME
测试结果：
DEFAULT ★
使用 DEFAULT 语句，在没有读到记录时，返回一个默认值，如果系统不支持这两种，则需要使用 TRY 语句来捕获异常DATA(lwa_line_default) = VALUE #( lt_table[ 4 ] DEFAULT VALUE #( carrid = 'ZZ'                                                                 connid = '0239'                                                                 countryfr = 'SU'                                                                 cityfrom = 'CITY_NO' ) ).  
"ZZ 0239 SU CITY_NODATA(lwa_line_default1) = VALUE #( lt_table[ 4 ] DEFAULT VALUE #( carrid = 'AA'                                                                 connid = '0245'                                                                 countryfr = 'IT'                                                                 cityfrom = 'CITY_NO' ) ).  
"AA 0245 IT CITY_NOdata(lwa_line_default2) = value #( lt_table[ 4 ]  )."报错 
data(lwa_line_default3) = value #( lt_table[ 3 ]  )."AZ 0555 IT ROMEDATA(lwa_line_default4) = VALUE #( lt_table[ 2 ] DEFAULT VALUE #
                                                                 ( carrid = 'AA' 
                                                                   connid = '0064' 
                                                                countryfr = 'US' 
                                                                 cityfrom = 'SAN FRANCISCO' ) ).
"AA 0064 US SAN FRANCISCO"第二个value有更改，default的值也不会改变DATA(lwa_line_default5) = VALUE #( lt_table[ 2 ] DEFAULT VALUE #
                                                                  ( carrid = 'AB' 
                                                                    connid = '0033' 
                                                                 countryfr = 'US' 
                                                                  cityfrom = 'SAN FRANCISCO' ) ).
"AA 0064 US SAN FRANCISCO
测试结果：
 Internal Table Functions 内表函数
适用于内表的表达式
LINES ★
计算内表总行数
LINE_EXISTS ★
判断根据特定条件能否在内表中读取到记录，返回值为布尔型数据
LINE_INDEX ★
获取内表中满足特定条件的记录所在的行数( INDEX ),如果存在多个条件值，则只会返回第一个搜索到的值的行数
例：
SELECT * FROM spfli INTO TABLE @DATA(lt_table) UP TO 3 ROWS.DATA(lv_lines) = lines( lt_table ).DATA(lv_exist) = xsdbool( line_exists( lt_table[ carrid = 'AZ' ] ) ).DATA(lv_index) = line_index( lt_table[ carrid = 'AZ' ] ). 
测试结果：
Constructors 构建函数
Inline declaration
内部声明，将变量/指针的声明和赋值结合起来，可以在任何位置书写且类型来自于值，如例1
在ABAP SQL中，可以在select语句里直接定义内表，减少书写工作量，如例2
例1：
data(int) = 1 + 2.data(str) = 'string'.ASSIGN str  to field-symbol(<fs>).
测试结果：
例2：
select  SUBSTRING( MATNR, 16,18 ) as matnr  
 "substring 为截取字符串，matnr为字段，（16，18）16为字段截取的开始，18为字段截取的结束  FROM mara  WHERE ERNAM = 'DEMO'  into TABLE @data(lt_matnr).
测试结果：
Type constructors
类型构造函数，构建特定类型或推断类型(#)的值，运算符是{new,value…}之一，运算符决定了内容范围
NEW: 创建对象/数据对象，详见第一章
VALUE: 创建值（特别是结构化类型），详见第一章
CONV: 转换值，详见第一章
CAST: 执行向上或向下的引用强制转换，详见第二章
REF: 创建数据引用，详见第一章
EXACT: 执行无损计算或赋值，详见第一章
COND / SWITCH: 计算值条件，详见第一章
Local variable binding
构建函数操作符允许过渡值的绑定
data(sqsize) = conv i( let s = 1 in s * s ).
测试结果：
Table selection
表选择中可以读取内表，书写内表
TYPES:BEGIN OF lty_tab,        text1(5) TYPE c,        text2(5) TYPE c,      END OF lty_tab.DATA:lt_tab TYPE SORTED TABLE OF lty_tab WITH UNIQUE KEY PRIMARY_KEY COMPONENTS text1  .DATA:lt_tabl TYPE TABLE OF lty_tab WITH NON-UNIQUE SORTED KEY text1 COMPONENTS text1  .lt_tab = VALUE #( ( text1 = '1' text2 = 'A' )                  ( text1 = '2' text2 = 'B' )                  ( text1 = '3' text2 = 'C' ) ).READ TABLE lt_tab INDEX 1 INTO DATA(ls_tab1).READ TABLE lt_tab WITH KEY text1 = '2'  INTO DATA(ls_tab2).READ TABLE lt_tab INDEX 3 USING KEY primary_key INTO DATA(ls_tab3).
 "用这个语句需要有关键值，给表增加关键值可看上述代码lt_tab和lt_tabl
测试结果：
Table Comprehensions
表驱动：在结果表中为源表中每个选定的行创建一行，从行中的静态数到动态数
TYPES:BEGIN OF lty_tabl1,        text1(5) TYPE c,        text2(5) TYPE c,        text3(5) TYPE c,      END OF lty_tabl1.DATA:lt_tabl1 TYPE table of lty_tabl1.DATA:lt_tabl2 TYPE table of lty_tabl1.DATA:lt_tabl3 TYPE table of lty_tabl1.lt_tabl1 = VALUE #( ( text1 = '1' text2 = 'A'  text3 = '234' )                  (   text1 = '2' text2 = 'B'  text3 = '123' )                  (   text1 = '3' text2 = 'C'  text3 = '456' ) ).lt_tabl2 = VALUE #( ( text1 = '1' text2 = 'A'  text3 = '455' )                  (   text1 = '2' text2 = 'B'  text3 = '234' )                  (   text1 = '3' text2 = 'C'  text3 = '123' ) ).lt_tabl3 = VALUE #(                    for ls_tabl1 in lt_tabl1 WHERE ( text1 = '1' )                       for ls_tabl2 in lt_tabl2                         ( text1 = ls_tabl1-text1  text2 = 'C' text3 = ls_tabl2-text3 )                ).
测试结果：
条件驱动：在目标表中创建行，直到条件为false
Table bulit-in functions 
函数内建表
Lines:计算内表行数SELECT carrid       FROM scarr       INTO TABLE @DATA(lt_tab_line).*OLD:DESCRIBE TABLE lt_tab_line LINES DATA(LV_TABIX_old).*NEW:DATA(LV_TABIX_new) = lines( lt_tab_line ).
测试结果：
Line_exists 判断条件是否存在SELECT *       FROM spfli       INTO TABLE @data(flight_tab).IF line_exists( flight_tab[ carrid = 'XM'                            connid = '6688' ] ).  WRITE:/ '条件存在'.  ELSE.  WRITE:/ '条件不存在'.ENDIF.
测试结果：
Line_index:计算条件所在的行数
*OLD:READ TABLE flight_tab TRANSPORTING NO FIELDS WITH KEY carrid = 'XX'                                                       connid = '88'.IF sy-subrc = 0.  WRITE: /  'sy-tabix行数为：',sy-tabix. "index  else.   WRITE:/ '程序无法运行。'.ENDIF.*NEW:DATA(indx) = line_index( flight_tab[ carrid = 'XX'                                      connid = '88'] ).WRITE: / 'indx行数为：' ,indx.
测试结果：
4 Special Usages
 TRY… CATCH…
ZDEMO_04_001
在异常处理过程中使用的一些语句
CATCH … INTO …
在INTO 语句中可以直接声明对象，用于查看具体的异常信息，可用的参数/方法可以在对应的异常类中查看
CATCH 语句可以用于捕获多个异常类型，可以直接在 CATCH 后添加多个异常类，也可以添加多个 CATCH 语句
例：
SELECT * FROM spfli INTO TABLE @DATA(lt_data) UP TO 2 ROWS.TRY .    DATA(lwa_data) = lt_data[ 3 ].  CATCH cx_sy_itab_line_not_found INTO DATA(lo_error).    DATA(lv_text) = lo_error->get_text( ).ENDTRY. 
测试结果：
RETRY
捕获到异常时，在CATCH 语句中对异常进行处理后，使用 RETRY 再次执行 TRY 语句
使用 RETRY 处理异常时，尽量多的添加限制条件，避免导致死循环
例：
DATA(lv_num) = 1.TRY .    DATA(lv_error) = lv_num / 0.  CATCH cx_sy_zerodivide.    IF lv_num IS NOT INITIAL.      CLEAR lv_num.      RETRY.    ENDIF.ENDTRY. 
测试结果：
RAISE EXCEPTION
在 TRY 语句中，使用 RAISE EXCEPTION 手动抛出异常【使用 RAISE RESUMABLE EXCEPTION 抛出可恢复异常】
例：
DATA(lv_num) = 101. 
TRY.    IF abs( lv_num ) > 100.      RAISE EXCEPTION TYPE cx_demo_abs_too_large.    ENDIF. 
  CATCH cx_demo_abs_too_large INTO DATA(lo_large).    DATA(lv_text) = 'CATCH cx_demo_abs_too_large : ' && lo_large->get_text( ). ENDTRY. 
测试结果：
CLEANUP
CLEANUP 语句仅在当前 TRY 语句有异常抛出且无法被当前 CATCH 语句捕获时执行，执行后再将异常传递至上层处理语句
例：
TRY.    TRY.        DATA(lv_div) = 1 / lv_num.        DATA(lv_sqrt) = sqrt( lv_num ).      CATCH cx_sy_zerodivide INTO DATA(lo_zero).        DATA(lv_zero) = 'CATCH cx_sy_zerodivide : ' && lo_zero->get_text( ).      CLEANUP.        DATA(lv_cleanup) = 'CLEANUP'.    ENDTRY.  CATCH cx_sy_arithmetic_error INTO DATA(lo_negative).    DATA(lv_negative) = 'CATCH cx_sy_arithmetic_error : ' && lo_negative->get_text( ).ENDTRY. 
测试结果：
CATCH BEFORE UNWIND
CATCH BEFORE UNWIND 用法与 CATCH 一致，但在使用时，该异常抛出部分的 CLEANUP 代码块将被推迟执行，在 CATCH BEFORE UNWIND 语句执行结束后，才会回到 CLEANUP 语句中继续执行
例：
DATA(lv_num) = 0.TRY.    TRY.        DATA(lv_div) = 1 / lv_num.      CLEANUP.        lv_num = lv_num + 100.    ENDTRY.
  CATCH BEFORE UNWIND cx_sy_zerodivide INTO DATA(lo_zero).    CLEAR lv_num.    DATA(lv_zero) = 'CATCH cx_sy_zerodivide : ' && lo_zero->get_text( ).ENDTRY. 
测试结果：
RESUME
使用 RESUME 处理可恢复异常，使该异常所在的 TRY 语句继续执行
该语句只能在 CATCH BEFORE UNWIND 下使用， 不可恢复的异常使用 RESUME 时会抛运行时错误
检查异常是否可以被恢复：IS_RESUMABLE，该成员变量的类型为 ABAP_BOOL
例：
TRY.    cl_demo_output=>write_data( 1 ).    RAISE RESUMABLE EXCEPTION TYPE cx_sy_conversion_rounding.    cl_demo_output=>write_data( 2 ).
  CATCH BEFORE UNWIND cx_sy_conversion_rounding INTO DATA(lo_convert).     cl_demo_output=>write_data( 3 ).    IF lo_convert->is_resumable = abap_true.      RESUME.      cl_demo_output=>write_data( 4 ).    ENDIF. ENDTRY.cl_demo_output=>display( ). 
测试结果：
 Call Method
ZDEMO_04_002
新语法中，可以不使用 CALL METHOD 关键字，直接用内嵌式的方法传参并获取返回值
调用方法时，可以在内部嵌套调用其他的方法，但是该方法的返回值类型与参数需要保持一致
例：
DATA(go_grid) = NEW cl_gui_alv_grid( i_parent = go_splitter->get_container( row = 1 
                                                                            column = 1 ) ).
 Demo Output
ZDEMO_04_003
使用 CL_DEMO_OUTPUT 内置的方法来展示数据，常用于测试
可以通过 WRITE 方法将需要显示的对象加载到 OUTPUT 界面上，再通过 DISPLAY 方法展示该界面
不同类型的对象可以选择使用对应的 WRITE 方法，如下：
WRITE / WRITE_DATA / WRITE_TEXT / WRITE_HTML / WRITE_XML / WRITE_JSON
在 DISPLAY 的方法中也可以传入相应的对象，实际是将 WRITE_XXX 以及 DISPLAY 方法进行了封装，如下：
DISPLAY / DISPLAY_DATA / DISPLAY_TEXT / DISPLAY_HTML / DISPLAY_XML / DISPLAY_JSON
在展示数据时，可以选择添加一些辅助性的内容：
使用 BEGIN_SECTION / NEXT_SECTION / END_SECTION 添加标题，划分章节
使用 LINE 添加分割线
例：
SELECT * FROM makt INTO TABLE @DATA(lt_table) UP TO 2 ROWS.DATA(lwa_data) = lt_table[ 1 ].DATA(lv_maktx) = lt_table[ 1 ]-maktx.cl_demo_output=>begin_section( '---Display Table---' ).cl_demo_output=>write_data( lt_table ).cl_demo_output=>line( ).cl_demo_output=>next_section( '---Display Work Area---' ).cl_demo_output=>write_data( lwa_data ).cl_demo_output=>line( ).cl_demo_output=>next_section( '---Display Field---' ).cl_demo_output=>write_data( lv_maktx ).cl_demo_output=>end_section( ).cl_demo_output=>display( ). 
测试结果：
 Demo Input
ZDEMO_04_004
使用 CL_DEMO_INPUT 内置的方法来展示数据，常用于测试
与OUTPUT类似，INPUT使用ADD_FIELD加载字段到界面，并使用REQUEST调出该界面
ADD_FIELD：默认将字段名作为文本显示，text可以指定字段文本，as_checkbox用来设置字段以复选框格式显示
REQUEST：可以直接加载字段并显示，参数与ADD_FIELD一致，如下右图
ADD_TEXT：添加文本内容
ADD_LINE：添加空行
例：
DATA: lv_int   TYPE i VALUE 1,      lv_char1 TYPE char1 VALUE 'X'.cl_demo_input=>add_text( 'Please input the fields below:' ).cl_demo_input=>add_field( EXPORTING text = 'Checkbox'                                    as_checkbox = 'X'                           CHANGING field = lv_char1 ).cl_demo_input=>add_line( ).cl_demo_input=>add_field( CHANGING field = lv_int ).cl_demo_input=>request( ).cl_demo_input=>add_text( 'Please input the fields below:' ).cl_demo_input=>request( CHANGING field = lv_int ).
测试结果：
 Fixed point arithmetic
ZDEMO_04_005
在创建程序时，需要勾选 Fixed point arithmetic，否则会影响部分新语法的使用
正常情况下，该选项默认为选中状态，作用是设置该程序中所有的计算都使用定点计算
在不勾选该选项时，部分新语法，例如下图中 OPEN SQL 的一些使用方式将不会被支持（尤其是在部分增强出口里）
创建程序的时候，默认勾选Fixed point arithmetic，后期可以在se38,选择属性选项启动，修改program的属性。
如图：
使用非定点运算时，无论定义了多少位小数，在赋值、比较和计算中使用压缩型数据 (ABAP/4类型P、字典类型CURR、DEC或QUAN)时，它们都将被视为整数，算术计算的中间结果也将四舍五入到整数，只有在输出该数据时，才会考虑该小数位个数
例：
DATA:lv_result_d0  TYPE p DECIMALS 0,     lv_div        TYPE p DECIMALS 1 VALUE '6.8',     lv_result_d1  TYPE p DECIMALS 1,     lv_result_div TYPE p DECIMALS 1.lv_result_d0 = 100 / 2.lv_result_d1 = 100 / 2.lv_result_div = 100 / lv_div. 
测试结果：
左图是没有勾选 Fixed point arithmetic 选项时的执行结果，而右图为勾选状态下的结果
上例中，LV_RESULT_D0 没有小数位，所以结果为50；
LV_RESULT_D1有一位小数，因此结果变为 5.0；
LV_DIV 会被视为整数 68 并用于计算，100 / 68 结果为 1.47，四舍五入后得到 1，LV_RESULT_DIV有一位小数，则结果为 0.1
5.补充部分内容
（没有demo，在前文中都有使用）
特殊的内表，hashed table and sorted table
1)TYPE STANDARD TABLE OF和TYPE HASHED TABLE区别
1.The meaning of TYPE STANDARD TABLE OF and TYPE TABLE OF is exactly the same.
2.A table of TYPE HASHED TABLE creates an internal table that is represented using an internal HASH algorithm, allowing reads to the table where the cost is (by approximation) independent from the size of the table. Using this type of table is good when you have large data-sets with a lot of reads, but comparatively few writes. When declaring a hash table you have to also declare a UNIQUE KEY, as the HASH algorithm is dependent on this.
2)hashed 表可以sort，默认升序（与Java不同）
3)hashed 和sorted table需要定义key，否则会报错。
WITH UNIQUE KEY matnr,
WITH NON-UNIQUE KEY matnr
ABAP中有三类内表，标准表，排序表和哈希表。
标准表
标准表：关键字为STANDARD TABLE, 系统为该表的每一行数据生成一个逻辑索引。 填充标准表时，可以将数据附加在现有行之后，也可以插入到指定的位置，程序对内表行的寻址操作可通过关键字或索引进行。在对表进行插入、删除等操作时，各数据行在内存中的位置不变，系统仅重新排列各数据行的索引值。
排序表
排序表：关键字为 SORTED TABLE, 也具有一个逻辑索引，不同之处是排序表总是按其关键字升序排序后再进行存储，其访问方式与标准表相同。   
哈希表
哈希表：关键字为 HASHED TABLE, 没有索引，只能通过关键字来访问。系统用哈希算法管理表中的数据，因而其寻址一个数据行的时间和表的行数无关。
行访问方式
                                        标准表                    排序表               哈希表
索引访问                           允许                       允许                 不允许
关键字访问                       允许                       允许                  允许
相同值关键字行              可重复           可重复或不可重复       不可重复
推荐访问方式            主要通过索引        主要通过关键字        只能通过关键字 
具体到使用什么类型的内表    
 对于一个小于100行的内表，且很少使用关键字操作，则使用标准表没有效率问题；数据量比较巨大，切不存在重复行，只需使用关键字访问的内表应定义为哈希表；排序表适用于运行期内必须以某种排序形式出现的内表。
1. 内表的类型及定义：
（ 1 ） .ANY TABLE ：即任意表类型，此种定义方式只能在传递参数的时候定义。
例如： FORM XXX USING/CHANGING TYPE ANY TABLE .
（ 2 ） .ANY TABLE 包括了两种类型： INDEX TABLE 和 HASHED TABLE 
《 1 》 .INDEX TABLE ：包括了 STANDARD TABLE 和 SORTED TABLE
A. STANDARD TABLE ：其实就是一个线性表，通过 key 访问内表是线性查找的，也就是说，随着表中记录的增加，对表的操作的时间开销也相应的增加。
定义方法： TYPES/DATA ： LIKE/TYPE STANDARD TABLE OF .
B. SORTED TABLE: 顾名思义，表中的记录是按照一定的顺序排列的。访问表的主要方式是表中定义的 key ，如果 key 不唯一，则选择 index 最小的那个。也可以通过 index 来访问排序表，如果你想通过 index 插入一条记录，系统会自动检查你插入的位置是否正确。所以，如果插入的时间比插入到标准表的时间会长。因此，尽量选择 key 来对排序表进行操作。
定义方法： TYPES/DATA ： LIKE/TYPE SORTED TABLE OF .
《 2 》 .HASHED TABLE ：对哈希表只能用你定义的 key 进行操作，而不能使用 index 进行操作。因此，定义哈希表必须定义 unique key 。注意：所有关于使用 index 操作表的语句都不能用于操作哈希表。例如： sort ， loop 等。
类
1类的定义：包含声明部分和实现部分。
CLASS zc_01 DEFINITION."声明部分
  PUBLIC SECTION.
    DATA:text1(5) TYPE c VALUE '01234'.
    METHODS {z_name}
      IMPORTING …… TYPE {type} VALUE {value}
      EXPORTING …… TYPE {type} VALUE {value}
      CHANGING …… TYPE {type} VALUE {value}
      RAISING cx_sy_arithmetic_error.
      .
  PROTECTED SECTION.
 "   {……}
  PRIVATE SECTION.
 "   {……}   
ENDCLASS.
CLASS zc_01 IMPLEMENTATION."实现部分
  METHOD {z_name}.
    {……}
    ENDMETHOD.
  ENDCLASS.
2部分参数： RETURNING不能与EXPORTING、CHANGING同时使用，调用方法时，使用的是RECEIVING参数。
CLASS zc_01 DEFINITION."声明部分
  PUBLIC SECTION.
    DATA:text1(5) TYPE c VALUE '01234'.
    METHODS {z_name}
      IMPORTING …… TYPE {type} VALUE {value}
      RETURNING VALUE({z_name}) TYPE type
      RAISING cx_sy_arithmetic_error.
      .
  PROTECTED SECTION.
 "   {……}
  PRIVATE SECTION.
 "   {……}   
ENDCLASS.
CLASS zc_01 IMPLEMENTATION."实现部分
  METHOD {z_name}.
    {……}
    ENDMETHOD.
  ENDCLASS.
3语法格式
访问内容
语法格式
一个对象的实例属性或静态属性
orer->attr
类的静态属性
class=>attr
在类内部访问自身实例属性或静态属性
me->attr 或 attr
对象的实例属性或静态方法
CALL METHOD orer -> meth
类的静态方法
CALL METHOD class=>meth
在类内部访问自身实例方法或静态方法
CALL METHOD me->attr 或 CALL METHOD attr
4实例
CLASS zc_01 IMPLEMENTATION."类中的方法"
  METHOD zm_gettext.
    CONCATENATE text2 text1 INTO text3.
    text5 = text3.
*    WRITE:/ text5.
  ENDMETHOD.
ENDCLASS.
DATA o_zc_01 TYPE REF TO zc_01."创建一个实例"
DATA text4(10) TYPE c."定义导出参数类型"
DATA text8(10) TYPE c.
*data text6 type c."定义正常receiving返回值类型"
START-OF-SELECTION.
  CREATE OBJECT o_zc_01 .
  CALL METHOD o_zc_01->zm_gettext
    IMPORTING
      text3 = text4
    RECEIVING
      text5 = text8.
  WRITE:/ '测试正常获取返回值'.
  WRITE:/ text4.
  o_zc_01->zm_gettext( RECEIVING text5 = DATA(text7) )."注意括号之间最好有一定的间隔"
  WRITE:/ '测试动态声明变量来接受传出参数'.
  WRITE:/ text7.