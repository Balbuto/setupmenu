#!/bin/bash

end()
{
echo -e "файл с иформацией лежит $out, нажмите любую кнопку для продолжения"
read -s -n 1
}

arc=`arch`
if [ "$arc" == "x86_64" ];
then arc=64
else arc=86
fi

astver=$(asterisk -V | grep -woE [0-9]+\.)
out="/tmp/outputinfo.txt"
uname=`uname -r`
red=`cat /etc/redhat-release`
deb=`cat /etc/debian_version`
ip=`fwconsole extip`
freepbx=`rpm -qa | grep freepbx`

#gathering system and asterisk info
echo "linux $uname" >> $out
if ! [ -f /etc/redhat-release ];
then echo "$deb" >> $out
else echo "$red" >> $out
fi
echo "$freepbx" >> $out
echo "asterisk $astver" >> $out
echo "arch x$arc" >> $out
echo "$ip" >> $out
end
