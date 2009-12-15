From: akpm@linux-foundation.org
Subject: [folded] cs5535-add-a-generic-clock-event-mfgpt-driver-fix.patch removed from -mm tree
Date: Mon, 14 Dec 2009 17:10:04 -0800
Message-ID: <200912150110.nBF1A4Bx019094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758533AbZLOBKM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 20:10:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dilinger@collabora.co.uk, jordan@cosmicpenguin.net, mm-commits@vger.kernel.org


The patch titled
     cs5535-add-a-generic-clock-event-mfgpt-driver-fix
has been removed from the -mm tree.  Its filename was
     cs5535-add-a-generic-clock-event-mfgpt-driver-fix.patch

This patch was dropped because it was folded into cs5535-add-a-generic-clock-event-mfgpt-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cs5535-add-a-generic-clock-event-mfgpt-driver-fix
From: Andrew Morton <akpm@linux-foundation.org>

sparc64 allmodconfig:

drivers/clocksource/cs5535-clockevt.c: In function `cs5535_mfgpt_init':
drivers/clocksource/cs5535-clockevt.c:160: error: implicit declaration of function `setup_irq'

Cc: Andres Salomon <dilinger@collabora.co.uk>
Cc: Jordan Crouse <jordan@cosmicpenguin.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clocksource/cs5535-clockevt.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/clocksource/cs5535-clockevt.c~cs5535-add-a-generic-clock-event-mfgpt-driver-fix drivers/clocksource/cs5535-clockevt.c
--- a/drivers/clocksource/cs5535-clockevt.c~cs5535-add-a-generic-clock-event-mfgpt-driver-fix
+++ a/drivers/clocksource/cs5535-clockevt.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/cs5535.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-memory_hotplug-make-offline_pages-static.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore.patch
mm-hugetlb-add-hugepage-support-to-pagemap.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments.patch
rwsem-fix-rwsem_is_locked-bugs.patch
kernelh-add-printk_ratelimited-and-pr_level_rl.patch
errh-add-helper-function-to-simplify-pointer-error-checking.patch
cs5535-add-a-generic-mfgpt-driver.patch
cs5535-add-a-generic-clock-event-mfgpt-driver.patch
cs5535-add-a-generic-clock-event-mfgpt-driver-fix.patch
drivers-scsi-sym53c8xx_2-sym_gluec-rename-skip_spaces-to-sym_skip_spaces.patch
lib-introduce-strim-checkpatch-fixes.patch
blackfin-sd-host-controller-driver-fix.patch
blackfin-sd-host-controller-driver-fix-fix.patch
blackfin-sd-host-controller-driver-fix-fix-fix.patch
crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
lis3-update-documentation-to-match-latest-changes-fix.patch

