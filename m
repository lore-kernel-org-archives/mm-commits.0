From: akpm@linux-foundation.org
Subject: + i2c-pasemi-fix-Kconfig-dependencies.patch added to -mm tree
Date: Tue, 17 Apr 2007 00:31:48 -0700
Message-ID: <200704170731.l3H7VmwY023339@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39461 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbXDQHcE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Apr 2007 03:32:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, olof@lixom.net


The patch titled
     i2c-pasemi: Depend on PPC_PASEMI again
has been added to the -mm tree.  Its filename is
     i2c-pasemi-fix-Kconfig-dependencies.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i2c-pasemi: Depend on PPC_PASEMI again
From: Jean Delvare <khali@linux-fr.org>

Looks like a local change I made to be able to test-compile the i2c-pasemi
driver leaked upstream.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/i2c/busses/Kconfig~i2c-pasemi-fix-Kconfig-dependencies drivers/i2c/busses/Kconfig
--- a/drivers/i2c/busses/Kconfig~i2c-pasemi-fix-Kconfig-dependencies
+++ a/drivers/i2c/busses/Kconfig
@@ -344,8 +344,7 @@ config I2C_PARPORT_LIGHT
 
 config I2C_PASEMI
 	tristate "PA Semi SMBus interface"
-#	depends on PPC_PASEMI && I2C && PCI
-	depends on I2C && PCI
+	depends on PPC_PASEMI && I2C && PCI
 	help
 	  Supports the PA Semi PWRficient on-chip SMBus interfaces.
 
_

Patches currently in -mm which might be from khali@linux-fr.org are

hwmon-w83627ehf-fix-fan5-div-selection.patch
i2c-pasemi-fix-Kconfig-dependencies.patch
i2c-pasemi-fixes.patch
x86-msr-add-support-for-safe-variants.patch
git-alsa.patch
git-dvb.patch
apple-smc-driver-hardware-monitoring-and-control.patch
apple-smc-driver-hardware-monitoring-and-control-fix.patch
apple-smc-driver-standardize-and-sanitize-sysfs-tree.patch
apple-smc-driver-implement-key-enumeration.patch
ams-driver-do-not-print-error-on-systems-without-apple-motion-sensor.patch
git-ieee1394.patch
git-netdev-all.patch
git-net.patch
xtensa-strlcpy-is-smart-enough.patch
oss-strlcpy-is-smart-enough.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
legacy-pc-parports-support-parport-dev.patch
layered-parport-code-uses-parport-dev.patch
fbdev-dont-show-logo-if-driver-or-fbcon-are-modular.patch
rivafb-handle-i2c-bus-creation-failure.patch
rivafb-nvidiafb-various-cleanups.patch
rivafb-fixed-reversed-ddc-ports.patch
