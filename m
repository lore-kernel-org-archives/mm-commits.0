From: akpm@osdl.org
Subject: - rtc-at91rm9200-build-fix.patch removed from -mm tree
Date: Sat, 06 Jan 2007 23:58:20 -0800
Message-ID: <200701070758.l077wK36012948@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40769 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932445AbXAGH6r (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 02:58:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, alessandro.zummo@towertech.it, andrew@sanpeople.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     rtc-at91rm9200 build fix
has been removed from the -mm tree.  Its filename was
     rtc-at91rm9200-build-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc-at91rm9200 build fix
From: David Brownell <david-b@pacbell.net>

The at91rm9200 RTC driver needs some assistance to build, because of recent
header file rearrangement.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: Andrew Victor <andrew@sanpeople.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/rtc/rtc-at91rm9200.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/rtc/rtc-at91rm9200.c~rtc-at91rm9200-build-fix drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~rtc-at91rm9200-build-fix
+++ a/drivers/rtc/rtc-at91rm9200.c
@@ -33,6 +33,8 @@
 
 #include <asm/mach/time.h>
 
+#include <asm/arch/at91_rtc.h>
+
 
 #define AT91_RTC_FREQ		1
 #define AT91_RTC_EPOCH		1900UL	/* just like arch/arm/common/rtctime.c */
_

Patches currently in -mm which might be from david-b@pacbell.net are

git-dvb.patch
git-mmc.patch
8250-make-probing-for-txen-bug-a-config-option.patch
spi-kconfig-fix.patch
spi-controller-driver-for-omap-microwire.patch
spi-controller-driver-for-omap-microwire-update.patch
spi-controller-driver-for-omap-microwire-update-fix.patch
pnp-export-pnp_bus_type.patch
gpio-core.patch
omap-gpio-wrappers.patch
at91-gpio-wrappers.patch
