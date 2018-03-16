#!/bin/bash
#простыезвонки фикс

arc=`arch`
if [ "$arc" == "x86_64" ];
then arc=64
else arc=86
fi
prosto=$(fwconsole ma list | grep -ow prostiezvonki)
astver=$(asterisk -V | grep -woE [0-9]+\.)

#Сносим старые сошки
rm -rvf /usr/lib/asterisk/modules/cel_prostiezvonki.so
rm -rvf /usr/lib64/asterisk/modules/cel_prostiezvonki.so
rm -rvf /usr/lib/libProtocolLib.so
rm -rvf /usr/lib64/libProtocolLib.so
echo "обновляем файлы для $astver x$arc"
#Скрываем вывод скрипта, чтобы глаза отдыхали и запускаем выполнение.
{
#Проверяем версию астериска и разрядность, закидываем новые файлы
if [ "$astver" == "13" ];
then
if [ "$arc" == "x86_64" ];
	then
#Для 13 x64
cd /tmp
wget http://office.vedisoft.ru/files/all/prostiezvonki_asterisk13.zip
unzip prostiezvonki_asterisk13.zip
cd /tmp/prostiezvonki/so/64/
cp cel_prostiezvonki.so /usr/lib/asterisk/modules/
cp cel_prostiezvonki.so /usr/lib64/asterisk/modules/
cp libProtocolLib.so /usr/lib/
cp libProtocolLib.so /usr/lib64/
fwconsole reload
service asterisk restart
else
#Для 13 x86
cd /tmp
wget http://office.vedisoft.ru/files/all/prostiezvonki_asterisk13.zip
unzip prostiezvonki_asterisk13.zip
cd /tmp/prostiezvonki/so/32/
cp cel_prostiezvonki.so /usr/lib/asterisk/modules/
cp libProtocolLib.so /usr/lib/
fwconsole reload
service asterisk restart
fi
    else
    #Для 11 x64
    if [ "$arc" == "x86_64" ];
	then
    cd /tmp
    wget http://office.vedisoft.ru/files/all/prostiezvonki_asterisk11.zip
    unzip prostiezvonki_asterisk11.zip
    cd /tmp/prostiezvonki/so/64/
    cp cel_prostiezvonki.so /usr/lib/asterisk/modules/
    cp cel_prostiezvonki.so /usr/lib64/asterisk/modules/
    cp libProtocolLib.so /usr/lib/
    cp libProtocolLib.so /usr/lib64/
    fwconsole reload
    service asterisk restart
    else
    #Для 11 x86
    cd /tmp
    wget http://office.vedisoft.ru/files/all/prostiezvonki_asterisk11.zip
    unzip prostiezvonki_asterisk11.zip
    cd /tmp/prostiezvonki/so/32/
    cp cel_prostiezvonki.so /usr/lib/asterisk/modules/
    cp libProtocolLib.so /usr/lib/
    fwconsole reload
    service asterisk restart
    fi
fi
} &> /dev/null
#Чистим за собой
rm -rvf /tmp/prost*
#Проверяем смотрим чтобы поднялся порт 10150
netstat -tulpn | grep 10150
echo "Обновлены so файлы для asterisk $astver x$arc"