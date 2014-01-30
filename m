From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-adi-linux-development-mailing-lists-change-to-the-new-server.patch removed from -mm tree
Date: Thu, 30 Jan 2014 12:05:28 -0800
Message-ID: <52eab088.IEdDGaf+dxNzRZ4r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42409 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbaA3UF3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Jan 2014 15:05:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vapier@gentoo.org, realmz6@gmail.com, michael.hennerich@analog.com, lars@metafoo.de, sonic.zhang@analog.com

Subject: [merged] maintainers-adi-linux-development-mailing-lists-change-to-the-new-server.patch removed from -mm tree
To: sonic.zhang@analog.com,lars@metafoo.de,michael.hennerich@analog.com,realmz6@gmail.com,vapier@gentoo.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 30 Jan 2014 12:05:28 -0800


The patch titled
     Subject: MAINTAINERS: ADI Linux development mailing lists: change to the new server
has been removed from the -mm tree.  Its filename was
     maintainers-adi-linux-development-mailing-lists-change-to-the-new-server.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sonic Zhang <sonic.zhang@analog.com>
Subject: MAINTAINERS: ADI Linux development mailing lists: change to the new server

Update Blackfin arch maintainer's email as well.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Steven Miao <realmz6@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff -puN MAINTAINERS~maintainers-adi-linux-development-mailing-lists-change-to-the-new-server MAINTAINERS
--- a/MAINTAINERS~maintainers-adi-linux-development-mailing-lists-change-to-the-new-server
+++ a/MAINTAINERS
@@ -309,36 +309,36 @@ F:	sound/pci/ad1889.*
 
 AD525X ANALOG DEVICES DIGITAL POTENTIOMETERS DRIVER
 M:	Michael Hennerich <michael.hennerich@analog.com>
-L:	device-drivers-devel@blackfin.uclinux.org
 W:	http://wiki.analog.com/AD5254
+W:	http://ez.analog.com/community/linux-device-drivers
 S:	Supported
 F:	drivers/misc/ad525x_dpot.c
 
 AD5398 CURRENT REGULATOR DRIVER (AD5398/AD5821)
 M:	Michael Hennerich <michael.hennerich@analog.com>
-L:	device-drivers-devel@blackfin.uclinux.org
 W:	http://wiki.analog.com/AD5398
+W:	http://ez.analog.com/community/linux-device-drivers
 S:	Supported
 F:	drivers/regulator/ad5398.c
 
 AD714X CAPACITANCE TOUCH SENSOR DRIVER (AD7142/3/7/8/7A)
 M:	Michael Hennerich <michael.hennerich@analog.com>
-L:	device-drivers-devel@blackfin.uclinux.org
 W:	http://wiki.analog.com/AD7142
+W:	http://ez.analog.com/community/linux-device-drivers
 S:	Supported
 F:	drivers/input/misc/ad714x.c
 
 AD7877 TOUCHSCREEN DRIVER
 M:	Michael Hennerich <michael.hennerich@analog.com>
-L:	device-drivers-devel@blackfin.uclinux.org
 W:	http://wiki.analog.com/AD7877
+W:	http://ez.analog.com/community/linux-device-drivers
 S:	Supported
 F:	drivers/input/touchscreen/ad7877.c
 
 AD7879 TOUCHSCREEN DRIVER (AD7879/AD7889)
 M:	Michael Hennerich <michael.hennerich@analog.com>
-L:	device-drivers-devel@blackfin.uclinux.org
 W:	http://wiki.analog.com/AD7879
+W:	http://ez.analog.com/community/linux-device-drivers
 S:	Supported
 F:	drivers/input/touchscreen/ad7879.c
 
@@ -374,8 +374,8 @@ F:	include/media/adp1653.h
 
 ADP5520 BACKLIGHT DRIVER WITH IO EXPANDER (ADP5520/ADP5501)
 M:	Michael Hennerich <michael.hennerich@analog.com>
-L:	device-drivers-devel@blackfin.uclinux.org
 W:	http://wiki.analog.com/ADP5520
+W:	http://ez.analog.com/community/linux-device-drivers
 S:	Supported
 F:	drivers/mfd/adp5520.c
 F:	drivers/video/backlight/adp5520_bl.c
@@ -385,16 +385,16 @@ F:	drivers/input/keyboard/adp5520-keys.c
 
 ADP5588 QWERTY KEYPAD AND IO EXPANDER DRIVER (ADP5588/ADP5587)
 M:	Michael Hennerich <michael.hennerich@analog.com>
-L:	device-drivers-devel@blackfin.uclinux.org
 W:	http://wiki.analog.com/ADP5588
+W:	http://ez.analog.com/community/linux-device-drivers
 S:	Supported
 F:	drivers/input/keyboard/adp5588-keys.c
 F:	drivers/gpio/gpio-adp5588.c
 
 ADP8860 BACKLIGHT DRIVER (ADP8860/ADP8861/ADP8863)
 M:	Michael Hennerich <michael.hennerich@analog.com>
-L:	device-drivers-devel@blackfin.uclinux.org
 W:	http://wiki.analog.com/ADP8860
+W:	http://ez.analog.com/community/linux-device-drivers
 S:	Supported
 F:	drivers/video/backlight/adp8860_bl.c
 
@@ -420,8 +420,8 @@ F:	drivers/hwmon/adt7475.c
 
 ADXL34X THREE-AXIS DIGITAL ACCELEROMETER DRIVER (ADXL345/ADXL346)
 M:	Michael Hennerich <michael.hennerich@analog.com>
-L:	device-drivers-devel@blackfin.uclinux.org
 W:	http://wiki.analog.com/ADXL345
+W:	http://ez.analog.com/community/linux-device-drivers
 S:	Supported
 F:	drivers/input/misc/adxl34x.c
 
@@ -627,9 +627,9 @@ F:	drivers/media/i2c/adv7842*
 
 ANALOG DEVICES INC ASOC CODEC DRIVERS
 M:	Lars-Peter Clausen <lars@metafoo.de>
-L:	device-drivers-devel@blackfin.uclinux.org
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 W:	http://wiki.analog.com/
+W:	http://ez.analog.com/community/linux-device-drivers
 S:	Supported
 F:	sound/soc/codecs/adau*
 F:	sound/soc/codecs/adav*
@@ -639,7 +639,7 @@ F:	sound/soc/codecs/ssm*
 F:	sound/soc/codecs/sigmadsp.*
 
 ANALOG DEVICES INC ASOC DRIVERS
-L:	uclinux-dist-devel@blackfin.uclinux.org
+L:	adi-buildroot-devel@lists.sourceforge.net
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 W:	http://blackfin.uclinux.org/
 S:	Supported
@@ -1742,56 +1742,54 @@ F:	fs/bfs/
 F:	include/uapi/linux/bfs_fs.h
 
 BLACKFIN ARCHITECTURE
-M:	Mike Frysinger <vapier@gentoo.org>
-L:	uclinux-dist-devel@blackfin.uclinux.org
+M:	Steven Miao <realmz6@gmail.com>
+L:	adi-buildroot-devel@lists.sourceforge.net
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	arch/blackfin/
 
 BLACKFIN EMAC DRIVER
-L:	uclinux-dist-devel@blackfin.uclinux.org
+L:	adi-buildroot-devel@lists.sourceforge.net
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	drivers/net/ethernet/adi/
 
 BLACKFIN RTC DRIVER
-M:	Mike Frysinger <vapier.adi@gmail.com>
-L:	uclinux-dist-devel@blackfin.uclinux.org
+L:	adi-buildroot-devel@lists.sourceforge.net
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	drivers/rtc/rtc-bfin.c
 
 BLACKFIN SDH DRIVER
 M:	Sonic Zhang <sonic.zhang@analog.com>
-L:	uclinux-dist-devel@blackfin.uclinux.org
+L:	adi-buildroot-devel@lists.sourceforge.net
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	drivers/mmc/host/bfin_sdh.c
 
 BLACKFIN SERIAL DRIVER
 M:	Sonic Zhang <sonic.zhang@analog.com>
-L:	uclinux-dist-devel@blackfin.uclinux.org
+L:	adi-buildroot-devel@lists.sourceforge.net
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	drivers/tty/serial/bfin_uart.c
 
 BLACKFIN WATCHDOG DRIVER
-M:	Mike Frysinger <vapier.adi@gmail.com>
-L:	uclinux-dist-devel@blackfin.uclinux.org
+L:	adi-buildroot-devel@lists.sourceforge.net
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	drivers/watchdog/bfin_wdt.c
 
 BLACKFIN I2C TWI DRIVER
 M:	Sonic Zhang <sonic.zhang@analog.com>
-L:	uclinux-dist-devel@blackfin.uclinux.org
+L:	adi-buildroot-devel@lists.sourceforge.net
 W:	http://blackfin.uclinux.org/
 S:	Supported
 F:	drivers/i2c/busses/i2c-bfin-twi.c
 
 BLACKFIN MEDIA DRIVER
 M:	Scott Jiang <scott.jiang.linux@gmail.com>
-L:	uclinux-dist-devel@blackfin.uclinux.org
+L:	adi-buildroot-devel@lists.sourceforge.net
 W:	http://blackfin.uclinux.org/
 S:	Supported
 F:	drivers/media/platform/blackfin/
_

Patches currently in -mm which might be from sonic.zhang@analog.com are

origin.patch
linux-next.patch

