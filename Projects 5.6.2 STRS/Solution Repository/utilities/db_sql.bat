d:
cd \Projects\Solution Repository\2 - tables
del .\all_tables.sql
copy *.sql all_tables.sql
cd \Projects\Solution Repository\3 - views
del .\all_views.sql
copy *.sql all_views.sql
cd \Projects\Solution Repository\4 - stored procedures
del .\all_stored_procedures.sql
copy *.sql all_stored_procedures.sql
cd \Projects\Solution Repository\1 - database
del ".\1 - CREATE_STRSSOLUTIONDB_DATABASE_load_as_sys.sql"
copy "\Projects\Solution Repository\2 - tables\all_tables.sql"+"\Projects\Solution Repository\3 - views\all_views.sql"+"\Projects\Solution Repository\4 - stored procedures\all_stored_procedures.sql"  "1 - CREATE_STRSSOLUTIONDB_DATABASE_load_as_sys.sql"
//
pause