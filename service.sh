#!/system/bin/sh
# Please don't hardcode /magisk/modname/... ; instead, please use $MODDIR/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODDIR=${0%/*}

boldbeast_vercode=`grep versionCode $MODDIR/module.prop | cut -b 13-`
[ -z "$boldbeast_vercode" ] && boldbeast_vercode=1111
setprop boldbeast.callrecordingfix.mver $boldbeast_vercode

for i in {1..50}
do
	service check media.audio_flinger | grep -q "media.audio_flinger: found" -
	if [ $? -eq 0 ]; then
		log -t "BOLDBEAST" "Audioflinger detected."
		break
	fi
	usleep 100000
done
usleep 1500000
log -t "BOLDBEAST" "boldbeast.callrecordingfix.mver=$boldbeast_vercode"

boldbeast_svcflag=$MODDIR/bbservice.flg
boldbeast_logfolder=/data/local/BBBootLog
mkdir -p $boldbeast_logfolder 2>/dev/null
chmod 0775 $boldbeast_logfolder
if [ -d "$boldbeast_logfolder" ]; then
	echo 1 > $boldbeast_svcflag
else
	echo 0 > $boldbeast_svcflag
fi
chmod 0644 $boldbeast_svcflag

rm $boldbeast_logfolder/BBBootLog_main.txt   2>/dev/null
rm $boldbeast_logfolder/BBBootLog_system.txt 2>/dev/null
rm $boldbeast_logfolder/BBBootLog_crash.txt  2>/dev/null
rm $boldbeast_logfolder/BBBootLog_events.txt 2>/dev/null
rm $boldbeast_logfolder/BBBootLog_radio.txt  2>/dev/null

logcat -bmain   -vtime -d -f$boldbeast_logfolder/BBBootLog_main.txt
logcat -bsystem -vtime -d -f$boldbeast_logfolder/BBBootLog_system.txt
logcat -bcrash  -vtime -d -f$boldbeast_logfolder/BBBootLog_crash.txt
logcat -bevents -vtime -d -f$boldbeast_logfolder/BBBootLog_events.txt
logcat -bradio  -vtime -d -f$boldbeast_logfolder/BBBootLog_radio.txt

chmod 0644 $boldbeast_logfolder/BBBootLog_main.txt
chmod 0644 $boldbeast_logfolder/BBBootLog_system.txt
chmod 0644 $boldbeast_logfolder/BBBootLog_crash.txt
chmod 0644 $boldbeast_logfolder/BBBootLog_events.txt
chmod 0644 $boldbeast_logfolder/BBBootLog_radio.txt
