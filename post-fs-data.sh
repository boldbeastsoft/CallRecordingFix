#!/system/bin/sh
# Please don't hardcode /magisk/modname/... ; instead, please use $MODDIR/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODDIR=${0%/*}

boldbeast_bakfolder=/data/local/BBBootBak
boldbeast_logfolder=/data/local/BBBootLog
boldbeast_logfile=$boldbeast_logfolder/BBBootLog_fileop.txt
boldbeast_pstflag=$MODDIR/bbpostfs.flg

mkdir -p $boldbeast_logfolder 2>/dev/null
chmod 0775 $boldbeast_logfolder
rm $boldbeast_logfile 2>/dev/null

if [ -f "/system/lib64/libvndksupport.so" ]; then
	boldbeast_bin=$MODDIR/bin/arm64-v8a/fileop
else
	boldbeast_bin=$MODDIR/bin/armeabi-v7a/fileop
fi
if [ -f "$boldbeast_bin" ]; then
	boldbeast_vercode=`grep versionCode $MODDIR/module.prop | cut -b 13-`
	$boldbeast_bin  "$boldbeast_vercode"  "$MODDIR/bin"  "$MODDIR"  "$boldbeast_bakfolder"  "$boldbeast_logfile"
	echo "$boldbeast_bin error = $?" > $boldbeast_pstflag
else
	echo "$boldbeast_bin doesn't exist." > $boldbeast_pstflag
fi
chmod 0644 $boldbeast_pstflag

echo "" >> $boldbeast_logfile
echo "" >> $boldbeast_logfile
ls -lR $MODDIR >> $boldbeast_logfile
chmod 0644 $boldbeast_logfile 2>/dev/null
