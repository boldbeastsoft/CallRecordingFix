if [ $API -lt 21 ]; then
	ui_print "Android 4.4 and older versions are not supported."
	touch $MODPATH/remove
else
	set_perm  "$MODPATH/bin/armeabi-v7a/fileop"  0  0  0755  "u:object_r:system_file:s0"
	set_perm  "$MODPATH/bin/arm64-v8a/fileop"    0  0  0755  "u:object_r:system_file:s0"
fi
