From: akpm@linux-foundation.org
Subject: - rtc-pcf8583-build-fix.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:50:02 -0700
Message-ID: <200804282150.m3SLo2pa017441@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934526AbYD1Vuf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:50:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, a.zummo@towertech.it, bunk@kernel.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     rtc-pcf8583 build fix
has been removed from the -mm tree.  Its filename was
     rtc-pcf8583-build-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-pcf8583 build fix
From: David Brownell <dbrownell@users.sourceforge.net>

Fix bogus #include in rtc-pcf8583, so it compiles on platforms that
don't support PC clone RTCs.  (Original issue noted by Adrian Bunk.)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Adrian Bunk <bunk@kernel.org>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8583.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-pcf8583.c~rtc-pcf8583-build-fix drivers/rtc/rtc-pcf8583.c
--- a/drivers/rtc/rtc-pcf8583.c~rtc-pcf8583-build-fix
+++ a/drivers/rtc/rtc-pcf8583.c
@@ -15,7 +15,7 @@
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/mc146818rtc.h>
+#include <linux/rtc.h>
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/bcd.h>
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
git-acpi.patch
usb-gadget-switch-to-put_char-returning-int.patch
mmc-use-get-put_unaligned_-helpers.patch
usb-use-get-put_unaligned_-helpers.patch

