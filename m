From: akpm@linux-foundation.org
Subject: - sam9-watchdog-update-for-moved-headers.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:33:01 -0800
Message-ID: <200811102033.mAAKX16a024268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51688 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754690AbYKJUdy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:33:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avictor.za@gmail.com, linux@maxim.org.za, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     SAM9 watchdog: update for moved headers
has been removed from the -mm tree.  Its filename was
     sam9-watchdog-update-for-moved-headers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: SAM9 watchdog: update for moved headers
From: "Andrew Victor" <avictor.za@gmail.com>

The architecture header files were recently moved from
include/asm-arm/mach-at91/ to arch/arm/mach-at91/include/mach/.  The SAM9
watchdog driver still includes a header from the old location.

Signed-off-by: Andrew Victor <linux@maxim.org.za>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/at91sam9_wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/watchdog/at91sam9_wdt.c~sam9-watchdog-update-for-moved-headers drivers/watchdog/at91sam9_wdt.c
--- a/drivers/watchdog/at91sam9_wdt.c~sam9-watchdog-update-for-moved-headers
+++ a/drivers/watchdog/at91sam9_wdt.c
@@ -30,7 +30,7 @@
 #include <linux/bitops.h>
 #include <linux/uaccess.h>
 
-#include <asm/arch/at91_wdt.h>
+#include <mach/at91_wdt.h>
 
 #define DRV_NAME "AT91SAM9 Watchdog"
 
_

Patches currently in -mm which might be from avictor.za@gmail.com are


