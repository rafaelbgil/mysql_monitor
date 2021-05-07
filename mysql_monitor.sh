#!/bin/bash
#Monitoramento Banco de dados Mysql/MariaDB/Percona e Replicação
#Autor: Rafael Benites Gil
SOCKET=''
USER_DB=''
PASSWORD_DB=''
case $1 in
                -q)
                        mysql -S $SOCKET -u$USER_DB -p$PASSWORD_DB -e "show processlist" | grep -i query | wc -l
                ;;
                -s)
                        mysql -S $SOCKET -u$USER_DB -p$PASSWORD_DB -e "show processlist" | grep -i sort | wc -l
                ;;
                -l)
                        mysql -S $SOCKET -u$USER_DB -p$PASSWORD_DB -e "show processlist" | grep -i lock | wc -l
                ;;
                -c)
                        mysql -S $SOCKET -u$USER_DB -p$PASSWORD_DB -e "show processlist" | grep -i Copying | wc -l
                ;;
                -sl)
                        mysql -S $SOCKET -u$USER_DB -p$PASSWORD_DB -e "show processlist" | grep -i Sleep | wc -l
                ;;
                -rs)
                        STATUS=$(mysql -S $SOCKET -u$USER_DB -p$PASSWORD_DB -e "SHOW SLAVE STATUS \G" | grep -i Slave_SQL_Running: | cut -f 2 -d ":" | sed "s/ *//g")
						if [ $( echo $STATUS | grep -i "Yes") ]; then
							echo "0"
						else
							echo "1"
						fi
						
                ;;
                -rt)
                        mysql -S $SOCKET -u$USER_DB -p$PASSWORD_DB -e "SHOW SLAVE STATUS \G" | grep -i Seconds_Behind_Master | cut -f 2 -d ":" | sed "s/ *//g"
                ;;
                -re)
                        mysql -S $SOCKET -u$USER_DB -p$PASSWORD_DB -e "SHOW SLAVE STATUS \G" | grep -i Last_SQL_Errno | cut -f 2 -d ":" | sed "s/ *//g"
                ;;
                *)
                echo "+==============================================================================+";
                echo "#script Monitoramento Banco Mysql/Mariadb/Percona                              #";
                echo "+==============================================================================+";
                echo "________________________________________________________________________________"
                echo "# OPCOES:                                                                      #";
                echo "--------------------------------------------------------------------------------"
                echo "| -q : Exibe quantidade de querys em execucao                                  |"
                echo "| -s : Exibe quantidade de querys em ordernacao(sorting)                       |"
                echo "| -l : Exibe quantidade de querys lock                                         |"
                echo "| -c : Exibe quantidade de querys em Copying                                   |"
                echo "| -sl : Exibe quantidade de conexoes em Sleep                                   |"
                echo "| -rs : Exibe status da execucao da replicacao                                 |"
                echo "| -rt : Exibe total de segundos de diferenca do servidor replica para o master |"
                echo "| -re : Exibe status de erro na replica (retorno 0 nao ha erro)                |"
                echo "+==============================================================================+"
                exit;
                ;;
esac
