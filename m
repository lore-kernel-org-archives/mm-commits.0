From: akpm@linux-foundation.org
Subject: + sam9-watchdog-update-for-moved-headers.patch added to -mm tree
Date: Wed, 05 Nov 2008 12:29:25 -0800
Message-ID: <200811052029.mA5KTPho006386@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752709AbYKEU3i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Nov 2008 15:29:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avictor.za@gmail.com, linux@maxim.org.za, wim@iguana.be


The patch titled
     SAM9 watchdog: update for moved headers
has been added to the -mm tree.  Its filename is
     sam9-watchdog-update-for-moved-headers.patch

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

sam9-watchdog-update-for-moved-headers.patch

