From: akpm@linux-foundation.org
Subject: + maintainers-change-web-links-from-wiki-analog-to-wikianalog.patch added to -mm tree
Date: Thu, 24 Feb 2011 14:33:41 -0800
Message-ID: <201102242233.p1OMXfN0030714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754445Ab1BXWdp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Feb 2011 17:33:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, vapier.adi@gmail.com


The patch titled
     MAINTAINERS: change web links from wiki-analog to wiki.analog
has been added to the -mm tree.  Its filename is
     maintainers-change-web-links-from-wiki-analog-to-wikianalog.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: change web links from wiki-analog to wiki.analog
From: Joe Perches <joe@perches.com>

wiki-analog doesn't seem to work, but wiki.analog does.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN MAINTAINERS~maintainers-change-web-links-from-wiki-analog-to-wikianalog MAINTAINERS
--- a/MAINTAINERS~maintainers-change-web-links-from-wiki-analog-to-wikianalog
+++ a/MAINTAINERS
@@ -288,35 +288,35 @@ F:	sound/pci/ad1889.*
 AD525X ANALOG DEVICES DIGITAL POTENTIOMETERS DRIVER
 M:	Michael Hennerich <michael.hennerich@analog.com>
 L:	device-driver-devel@blackfin.uclinux.org
-W:	http://wiki-analog.com/AD5254
+W:	http://wiki.analog.com/AD5254
 S:	Supported
 F:	drivers/misc/ad525x_dpot.c
 
 AD5398 CURRENT REGULATOR DRIVER (AD5398/AD5821)
 M:	Michael Hennerich <michael.hennerich@analog.com>
 L:	device-driver-devel@blackfin.uclinux.org
-W:	http://wiki-analog.com/AD5398
+W:	http://wiki.analog.com/AD5398
 S:	Supported
 F:	drivers/regulator/ad5398.c
 
 AD714X CAPACITANCE TOUCH SENSOR DRIVER (AD7142/3/7/8/7A)
 M:	Michael Hennerich <michael.hennerich@analog.com>
 L:	device-driver-devel@blackfin.uclinux.org
-W:	http://wiki-analog.com/AD7142
+W:	http://wiki.analog.com/AD7142
 S:	Supported
 F:	drivers/input/misc/ad714x.c
 
 AD7877 TOUCHSCREEN DRIVER
 M:	Michael Hennerich <michael.hennerich@analog.com>
 L:	device-driver-devel@blackfin.uclinux.org
-W:	http://wiki-analog.com/AD7877
+W:	http://wiki.analog.com/AD7877
 S:	Supported
 F:	drivers/input/touchscreen/ad7877.c
 
 AD7879 TOUCHSCREEN DRIVER (AD7879/AD7889)
 M:	Michael Hennerich <michael.hennerich@analog.com>
 L:	device-driver-devel@blackfin.uclinux.org
-W:	http://wiki-analog.com/AD7879
+W:	http://wiki.analog.com/AD7879
 S:	Supported
 F:	drivers/input/touchscreen/ad7879.c
 
@@ -342,7 +342,7 @@ F:	drivers/net/wireless/adm8211.*
 ADP5520 BACKLIGHT DRIVER WITH IO EXPANDER (ADP5520/ADP5501)
 M:	Michael Hennerich <michael.hennerich@analog.com>
 L:	device-driver-devel@blackfin.uclinux.org
-W:	http://wiki-analog.com/ADP5520
+W:	http://wiki.analog.com/ADP5520
 S:	Supported
 F:	drivers/mfd/adp5520.c
 F:	drivers/video/backlight/adp5520_bl.c
@@ -353,7 +353,7 @@ F:	drivers/input/keyboard/adp5520-keys.c
 ADP5588 QWERTY KEYPAD AND IO EXPANDER DRIVER (ADP5588/ADP5587)
 M:	Michael Hennerich <michael.hennerich@analog.com>
 L:	device-driver-devel@blackfin.uclinux.org
-W:	http://wiki-analog.com/ADP5588
+W:	http://wiki.analog.com/ADP5588
 S:	Supported
 F:	drivers/input/keyboard/adp5588-keys.c
 F:	drivers/gpio/adp5588-gpio.c
@@ -361,7 +361,7 @@ F:	drivers/gpio/adp5588-gpio.c
 ADP8860 BACKLIGHT DRIVER (ADP8860/ADP8861/ADP8863)
 M:	Michael Hennerich <michael.hennerich@analog.com>
 L:	device-driver-devel@blackfin.uclinux.org
-W:	http://wiki-analog.com/ADP8860
+W:	http://wiki.analog.com/ADP8860
 S:	Supported
 F:	drivers/video/backlight/adp8860_bl.c
 
@@ -380,7 +380,7 @@ F:	drivers/hwmon/adt7475.c
 ADXL34X THREE-AXIS DIGITAL ACCELEROMETER DRIVER (ADXL345/ADXL346)
 M:	Michael Hennerich <michael.hennerich@analog.com>
 L:	device-driver-devel@blackfin.uclinux.org
-W:	http://wiki-analog.com/ADXL345
+W:	http://wiki.analog.com/ADXL345
 S:	Supported
 F:	drivers/input/misc/adxl34x.c
 
@@ -520,7 +520,7 @@ F:	drivers/infiniband/hw/amso1100/
 ANALOG DEVICES INC ASOC CODEC DRIVERS
 L:	device-driver-devel@blackfin.uclinux.org
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
-W:	http://wiki-analog.com/
+W:	http://wiki.analog.com/
 S:	Supported
 F:	sound/soc/codecs/ad1*
 F:	sound/soc/codecs/adau*
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-add-chinese-documentation-maintainer.patch
vsprintf-neaten-%pk-kptr_restrict-save-a-bit-of-code-space.patch
printk-allow-setting-default_message_level-via-kconfig.patch
get_maintainerpl-allow-k-pattern-tests-to-match-non-patch-text.patch
maintainers-quote-non-alphanumeric-email-addresses.patch
maintainers-update-adp5520-pattern.patch
maintainers-change-web-links-from-wiki-analog-to-wikianalog.patch
maintainers-remove-asoc-codec-drivers-files-not-in-tree.patch
maintainers-add-missing-after-hr-timers-f-tag.patch
maintainers-remove-unnecessary-linux-kernel-vgerkernelorg-entries.patch
maintainers-update-clkdev-location.patch
maintainers-update-media-path.patch
maintainers-update-hvc-file-patterns.patch
maintainers-remove-unused-clockeventsh.patch
maintainers-remove-ieee1394-entry.patch
maintainers-remove-unused-timekeeping-timekeepingh.patch
maintainers-update-scx200-file-pattern.patch
maintainers-remove-sharp-lh7a40x-section.patch
maintainers-update-sfi-pattern.patch
maintainers-update-tipc-patterns.patch
maintainers-usb-se401-moved-to-staging-update-pattern.patch
maintainers-update-winbond-cir-pattern.patch

