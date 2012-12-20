From: akpm@linux-foundation.org
Subject: [folded-merged] sgi-xp-handle-non-fatal-traps-fix.patch removed from -mm tree
Date: Thu, 20 Dec 2012 14:25:10 -0800
Message-ID: <20121220222511.606F220004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f73.google.com ([74.125.82.73]:49214 "EHLO
	mail-wg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab2LTWZO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Dec 2012 17:25:14 -0500
Received: by mail-wg0-f73.google.com with SMTP id dt12so212093wgb.4
        for <mm-commits@vger.kernel.org>; Thu, 20 Dec 2012 14:25:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, holt@sgi.com, mingo@elte.hu, stable@vger.kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: sgi-xp-handle-non-fatal-traps-fix
has been removed from the -mm tree.  Its filename was
     sgi-xp-handle-non-fatal-traps-fix.patch

This patch was dropped because it was folded into sgi-xp-handle-non-fatal-traps.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sgi-xp-handle-non-fatal-traps-fix

Cc: <stable@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Robin Holt <holt@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc_main.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/misc/sgi-xp/xpc_main.c~sgi-xp-handle-non-fatal-traps-fix drivers/misc/sgi-xp/xpc_main.c
--- a/drivers/misc/sgi-xp/xpc_main.c~sgi-xp-handle-non-fatal-traps-fix
+++ a/drivers/misc/sgi-xp/xpc_main.c
@@ -53,7 +53,9 @@
 #include <linux/kthread.h>
 #include "xpc.h"
 
+#ifdef CONFIG_X86_64
 #include <asm/traps.h>
+#endif
 
 /* define two XPC debug device structures to be used with dev_dbg() et al */
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
compaction-fix-build-error-in-cma-compaction.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error.patch
revert-rtc-recycle-id-when-unloading-a-rtc-driver.patch
sgi-xp-handle-non-fatal-traps.patch
sendfile-allows-bypassing-of-notifier-events.patch

