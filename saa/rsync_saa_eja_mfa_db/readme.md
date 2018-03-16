saa_backups_full.sh - script for automation of SAA EJA, MFA, DB Backups process,
Securing by 7z password and sync over ssh protocol to storages
check backups on destination and automaticaly deleting syncronized files if
these files present on destination.

saa_backups_full.sh - script for monitoring saa_backups_full.sh over Nagios client (NRPE)

For Cygwin + Win with rsync, ssh packages.

--------------log sample---------------------
new backup log created for silicon  5 мар 2018 г. 18:51:31
Working dir is: /cygdrive/m/alliance_backarch/backup/mfa
-- Params is: --
the arc prefix is: MEAR, the delete period is: +91
Local patch: /cygdrive/m/alliance_backarch/backup/mfa
Remote patch: /mnt/melony/Melony/alliance_backarch/backup/mfa_silicon_zip
-- Zipping Cyrcle --
zip file for MEAR_20171001_20171031 exist
zip file for MEAR_20171101_20171130 exist
zip file for MEAR_20171201_20171231 exist
zip file for MEAR_20180101_20180131 exist
MEAR_20171001_20171031.7z Everything is Ok
MEAR_20171101_20171130.7z Everything is Ok
MEAR_20171201_20171231.7z Everything is Ok
MEAR_20180101_20180131.7z Everything is Ok
---- Rsync Cyrcle ----
file MEAR_20171001_20171031.7z is exist on destination backup@sync.253.int
file MEAR_20171101_20171130.7z is exist on destination backup@sync.253.int
file MEAR_20171201_20171231.7z is exist on destination backup@sync.253.int
file MEAR_20180101_20180131.7z is exist on destination backup@sync.253.int
file MEAR_20171001_20171031.7z is exist on destination backup@sync2.253.int
file MEAR_20171101_20171130.7z is exist on destination backup@sync2.253.int
file MEAR_20171201_20171231.7z is exist on destination backup@sync2.253.int
file MEAR_20180101_20180131.7z is exist on destination backup@sync2.253.int
file MEAR_20171001_20171031.7z is exist on destination backup@vcsinus.waw253.int
file MEAR_20171101_20171130.7z is exist on destination backup@vcsinus.waw253.int
file MEAR_20171201_20171231.7z is exist on destination backup@vcsinus.waw253.int
file MEAR_20180101_20180131.7z is exist on destination backup@vcsinus.waw253.int
 -- Deletion Status is 0, Enable - 0, if no - Error -- 
Working dir is: /cygdrive/m/alliance_backarch/backup/eja
-- Params is: --
the arc prefix is: JRAR, the delete period is: +6
Local patch: /cygdrive/m/alliance_backarch/backup/eja
Remote patch: /mnt/melony/Melony/alliance_backarch/backup/eja_silicon_zip
-- Zipping Cyrcle --
zip file for JRAR_20180224 exist
deleted 'JRAR_20180224/JRAR_20180224.DATAPUMP'
deleted 'JRAR_20180224/JRAR_20180224.inf'
deleted 'JRAR_20180224/JRAR_20180224.LOG'
удален каталог 'JRAR_20180224'
zip file for JRAR_20180225 exist
deleted 'JRAR_20180225/JRAR_20180225.DATAPUMP'
deleted 'JRAR_20180225/JRAR_20180225.inf'
deleted 'JRAR_20180225/JRAR_20180225.LOG'
удален каталог 'JRAR_20180225'
zip file for JRAR_20180226 exist
zip file for JRAR_20180227 exist
zip file for JRAR_20180228 exist
zip file for JRAR_20180301 exist
zip file for JRAR_20180302 exist
zipping JRAR_20180303

7-Zip [64] 15.14 : Copyright (c) 1999-2015 Igor Pavlov : 2015-12-31
p7zip Version 15.14.1 (locale=ru_RU.UTF-8,Utf16=on,HugeFiles=on,64 bits,24 CPUs Intel(R) Xeon(R) CPU           X5660  @ 2.80GHz (206C2),ASM,AES-NI)

Scanning the drive:
3 files, 3249869 bytes (3174 KiB)

Creating archive: JRAR_20180303.7z

Items to compress: 3


Files read from disk: 3
Archive size: 601178 bytes (588 KiB)
Everything is Ok
zip file for JRAR_20180303 exist
zipping JRAR_20180304

7-Zip [64] 15.14 : Copyright (c) 1999-2015 Igor Pavlov : 2015-12-31
p7zip Version 15.14.1 (locale=ru_RU.UTF-8,Utf16=on,HugeFiles=on,64 bits,24 CPUs Intel(R) Xeon(R) CPU           X5660  @ 2.80GHz (206C2),ASM,AES-NI)

Scanning the drive:
3 files, 538315 bytes (526 KiB)

Creating archive: JRAR_20180304.7z

Items to compress: 3


Files read from disk: 3
Archive size: 94091 bytes (92 KiB)
Everything is Ok
zip file for JRAR_20180304 exist
JRAR_20180222.7z Everything is Ok
JRAR_20180223.7z Everything is Ok
JRAR_20180224.7z Everything is Ok
JRAR_20180225.7z Everything is Ok
JRAR_20180226.7z Everything is Ok
JRAR_20180227.7z Everything is Ok
JRAR_20180228.7z Everything is Ok
JRAR_20180301.7z Everything is Ok
JRAR_20180302.7z Everything is Ok
JRAR_20180303.7z Everything is Ok
JRAR_20180304.7z Everything is Ok
---- Rsync Cyrcle ----
file JRAR_20180222.7z is exist on destination backup@sync.253.int
file JRAR_20180223.7z is exist on destination backup@sync.253.int
file JRAR_20180224.7z is exist on destination backup@sync.253.int
file JRAR_20180225.7z is exist on destination backup@sync.253.int
file JRAR_20180226.7z is exist on destination backup@sync.253.int
file JRAR_20180227.7z is exist on destination backup@sync.253.int
file JRAR_20180228.7z is exist on destination backup@sync.253.int
file JRAR_20180301.7z is exist on destination backup@sync.253.int
file JRAR_20180302.7z is exist on destination backup@sync.253.int
We have diferens between <f+++++++++ JRAR_20180303.7z on backup@sync.253.int, try to sync
building file list ... done
<f+++++++++ JRAR_20180303.7z

sent 601.44K bytes  received 34 bytes  240.59K bytes/sec
total size is 601.18K  speedup is 1.00
file JRAR_20180303.7z is exist on destination backup@sync.253.int
-------------- check again result after sync ----------------
We have diferens between <f+++++++++ JRAR_20180304.7z on backup@sync.253.int, try to sync
building file list ... done
<f+++++++++ JRAR_20180304.7z

sent 94.22K bytes  received 34 bytes  37.70K bytes/sec
total size is 94.09K  speedup is 1.00
file JRAR_20180304.7z is exist on destination backup@sync.253.int
-------------- check again result after sync ----------------
file JRAR_20180222.7z is exist on destination backup@sync2.253.int
file JRAR_20180223.7z is exist on destination backup@sync2.253.int
file JRAR_20180224.7z is exist on destination backup@sync2.253.int
file JRAR_20180225.7z is exist on destination backup@sync2.253.int
file JRAR_20180226.7z is exist on destination backup@sync2.253.int
file JRAR_20180227.7z is exist on destination backup@sync2.253.int
file JRAR_20180228.7z is exist on destination backup@sync2.253.int
file JRAR_20180301.7z is exist on destination backup@sync2.253.int
file JRAR_20180302.7z is exist on destination backup@sync2.253.int
We have diferens between <f+++++++++ JRAR_20180303.7z on backup@sync2.253.int, try to sync
building file list ... done
<f+++++++++ JRAR_20180303.7z

sent 601.44K bytes  received 34 bytes  400.98K bytes/sec
total size is 601.18K  speedup is 1.00
file JRAR_20180303.7z is exist on destination backup@sync2.253.int
-------------- check again result after sync ----------------
We have diferens between <f+++++++++ JRAR_20180304.7z on backup@sync2.253.int, try to sync
building file list ... done
<f+++++++++ JRAR_20180304.7z

sent 94.22K bytes  received 34 bytes  188.51K bytes/sec
total size is 94.09K  speedup is 1.00
file JRAR_20180304.7z is exist on destination backup@sync2.253.int
-------------- check again result after sync ----------------
file JRAR_20180222.7z is exist on destination backup@vcsinus.waw253.int
file JRAR_20180223.7z is exist on destination backup@vcsinus.waw253.int
file JRAR_20180224.7z is exist on destination backup@vcsinus.waw253.int
file JRAR_20180225.7z is exist on destination backup@vcsinus.waw253.int
file JRAR_20180226.7z is exist on destination backup@vcsinus.waw253.int
file JRAR_20180227.7z is exist on destination backup@vcsinus.waw253.int
file JRAR_20180228.7z is exist on destination backup@vcsinus.waw253.int
file JRAR_20180301.7z is exist on destination backup@vcsinus.waw253.int
file JRAR_20180302.7z is exist on destination backup@vcsinus.waw253.int
We have diferens between <f+++++++++ JRAR_20180303.7z on backup@vcsinus.waw253.int, try to sync
building file list ... done
<f+++++++++ JRAR_20180303.7z

sent 601.44K bytes  received 34 bytes  240.59K bytes/sec
total size is 601.18K  speedup is 1.00
file JRAR_20180303.7z is exist on destination backup@vcsinus.waw253.int
-------------- check again result after sync ----------------
We have diferens between <f+++++++++ JRAR_20180304.7z on backup@vcsinus.waw253.int, try to sync
building file list ... done
<f+++++++++ JRAR_20180304.7z

sent 94.22K bytes  received 34 bytes  37.70K bytes/sec
total size is 94.09K  speedup is 1.00
file JRAR_20180304.7z is exist on destination backup@vcsinus.waw253.int
-------------- check again result after sync ----------------
 -- Deletion Status is 0, Enable - 0, if no - Error -- 
JRAR_20180222.7z - marked for del
deleted 'JRAR_20180222.7z'
JRAR_20180223.7z - marked for del
deleted 'JRAR_20180223.7z'
JRAR_20180224.7z - marked for del
deleted 'JRAR_20180224.7z'
JRAR_20180225.7z - marked for del
deleted 'JRAR_20180225.7z'
Working dir is: /cygdrive/m/alliance_backarch/backup/db
-- Params is: --
the arc prefix is: *SAA_DATA, the delete period is: +6
Local patch: /cygdrive/m/alliance_backarch/backup/db
Remote patch: /mnt/sync/SYNC/srv_sync/DB_Backup/db_silicon_zip
-- Zipping Cyrcle --
zip file for 20180302T000500_SAA_DATA_BACKUP exist
zip file for 20180303T000500_SAA_DATA_BACKUP exist
zipping 20180304T000500_SAA_DATA_BACKUP

7-Zip [64] 15.14 : Copyright (c) 1999-2015 Igor Pavlov : 2015-12-31
p7zip Version 15.14.1 (locale=ru_RU.UTF-8,Utf16=on,HugeFiles=on,64 bits,24 CPUs Intel(R) Xeon(R) CPU           X5660  @ 2.80GHz (206C2),ASM,AES-NI)

Scanning the drive:
4 folders, 48 files, 603073716 bytes (576 MiB)

Creating archive: 20180304T000500_SAA_DATA_BACKUP.7z

Items to compress: 52


Files read from disk: 48
Archive size: 36184411 bytes (35 MiB)
Everything is Ok
zip file for 20180304T000500_SAA_DATA_BACKUP exist
zipping 20180305T000500_SAA_DATA_BACKUP

7-Zip [64] 15.14 : Copyright (c) 1999-2015 Igor Pavlov : 2015-12-31
p7zip Version 15.14.1 (locale=ru_RU.UTF-8,Utf16=on,HugeFiles=on,64 bits,24 CPUs Intel(R) Xeon(R) CPU           X5660  @ 2.80GHz (206C2),ASM,AES-NI)

Scanning the drive:
4 folders, 48 files, 602840244 bytes (575 MiB)

Creating archive: 20180305T000500_SAA_DATA_BACKUP.7z

Items to compress: 52


Files read from disk: 48
Archive size: 36102899 bytes (35 MiB)
Everything is Ok
zip file for 20180305T000500_SAA_DATA_BACKUP exist
20180223T000500_SAA_DATA_BACKUP.7z Everything is Ok
20180224T000500_SAA_DATA_BACKUP.7z Everything is Ok
20180225T000500_SAA_DATA_BACKUP.7z Everything is Ok
20180226T000500_SAA_DATA_BACKUP.7z Everything is Ok
20180227T000500_SAA_DATA_BACKUP.7z Everything is Ok
20180228T000501_SAA_DATA_BACKUP.7z Everything is Ok
20180301T000500_SAA_DATA_BACKUP.7z Everything is Ok
20180302T000500_SAA_DATA_BACKUP.7z Everything is Ok
20180303T000500_SAA_DATA_BACKUP.7z Everything is Ok
20180304T000500_SAA_DATA_BACKUP.7z Everything is Ok
20180305T000500_SAA_DATA_BACKUP.7z Everything is Ok
---- Rsync Cyrcle ----
file 20180223T000500_SAA_DATA_BACKUP.7z is exist on destination backup@sync.253.int
file 20180224T000500_SAA_DATA_BACKUP.7z is exist on destination backup@sync.253.int
file 20180225T000500_SAA_DATA_BACKUP.7z is exist on destination backup@sync.253.int
file 20180226T000500_SAA_DATA_BACKUP.7z is exist on destination backup@sync.253.int
file 20180227T000500_SAA_DATA_BACKUP.7z is exist on destination backup@sync.253.int
file 20180228T000501_SAA_DATA_BACKUP.7z is exist on destination backup@sync.253.int
file 20180301T000500_SAA_DATA_BACKUP.7z is exist on destination backup@sync.253.int
file 20180302T000500_SAA_DATA_BACKUP.7z is exist on destination backup@sync.253.int
file 20180303T000500_SAA_DATA_BACKUP.7z is exist on destination backup@sync.253.int
We have diferens between <f+++++++++ 20180304T000500_SAA_DATA_BACKUP.7z on backup@sync.253.int, try to sync
building file list ... done
<f+++++++++ 20180304T000500_SAA_DATA_BACKUP.7z

sent 36.19M bytes  received 34 bytes  10.34M bytes/sec
total size is 36.18M  speedup is 1.00
file 20180304T000500_SAA_DATA_BACKUP.7z is exist on destination backup@sync.253.int
-------------- check again result after sync ----------------
We have diferens between <f+++++++++ 20180305T000500_SAA_DATA_BACKUP.7z on backup@sync.253.int, try to sync
building file list ... done
<f+++++++++ 20180305T000500_SAA_DATA_BACKUP.7z

sent 36.11M bytes  received 34 bytes  10.32M bytes/sec
total size is 36.10M  speedup is 1.00
file 20180305T000500_SAA_DATA_BACKUP.7z is exist on destination backup@sync.253.int
-------------- check again result after sync ----------------
file 20180223T000500_SAA_DATA_BACKUP.7z is exist on destination backup@sync2.253.int
file 20180224T000500_SAA_DATA_BACKUP.7z is exist on destination backup@sync2.253.int
file 20180225T000500_SAA_DATA_BACKUP.7z is exist on destination backup@sync2.253.int
file 20180226T000500_SAA_DATA_BACKUP.7z is exist on destination backup@sync2.253.int
file 20180227T000500_SAA_DATA_BACKUP.7z is exist on destination backup@sync2.253.int
file 20180228T000501_SAA_DATA_BACKUP.7z is exist on destination backup@sync2.253.int
file 20180301T000500_SAA_DATA_BACKUP.7z is exist on destination backup@sync2.253.int
file 20180302T000500_SAA_DATA_BACKUP.7z is exist on destination backup@sync2.253.int
file 20180303T000500_SAA_DATA_BACKUP.7z is exist on destination backup@sync2.253.int
We have diferens between <f+++++++++ 20180304T000500_SAA_DATA_BACKUP.7z on backup@sync2.253.int, try to sync
building file list ... done
<f+++++++++ 20180304T000500_SAA_DATA_BACKUP.7z

sent 36.19M bytes  received 34 bytes  8.04M bytes/sec
total size is 36.18M  speedup is 1.00
file 20180304T000500_SAA_DATA_BACKUP.7z is exist on destination backup@sync2.253.int
-------------- check again result after sync ----------------
We have diferens between <f+++++++++ 20180305T000500_SAA_DATA_BACKUP.7z on backup@sync2.253.int, try to sync
building file list ... done
<f+++++++++ 20180305T000500_SAA_DATA_BACKUP.7z

sent 36.11M bytes  received 34 bytes  8.02M bytes/sec
total size is 36.10M  speedup is 1.00
file 20180305T000500_SAA_DATA_BACKUP.7z is exist on destination backup@sync2.253.int
-------------- check again result after sync ----------------
file 20180223T000500_SAA_DATA_BACKUP.7z is exist on destination backup@vcsinus.waw253.int
file 20180224T000500_SAA_DATA_BACKUP.7z is exist on destination backup@vcsinus.waw253.int
file 20180225T000500_SAA_DATA_BACKUP.7z is exist on destination backup@vcsinus.waw253.int
file 20180226T000500_SAA_DATA_BACKUP.7z is exist on destination backup@vcsinus.waw253.int
file 20180227T000500_SAA_DATA_BACKUP.7z is exist on destination backup@vcsinus.waw253.int
file 20180228T000501_SAA_DATA_BACKUP.7z is exist on destination backup@vcsinus.waw253.int
file 20180301T000500_SAA_DATA_BACKUP.7z is exist on destination backup@vcsinus.waw253.int
file 20180302T000500_SAA_DATA_BACKUP.7z is exist on destination backup@vcsinus.waw253.int
file 20180303T000500_SAA_DATA_BACKUP.7z is exist on destination backup@vcsinus.waw253.int
We have diferens between <f+++++++++ 20180304T000500_SAA_DATA_BACKUP.7z on backup@vcsinus.waw253.int, try to sync
building file list ... done
<f+++++++++ 20180304T000500_SAA_DATA_BACKUP.7z

sent 36.19M bytes  received 34 bytes  2.07M bytes/sec
total size is 36.18M  speedup is 1.00
file 20180304T000500_SAA_DATA_BACKUP.7z is exist on destination backup@vcsinus.waw253.int
-------------- check again result after sync ----------------
We have diferens between <f+++++++++ 20180305T000500_SAA_DATA_BACKUP.7z on backup@vcsinus.waw253.int, try to sync
building file list ... done
<f+++++++++ 20180305T000500_SAA_DATA_BACKUP.7z

sent 36.11M bytes  received 34 bytes  2.19M bytes/sec
total size is 36.10M  speedup is 1.00
file 20180305T000500_SAA_DATA_BACKUP.7z is exist on destination backup@vcsinus.waw253.int
-------------- check again result after sync ----------------
 -- Deletion Status is 0, Enable - 0, if no - Error -- 
20180223T000500_SAA_DATA_BACKUP.7z - marked for del
deleted '20180223T000500_SAA_DATA_BACKUP.7z'
20180224T000500_SAA_DATA_BACKUP.7z - marked for del
deleted '20180224T000500_SAA_DATA_BACKUP.7z'
20180225T000500_SAA_DATA_BACKUP.7z - marked for del
deleted '20180225T000500_SAA_DATA_BACKUP.7z'
20180226T000500_SAA_DATA_BACKUP.7z - marked for del
deleted '20180226T000500_SAA_DATA_BACKUP.7z'
----------- end circle time  19:00:13  -------------
