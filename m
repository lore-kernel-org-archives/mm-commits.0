From: akpm@linux-foundation.org
Subject: + maintainers-switch-to-susecom-many-in-one.patch added to -mm
 tree
Date: Mon, 06 Jul 2015 16:39:07 -0700
Message-ID: <559b119b.YJQ3QjSh3dOQKLdJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34465 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbbGFXjI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 19:39:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.com, agraf@suse.de, dsterba@suse.com, hare@suse.com, jack@suse.com, jdelvare@suse.com, jkosina@suse.com, mmarek@suse.com, neilb@suse.com, oneukum@suse.de, sleep_walker@suse.com, tiwai@suse.com, trenn@suse.de, vojtech@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: switch to suse.com many-in-one (fwd)
has been added to the -mm tree.  Its filename is
     maintainers-switch-to-susecom-many-in-one.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-switch-to-susecom-many-in-one.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-switch-to-susecom-many-in-one.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jiri Slaby <jslaby@suse.com>
Subject: MAINTAINERS: switch to suse.com many-in-one (fwd)

Since suse.{de,cz} is deprecated to use (but will still work for some
time), switch to suse.com which is now to be used instead.

Signed-off-by: Jiri Slaby <jslaby@suse.com>
Acked-by: Alexander Graf <agraf@suse.de>
Acked-by: David Sterba <dsterba@suse.com>
Acked-by: Hannes Reinecke <hare@suse.com>
Acked-by: Jan Kara <jack@suse.com>
Acked-by: Jean Delvare <jdelvare@suse.com>
Acked-by: Jiri Kosina <jkosina@suse.com>
Acked-by: Michal Marek <mmarek@suse.com>
Acked-by: NeilBrown <neilb@suse.com>
Acked-by: Oliver Neukum <oneukum@suse.de>
Acked-by: Takashi Iwai <tiwai@suse.com>
Acked-by: Thomas Renninger <trenn@suse.de>
Acked-by: Tomas Cech <sleep_walker@suse.com>
Acked-by: Vojtech Pavlik <vojtech@suse.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   92 +++++++++++++++++++++++++-------------------------
 1 file changed, 46 insertions(+), 46 deletions(-)

diff -puN MAINTAINERS~maintainers-switch-to-susecom-many-in-one MAINTAINERS
--- a/MAINTAINERS~maintainers-switch-to-susecom-many-in-one
+++ a/MAINTAINERS
@@ -361,11 +361,11 @@ S:	Supported
 F:	drivers/input/touchscreen/ad7879.c
 
 ADDRESS SPACE LAYOUT RANDOMIZATION (ASLR)
-M:	Jiri Kosina <jkosina@suse.cz>
+M:	Jiri Kosina <jkosina@suse.com>
 S:	Maintained
 
 ADM1025 HARDWARE MONITOR DRIVER
-M:	Jean Delvare <jdelvare@suse.de>
+M:	Jean Delvare <jdelvare@suse.com>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/adm1025
@@ -430,7 +430,7 @@ S:	Maintained
 F:	drivers/macintosh/therm_adt746x.c
 
 ADT7475 HARDWARE MONITOR DRIVER
-M:	Jean Delvare <jdelvare@suse.de>
+M:	Jean Delvare <jdelvare@suse.com>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/adt7475
@@ -445,7 +445,7 @@ F:	drivers/input/misc/adxl34x.c
 
 ADVANSYS SCSI DRIVER
 M:	Matthew Wilcox <matthew@wil.cx>
-M:	Hannes Reinecke <hare@suse.de>
+M:	Hannes Reinecke <hare@suse.com>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	Documentation/scsi/advansys.txt
@@ -506,7 +506,7 @@ F:	drivers/scsi/aha152x*
 F:	drivers/scsi/pcmcia/aha152x*
 
 AIC7XXX / AIC79XX SCSI DRIVER
-M:	Hannes Reinecke <hare@suse.de>
+M:	Hannes Reinecke <hare@suse.com>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/aic7xxx/
@@ -746,7 +746,7 @@ S:	Maintained
 F:	sound/aoa/
 
 APM DRIVER
-M:	Jiri Kosina <jkosina@suse.cz>
+M:	Jiri Kosina <jkosina@suse.com>
 S:	Odd fixes
 F:	arch/x86/kernel/apm_32.c
 F:	include/linux/apm_bios.h
@@ -1324,7 +1324,7 @@ F:	arch/arm/mach-pxa/include/mach/palmtc
 F:	arch/arm/mach-pxa/palmtc.c
 
 ARM/PALM TREO SUPPORT
-M:	Tomas Cech <sleep_walker@suse.cz>
+M:	Tomas Cech <sleep_walker@suse.com>
 L:	linux-arm-kernel@lists.infradead.org
 W:	http://hackndev.com
 S:	Maintained
@@ -2404,7 +2404,7 @@ F:	drivers/gpio/gpio-bt8xx.c
 BTRFS FILE SYSTEM
 M:	Chris Mason <clm@fb.com>
 M:	Josef Bacik <jbacik@fb.com>
-M:	David Sterba <dsterba@suse.cz>
+M:	David Sterba <dsterba@suse.com>
 L:	linux-btrfs@vger.kernel.org
 W:	http://btrfs.wiki.kernel.org/
 Q:	http://patchwork.kernel.org/project/linux-btrfs/list/
@@ -2735,7 +2735,7 @@ COCCINELLE/Semantic Patches (SmPL)
 M:	Julia Lawall <Julia.Lawall@lip6.fr>
 M:	Gilles Muller <Gilles.Muller@lip6.fr>
 M:	Nicolas Palix <nicolas.palix@imag.fr>
-M:	Michal Marek <mmarek@suse.cz>
+M:	Michal Marek <mmarek@suse.com>
 L:	cocci@systeme.lip6.fr (moderated for non-subscribers)
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git misc
 W:	http://coccinelle.lip6.fr/
@@ -2932,7 +2932,7 @@ F:	arch/x86/kernel/cpuid.c
 F:	arch/x86/kernel/msr.c
 
 CPU POWER MONITORING SUBSYSTEM
-M:	Thomas Renninger <trenn@suse.de>
+M:	Thomas Renninger <trenn@suse.com>
 L:	linux-pm@vger.kernel.org
 S:	Maintained
 F:	tools/power/cpupower/
@@ -3162,7 +3162,7 @@ F:	Documentation/networking/dmfe.txt
 F:	drivers/net/ethernet/dec/tulip/dmfe.c
 
 DC390/AM53C974 SCSI driver
-M:	Hannes Reinecke <hare@suse.de>
+M:	Hannes Reinecke <hare@suse.com>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/am53c974.c
@@ -3366,7 +3366,7 @@ W:	http://www.win.tue.nl/~aeb/partitions
 S:	Maintained
 
 DISKQUOTA
-M:	Jan Kara <jack@suse.cz>
+M:	Jan Kara <jack@suse.com>
 S:	Maintained
 F:	Documentation/filesystems/quota.txt
 F:	fs/quota/
@@ -3422,7 +3422,7 @@ F:	Documentation/hwmon/dme1737
 F:	drivers/hwmon/dme1737.c
 
 DMI/SMBIOS SUPPORT
-M:	Jean Delvare <jdelvare@suse.de>
+M:	Jean Delvare <jdelvare@suse.com>
 S:	Maintained
 T:	quilt http://jdelvare.nerim.net/devel/linux/jdelvare-dmi/
 F:	Documentation/ABI/testing/sysfs-firmware-dmi-tables
@@ -4038,7 +4038,7 @@ F:	drivers/of/of_mdio.c
 F:	drivers/of/of_net.c
 
 EXT2 FILE SYSTEM
-M:	Jan Kara <jack@suse.cz>
+M:	Jan Kara <jack@suse.com>
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
 F:	Documentation/filesystems/ext2.txt
@@ -4046,7 +4046,7 @@ F:	fs/ext2/
 F:	include/linux/ext2*
 
 EXT3 FILE SYSTEM
-M:	Jan Kara <jack@suse.cz>
+M:	Jan Kara <jack@suse.com>
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Andreas Dilger <adilger.kernel@dilger.ca>
 L:	linux-ext4@vger.kernel.org
@@ -4096,7 +4096,7 @@ F:	drivers/video/fbdev/exynos/exynos_mip
 F:	include/video/exynos_mipi*
 
 F71805F HARDWARE MONITORING DRIVER
-M:	Jean Delvare <jdelvare@suse.de>
+M:	Jean Delvare <jdelvare@suse.com>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/f71805f
@@ -4231,7 +4231,7 @@ S:	Maintained
 F:	drivers/block/rsxx/
 
 FLOPPY DRIVER
-M:	Jiri Kosina <jkosina@suse.cz>
+M:	Jiri Kosina <jkosina@suse.com>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/floppy.git
 S:	Odd fixes
 F:	drivers/block/floppy.c
@@ -4699,7 +4699,7 @@ S:	Maintained
 F:	drivers/media/usb/hackrf/
 
 HARDWARE MONITORING
-M:	Jean Delvare <jdelvare@suse.de>
+M:	Jean Delvare <jdelvare@suse.com>
 M:	Guenter Roeck <linux@roeck-us.net>
 L:	lm-sensors@lm-sensors.org
 W:	http://www.lm-sensors.org/
@@ -4802,7 +4802,7 @@ F:	include/linux/pm.h
 F:	arch/*/include/asm/suspend*.h
 
 HID CORE LAYER
-M:	Jiri Kosina <jkosina@suse.cz>
+M:	Jiri Kosina <jkosina@suse.com>
 L:	linux-input@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git
 S:	Maintained
@@ -4811,7 +4811,7 @@ F:	include/linux/hid*
 F:	include/uapi/linux/hid*
 
 HID SENSOR HUB DRIVERS
-M:	Jiri Kosina <jkosina@suse.cz>
+M:	Jiri Kosina <jkosina@suse.com>
 M:	Jonathan Cameron <jic23@kernel.org>
 M:	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
 L:	linux-input@vger.kernel.org
@@ -4945,7 +4945,7 @@ F:	include/linux/hyperv.h
 F:	tools/hv/
 
 I2C OVER PARALLEL PORT
-M:	Jean Delvare <jdelvare@suse.de>
+M:	Jean Delvare <jdelvare@suse.com>
 L:	linux-i2c@vger.kernel.org
 S:	Maintained
 F:	Documentation/i2c/busses/i2c-parport
@@ -4954,7 +4954,7 @@ F:	drivers/i2c/busses/i2c-parport.c
 F:	drivers/i2c/busses/i2c-parport-light.c
 
 I2C/SMBUS CONTROLLER DRIVERS FOR PC
-M:	Jean Delvare <jdelvare@suse.de>
+M:	Jean Delvare <jdelvare@suse.com>
 L:	linux-i2c@vger.kernel.org
 S:	Maintained
 F:	Documentation/i2c/busses/i2c-ali1535
@@ -4995,7 +4995,7 @@ F:	drivers/i2c/busses/i2c-ismt.c
 F:	Documentation/i2c/busses/i2c-ismt
 
 I2C/SMBUS STUB DRIVER
-M:	Jean Delvare <jdelvare@suse.de>
+M:	Jean Delvare <jdelvare@suse.com>
 L:	linux-i2c@vger.kernel.org
 S:	Maintained
 F:	drivers/i2c/i2c-stub.c
@@ -5022,7 +5022,7 @@ L:	linux-acpi@vger.kernel.org
 S:	Maintained
 
 I2C-TAOS-EVM DRIVER
-M:	Jean Delvare <jdelvare@suse.de>
+M:	Jean Delvare <jdelvare@suse.com>
 L:	linux-i2c@vger.kernel.org
 S:	Maintained
 F:	Documentation/i2c/busses/i2c-taos-evm
@@ -5551,8 +5551,8 @@ F:	include/uapi/linux/ip_vs.h
 F:	net/netfilter/ipvs/
 
 IPWIRELESS DRIVER
-M:	Jiri Kosina <jkosina@suse.cz>
-M:	David Sterba <dsterba@suse.cz>
+M:	Jiri Kosina <jkosina@suse.com>
+M:	David Sterba <dsterba@suse.com>
 S:	Odd Fixes
 F:	drivers/tty/ipwireless/
 
@@ -5672,7 +5672,7 @@ S:	Maintained
 F:	drivers/isdn/hardware/eicon/
 
 IT87 HARDWARE MONITORING DRIVER
-M:	Jean Delvare <jdelvare@suse.de>
+M:	Jean Delvare <jdelvare@suse.com>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/it87
@@ -5739,7 +5739,7 @@ F:	include/uapi/linux/jffs2.h
 
 JOURNALLING LAYER FOR BLOCK DEVICES (JBD)
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Jan Kara <jack@suse.cz>
+M:	Jan Kara <jack@suse.com>
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
 F:	fs/jbd/
@@ -5803,7 +5803,7 @@ S:	Maintained
 F:	fs/autofs4/
 
 KERNEL BUILD + files below scripts/ (unless maintained elsewhere)
-M:	Michal Marek <mmarek@suse.cz>
+M:	Michal Marek <mmarek@suse.com>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git for-next
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git rc-fixes
 L:	linux-kbuild@vger.kernel.org
@@ -5867,7 +5867,7 @@ F:	arch/x86/include/asm/svm.h
 F:	arch/x86/kvm/svm.c
 
 KERNEL VIRTUAL MACHINE (KVM) FOR POWERPC
-M:	Alexander Graf <agraf@suse.de>
+M:	Alexander Graf <agraf@suse.com>
 L:	kvm-ppc@vger.kernel.org
 W:	http://kvm.qumranet.com
 T:	git git://github.com/agraf/linux-2.6.git
@@ -6024,7 +6024,7 @@ F:	drivers/leds/
 F:	include/linux/leds.h
 
 LEGACY EEPROM DRIVER
-M:	Jean Delvare <jdelvare@suse.de>
+M:	Jean Delvare <jdelvare@suse.com>
 S:	Maintained
 F:	Documentation/misc-devices/eeprom
 F:	drivers/misc/eeprom/eeprom.c
@@ -6237,8 +6237,8 @@ F:	drivers/platform/x86/hp_accel.c
 LIVE PATCHING
 M:	Josh Poimboeuf <jpoimboe@redhat.com>
 M:	Seth Jennings <sjenning@redhat.com>
-M:	Jiri Kosina <jkosina@suse.cz>
-M:	Vojtech Pavlik <vojtech@suse.cz>
+M:	Jiri Kosina <jkosina@suse.com>
+M:	Vojtech Pavlik <vojtech@suse.com>
 S:	Maintained
 F:	kernel/livepatch/
 F:	include/linux/livepatch.h
@@ -6264,21 +6264,21 @@ S:	Maintained
 F:	drivers/hwmon/lm73.c
 
 LM78 HARDWARE MONITOR DRIVER
-M:	Jean Delvare <jdelvare@suse.de>
+M:	Jean Delvare <jdelvare@suse.com>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/lm78
 F:	drivers/hwmon/lm78.c
 
 LM83 HARDWARE MONITOR DRIVER
-M:	Jean Delvare <jdelvare@suse.de>
+M:	Jean Delvare <jdelvare@suse.com>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/lm83
 F:	drivers/hwmon/lm83.c
 
 LM90 HARDWARE MONITOR DRIVER
-M:	Jean Delvare <jdelvare@suse.de>
+M:	Jean Delvare <jdelvare@suse.com>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/lm90
@@ -7704,7 +7704,7 @@ S:	Maintained
 F:	drivers/char/pc8736x_gpio.c
 
 PC87427 HARDWARE MONITORING DRIVER
-M:	Jean Delvare <jdelvare@suse.de>
+M:	Jean Delvare <jdelvare@suse.com>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/pc87427
@@ -7989,7 +7989,7 @@ S:	Maintained
 F:	drivers/pinctrl/spear/
 
 PKTCDVD DRIVER
-M:	Jiri Kosina <jkosina@suse.cz>
+M:	Jiri Kosina <jkosina@suse.com>
 S:	Maintained
 F:	drivers/block/pktcdvd.c
 F:	include/linux/pktcdvd.h
@@ -9407,7 +9407,7 @@ F:	Documentation/hwmon/sch5627
 F:	drivers/hwmon/sch5627.c
 
 SMSC47B397 HARDWARE MONITOR DRIVER
-M:	Jean Delvare <jdelvare@suse.de>
+M:	Jean Delvare <jdelvare@suse.com>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/smsc47b397
@@ -9456,7 +9456,7 @@ S:	Supported
 F:	drivers/media/pci/solo6x10/
 
 SOFTWARE RAID (Multiple Disks) SUPPORT
-M:	Neil Brown <neilb@suse.de>
+M:	Neil Brown <neilb@suse.com>
 L:	linux-raid@vger.kernel.org
 S:	Supported
 F:	drivers/md/
@@ -9499,7 +9499,7 @@ F:	drivers/memstick/core/ms_block.*
 
 SOUND
 M:	Jaroslav Kysela <perex@perex.cz>
-M:	Takashi Iwai <tiwai@suse.de>
+M:	Takashi Iwai <tiwai@suse.com>
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 W:	http://www.alsa-project.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound.git
@@ -10382,7 +10382,7 @@ K:	^Subject:.*(?i)trivial
 
 TTY LAYER
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
-M:	Jiri Slaby <jslaby@suse.cz>
+M:	Jiri Slaby <jslaby@suse.com>
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
 F:	Documentation/serial/
@@ -10456,7 +10456,7 @@ F:	arch/m68k/*/*_no.*
 F:	arch/m68k/include/asm/*_no.*
 
 UDF FILESYSTEM
-M:	Jan Kara <jack@suse.cz>
+M:	Jan Kara <jack@suse.com>
 S:	Maintained
 F:	Documentation/filesystems/udf.txt
 F:	fs/udf/
@@ -10599,7 +10599,7 @@ F:	drivers/usb/gadget/
 F:	include/linux/usb/gadget*
 
 USB HID/HIDBP DRIVERS (USB KEYBOARDS, MICE, REMOTE CONTROLS, ...)
-M:	Jiri Kosina <jkosina@suse.cz>
+M:	Jiri Kosina <jkosina@suse.com>
 L:	linux-usb@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git
 S:	Maintained
@@ -10724,7 +10724,7 @@ S:	Maintained
 F:	drivers/usb/host/uhci*
 
 USB "USBNET" DRIVER FRAMEWORK
-M:	Oliver Neukum <oneukum@suse.de>
+M:	Oliver Neukum <oneukum@suse.com>
 L:	netdev@vger.kernel.org
 W:	http://www.linux-usb.org/usbnet
 S:	Maintained
@@ -11051,7 +11051,7 @@ F:	Documentation/hwmon/w83793
 F:	drivers/hwmon/w83793.c
 
 W83795 HARDWARE MONITORING DRIVER
-M:	Jean Delvare <jdelvare@suse.de>
+M:	Jean Delvare <jdelvare@suse.com>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	drivers/hwmon/w83795.c
_

Patches currently in -mm which might be from jslaby@suse.com are

maintainers-switch-to-susecom-many-in-one.patch

