# Comment out EXTENSION related entries from the pg_restore object list
! /EXTENSION/ {print}
/EXTENSION/   {print ";" $0}
