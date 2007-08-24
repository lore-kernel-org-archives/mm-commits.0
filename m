From: akpm@linux-foundation.org
Subject: - rtc-max6902-minor-fixes.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:57:01 -0700
Message-ID: <200708242057.l7OKv1DI014122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53577 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760518AbXHXVIt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, anemo@mba.ocn.ne.jp, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     rtc-max6902 minor fixes
has been removed from the -mm tree.  Its filename was
     rtc-max6902-minor-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc-max6902 minor fixes
From: David Brownell <david-b@pacbell.net>

Minor tweaks to rtc-max6902: make it hotplug correctly, and fix a few
space-before-tab whitespace botches.  This driver has no current in-tree
users, so the hotplug fix changes the driver name.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max6902.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-max6902.c~rtc-max6902-minor-fixes drivers/rtc/rtc-max6902.c
--- a/drivers/rtc/rtc-max6902.c~rtc-max6902-minor-fixes
+++ a/drivers/rtc/rtc-max6902.c
@@ -13,7 +13,7 @@
  *
  * 24-May-2006: Raphael Assenat <raph@8d.com>
  *                - Major rework
- *   				Converted to rtc_device and uses the SPI layer.
+ *				Converted to rtc_device and uses the SPI layer.
  *
  * ??-???-2005: Someone at Compulab
  *                - Initial driver creation.
@@ -259,11 +259,11 @@ static int __devexit max6902_remove(stru
 
 static struct spi_driver max6902_driver = {
 	.driver = {
-		.name 	= "max6902",
+		.name	= "rtc-max6902",
 		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 	},
-	.probe 	= max6902_probe,
+	.probe	= max6902_probe,
 	.remove = __devexit_p(max6902_remove),
 };
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
spi-driver-hotplug-coldplug-fixes.patch
fix-typo-in-atmel_spic.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-gpio-led-driver-for-the-wgt634u-machine.patch
git-mmc.patch
git-mtd.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91.patch
clean-up-duplicate-includes-in-drivers-spi.patch
spi-driver-runtime-footprint-shrinkage.patch
rtc-periodic-irq-fix.patch
rtc_irq_set_freq-requires-power-of-two-and-associated-kerneldoc.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
