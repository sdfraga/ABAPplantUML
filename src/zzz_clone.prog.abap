*&---------------------------------------------------------------------*
*& Report zzz_clone
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zzz_clone.
CLASS lcl_range DEFINITION.
  PUBLIC SECTION.
    TYPES tv_date TYPE d.
    DATA: mv_start TYPE tv_date,
          mv_stop  TYPE tv_date.

    METHODS constructor
      IMPORTING iv_start TYPE tv_date
                iv_stop  TYPE tv_date.
    METHODS create_copy
      IMPORTING iv_start        TYPE tv_date OPTIONAL
                iv_stop         TYPE tv_date OPTIONAL
      RETURNING VALUE(ro_range) TYPE REF TO lcl_range.
ENDCLASS.

CLASS lcl_range IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).
    mv_start = iv_start.
    mv_stop = iv_stop.
  ENDMETHOD.

  METHOD create_copy.
    DATA lv_start TYPE tv_date.
    DATA lv_stop TYPE tv_date.

    WRITE:/ 'Called with START = ',  iv_start, ' STOP=',  iv_stop.
    IF iv_start IS NOT SUPPLIED.
      lv_start = mv_start.
    ELSE.
      lv_start = iv_start.
    ENDIF.
    IF iv_stop IS NOT SUPPLIED.
      lv_stop = mv_stop.
    ELSE.
      lv_stop = iv_stop.
    ENDIF.
    WRITE:/ 'Updated to START = ',  lv_start, ' STOP=',  lv_stop.
    CREATE OBJECT ro_range
      EXPORTING
        iv_start = lv_start
        iv_stop  = lv_stop.
  ENDMETHOD.
ENDCLASS.

DATA go_2009_range TYPE REF TO lcl_range.
DATA go_copy TYPE REF TO lcl_range.

START-OF-SELECTION.
  CREATE OBJECT go_2009_range
    EXPORTING
      iv_start = '20090101'
      iv_stop  = '20091221'.
* Clone
  go_copy = go_2009_range->create_copy( ).
* Extend range to end of 2010
  go_copy = go_2009_range->create_copy( iv_stop = '20101231' ).
* New start date: May 1st 2009
  go_copy = go_2009_range->create_copy( iv_start = '20090501' ).
