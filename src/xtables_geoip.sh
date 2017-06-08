#!/bin/bash
#Скрипт сборки geoip модуля для iptables
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

br()
{
echo ""
}

myinstall()
{
if [ -z `rpm -qa $1` ]; then
	yum -y install $1
else
	echo "Пакет $1 уже установлен"
	br
fi
}

workdir='/root/setupmenu/src'
arc=`arch`
conf='/lib/modules/$(uname -r)/build/include/linux/autoconf.h'

#Начало установки
clear
	echo "Начинаем установку"
			echo "Ставим зависимости"
				myinstall gcc 
				myinstall gcc-c++ 
				myinstall make 
				myinstall automake 
				myinstall unzip 
				myinstall zip 
				myinstall xz 
				myinstall kernel-devel-$(uname -r) 
				myinstall iptables-devel
				myinstall epel-release
				
#Весь ниже написанный головняк связан исключительно с пакетом perl-Text-CSV_XS

#Проверяем разрядность для установки репозитория
		if [ "$arc" == "x86_64" ];
		then rpm -i ftp://rpmfind.net/linux/dag/redhat/el6/en/x86_64/dag/RPMS/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
		else rpm -i ftp://rpmfind.net/linux/dag/redhat/el6/en/i386/dag/RPMS/rpmforge-release-0.5.3-1.el6.rf.i686.rpm
		fi
		echo "Установлен репозиторий $arc"	
		
#Пробуем ставить из репозитория
		myinstall perl-Text-CSV_XS
		
#На всякий случай проверяем, поставился perl-Text-CSV_XS из репозитория или нет, если не поставился, то ставим из rpm SRC директории скрипта.		
		PKG_OK=$(rpm -qa | grep perl-Text-CSV_XS)
		echo Checking for somelib: $PKG_OK
		if [ "" == "$PKG_OK" ];  #проверяем поставился perl-Text-CSV_XS из репозитория или нет
		then
		echo "Не найден в репозитории, ставим из rpm"
		if [ "$arc" == "x86_64" ]; #проверяем разрядность, чтобы не гадать и не спрашивать какую версию ставить.
		then
		rpm -i $workdir/perl-Text-CSV_XS-0.80-1.el6.rf.x86_64.rpm
		echo "установлена x64 версия"
		else
		rpm -i $workdir/perl-Text-CSV_XS-0.85-1.el6.i686.rpm
		echo "установлена x86 версия"
		fi
		else
		echo "Уже установлено, пропускаем"
		fi
		
#Если все ок, то ставим сам уже geoip модуль.
		echo "ставим geoip"
		cp $workdir/xtables-addons-1.47.1.tar.xz /tmp
		cd /tmp
		tar xvf xtables-addons-1.47.1.tar.xz
		cd xtables-addons-1.47.1 
		./configure
		cd /lib/modules/$(uname -r)/build/include/linux/
		if [[ 'grep '#define CONFIG_IP6_NF_IPTABLES_MODULE 1' autoconf.h' ]];
		then 
		replace "#define CONFIG_IP6_NF_IPTABLES_MODULE 1" "/*#define CONFIG_IP6_NF_IPTABLES_MODULE 1*/" -- autoconf.h
		echo "Заменили строку"
		else 
		echo "уже отредактирована, пропускаю"
		fi
		cd /tmp/xtables-addons-1.47.1
		echo "Запускаю компиляцию модуля"
		make && make install
		sleep 5
		cd geoip/ 
		./xt_geoip_dl 
		./xt_geoip_build GeoIPCountryWhois.csv 
		mkdir -p /usr/share/xt_geoip/ 
		cp -r {BE,LE} /usr/share/xt_geoip/
		modprobe xt_geoip
	br
		echo "Модуль geoip установлен"
	br
	 echo "Подчищаем за собой"
	 mkdir -p /root/garbage
	 rm -rf /tmp/xtables*
	 mv /etc/yum.repos.d/epel.repo /root/garbage/
	 mv /etc/yum.repos.d/epel-testing.repo /root/garbage/
	 mv /etc/yum.repos.d/mirrors-rpmforge /root/garbage/
	 mv /etc/yum.repos.d/mirrors-rpmforge-extras /root/garbage/
	 mv /etc/yum.repos.d/mirrors-rpmforge-testing /root/garbage/
	 mv /etc/yum.repos.d/rpmforge.repo /root/garbage/
	 echo "Все чисто, можно работать дальше"
waitend