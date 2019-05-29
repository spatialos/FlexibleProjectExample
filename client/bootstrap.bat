IF "%1"=="" (
   ECHO hostname argument not set.
   PAUSE
   EXIT 1
)

IF "%2"=="" (
   ECHO pit argument not set.
   PAUSE
   EXIT 1
)

IF "%3"=="" (
   ECHO lt argument not set.
   PAUSE
   EXIT 1
)

SET hostname=%1
SET pit=%2
SET lt=%3

Client.exe cloud %hostname% %pit% %lt%