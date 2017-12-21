# scripts
scripts for SWIFT SAA/SAG automatisation


-- vsftpd_auth_over_db
Набор скриптов для автоматической смены/генерации пароля в связке (vsftpd + auth over MySQL) <-> WinSCP Client.

Суть процедуры:
- наш сервер смотрит время смены пароля, если больше года генерирует его.
- файл с паролем <bic4>.pwd перекладывается в директорию ftps://<bic4>/Transit.
- скрипт при наличии pwd файла обновляет пароль в файле /cygwin/usr/local/bin/sigma_script и выкладывает обратно нам не пустой 
  файл <bic4>.req
- сервер при наличии в директории банка <bic4>.req меняет пароль у нас и генерирует <bic4>.res - пароль изменен.

Изменение пароля без Cygwin
Запросто, берете пароль из <bic4>.pwd,  выкладываете в Transit не пустой файл <bic4>.req, прописываете пароль в /cygwin/usr/local/bin/sigma_script (сохранив предыдущий файл). Все.

Важно:
- менять пароль в файле смысла нет, сервер эти файлы не читает и пароль будет таким, какой сгененрирован.

---------------------------------------------------------------------------------------------------------


-- sag--> SWIFT Alliance Gateway + SWP

  - sag_backsync.sh Ежемесячный SWP+SAG и ежедневный бэкап SAG, синхронизация на несколько серверов


----------------------------------------------------------------------------------------------------------

-- include --> libs for bash

match_current_dir.sh - Script for check directory before operations (is exist, is dir, and is mach to needed dir)

---------------------------------------------------------------------------------------------------------

-- saa --> SAA - SWIFT Alliance Access
 - check_rd_backup.sh
    Cygwin + Win, Script for control RD-Log files in SAA Redolog dir.
    Started from Nagios NRPE client, exit codes 0 - ok, 1 - warning, 2 - Error
    For saa_dbrecovery with incremental backup 30 min.

 - limit_copy.sh Скрипт для копирования RGE формата в другую директорию с лимитами по валюте/сумме по полю 32A


----------------------------------------------------------------------------------------------------------

-- sha256_check.sh Check backups, add new backups, log file for Nagios (cat_sha256_log.sh)