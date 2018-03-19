#!/bin/bash
# Скрипт отключения неиспользуемых модулий FreePBX
#Алиасы
RED=\\e[91m
GRE=\\e[92m
DEF=\\e[0m

wait()
{
echo -e "$GRE Нажмите любую клавишу $DEF"
read -s -n 1
}

waitend()
{
echo -e "$GRE Нажмите любую клавишу чтобы вернуться в меню $DEF"
read -s -n 1
}

#Начало работы
 echo "Отключаю модули"
    fwconsole ma disable bria
    fwconsole ma disable broadcast
    fwconsole ma disable bulkdids
    fwconsole ma disable bulkextensions
    fwconsole ma disable callerid
    fwconsole ma disable calllimit
    fwconsole ma disable conferencespro
    fwconsole ma disable cxpanel
    fwconsole ma disable dahdiconfig
    fwconsole ma disable digium_phones
    fwconsole ma disable endpoint
    fwconsole ma disable faxpro
    fwconsole ma disable freepbx_ha
    fwconsole ma disable pagingpro
    fwconsole ma disable parkpro
    fwconsole ma disable pinsetspro
    fwconsole ma disable recording_report
    fwconsole ma disable restapps
    fwconsole ma disable sangomacrm
    fwconsole ma disable sipstation
    fwconsole ma disable ucpnode
    fwconsole ma disable vmnotify
    fwconsole ma disable voicemail_report
    fwconsole ma disable vqplus
    fwconsole ma disable webcallback
    fwconsole ma disable xmpp
    fwconsole ma disable zulu
    fwconsole ma disable irc
    fwconsole ma disable sng_mcu
    fwconsole ma disable ucpnode
    fwconsole ma disable sangomacrm
    fwconsole ma disable rmsadmin
    fwconsole ma disable vmnotify
    fwconsole ma disable cos
    fwconsole ma disable reminder
 echo "Модули успешно отключены"
    fwconsole reload
waitend