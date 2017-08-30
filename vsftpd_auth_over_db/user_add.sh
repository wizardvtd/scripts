#!/bin/bash

for user in username1 username2
    do

    #файл где хранится uid 
    id=`awk '{print $1}' < "/root/scripts/pwd/user.uid"`

    groupadd $user -g $id
    useradd $user -u $id -g $id -c "$user comment" -s /bin/false -d /mnt/ftps_dirs/$user
 
    # Тут можно использовать pwgen например... 
    pass=`awk '{print $1}' < "/root/scripts/pwd/$user.pwd"`

    #если нужно заведение пароля в систему
    #chpasswd <<< $user:$pass

#Добавление в mysql
mysql -B -u user -pPotsworD vsftpd -Be "INSERT INTO vsftpd.accounts (id, username, pass, datepass) VALUES (NULL, '$user', PASSWORD('$pass'), CURRENT_TIMESTAMP);"
# uid +1 в файл
    (( id++ ))
    echo $id > /root/scripts/pwd/user.uid
done
