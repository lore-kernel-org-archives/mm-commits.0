From: akpm@linux-foundation.org
Subject: - i2c-pasemi-fix-Kconfig-dependencies.patch removed from -mm tree
Date: Thu, 19 Apr 2007 13:02:13 -0700
Message-ID: <200704192002.l3JK2D1M029369@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766988AbXDSUCb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 16:02:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, olof@lixom.net, mm-commits@vger.kernel.org


The patch titled
     i2c-pasemi: Depend on PPC_PASEMI again
has been removed from the -mm tree.  Its filename was
     i2c-pasemi-fix-Kconfig-dependencies.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
x86-msr-add-support-for-safe-variants.patch
git-alsa.patch
git-dvb.patch
apple-smc-driver-hardware-monitoring-and-control.patch
apple-smc-driver-hardware-monitoring-and-control-fix.patch
apple-smc-driver-standardize-and-sanitize-sysfs-tree.patch
apple-smc-driver-implement-key-enumeration.patch
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
