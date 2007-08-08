From: akpm@linux-foundation.org
Subject: - ssb-extif-timing-serial-port-initialization-fix.patch removed from -mm tree
Date: Wed, 08 Aug 2007 16:26:35 -0700
Message-ID: <200708082331.l78NVQtZ004056@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50485 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932266AbXHHXcu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Aug 2007 19:32:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mb@bu3sch.de, aurelien@aurel32.net, nbd@openwrt.org, mm-commits@vger.kernel.org


The patch titled
     ssb: Make extif driver compilation depend on extif config
has been removed from the -mm tree.  Its filename was
     ssb-extif-timing-serial-port-initialization-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: ssb: Make extif driver compilation depend on extif config
From: Michael Buesch <mb@bu3sch.de>

Compilation of the extif driver must depend on
CONFIG_SSB_DRIVER_EXTIF.
Sorry, my fault.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Felix Fietkau <nbd@openwrt.org>
Cc: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ssb/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/ssb/Makefile~ssb-extif-timing-serial-port-initialization-fix drivers/ssb/Makefile
--- a/drivers/ssb/Makefile~ssb-extif-timing-serial-port-initialization-fix
+++ a/drivers/ssb/Makefile
@@ -7,7 +7,8 @@ ssb-$(CONFIG_SSB_PCMCIAHOST)		+= pcmcia.
 
 # built-in drivers
 ssb-y					+= driver_chipcommon.o
-ssb-$(CONFIG_SSB_DRIVER_MIPS)		+= driver_mipscore.o driver_extif.o
+ssb-$(CONFIG_SSB_DRIVER_MIPS)		+= driver_mipscore.o
+ssb-$(CONFIG_SSB_DRIVER_EXTIF)		+= driver_extif.o
 ssb-$(CONFIG_SSB_DRIVER_PCICORE)	+= driver_pcicore.o
 
 obj-$(CONFIG_SSB)			+= ssb.o
_

Patches currently in -mm which might be from mb@bu3sch.de are

git-netdev-all.patch
git-wireless.patch
merge-the-sonics-silicon-backplane-subsystem.patch
merge-the-sonics-silicon-backplane-subsystem-fix.patch
avoid-ssb-compililation-on-s390.patch
b44-ssb-fix-irq-routing-bits-on-the-backplane.patch
merge-the-sonics-silicon-backplane-subsystem-update.patch
ssb-compile-fix.patch
watchdog-support-3.patch
ssb-chipcommon-add-function-to-get-processor-clock.patch
ssb-chipcommon-add-function-to-get-processor-clock-fix.patch
ssb-mainc-needs-dma-mappingh.patch
ssb-extif-timing-serial-port-initialization-fix.patch
use-ssb-extif-in-ssb-mips-core-driver.patch
use-ssb-extif-in-ssb-mips-core-driver-fix.patch
add-buswidth-to-ssb-mips-core-flash-driver.patch
ssb-add-a-driver-for-the-broadcom-ohci-core.patch
