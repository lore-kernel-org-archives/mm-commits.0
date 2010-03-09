From: akpm@linux-foundation.org
Subject: [merged] i2c-fix-xiic-build-error.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:11:31 -0800
Message-ID: <201003091911.o29JBVCw031745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755966Ab0CITWP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     i2c: fix xiic build error
has been removed from the -mm tree.  Its filename was
     i2c-fix-xiic-build-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i2c: fix xiic build error
From: Randy Dunlap <randy.dunlap@oracle.com>

Add header file to fix build error:

drivers/i2c/busses/i2c-xiic.c:493: error: implicit declaration of function 'mdelay'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-xiic.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/i2c/busses/i2c-xiic.c~i2c-fix-xiic-build-error drivers/i2c/busses/i2c-xiic.c
--- a/drivers/i2c/busses/i2c-xiic.c~i2c-fix-xiic-build-error
+++ a/drivers/i2c/busses/i2c-xiic.c
@@ -31,6 +31,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/errno.h>
+#include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
xfs-needs-list_sort.patch
vmwgfx-depends-on-fb.patch
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
documentation-timers-split-txt-and-source-files.patch
documentation-laptop-split-txt-and-source-files.patch
documentation-fs-split-txt-and-source-files.patch
documentation-vm-split-txt-and-source-files.patch
doc-submitchecklist-add-rule-1.patch
cgroups-subsystem-module-unloading-fix.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
dma-mappingh-add-the-dma_unmap-state-api-fix-2.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

