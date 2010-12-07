From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 07 Dec 2010 11:45:17 -0800
Message-ID: <201012071946.oB7Jkq8j004533@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44649 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753676Ab0LGTqy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Dec 2010 14:46:54 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id oB7Jkr3I013040
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 7 Dec 2010 11:46:53 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/regulator/core.c |   17 -----------------
 1 file changed, 17 deletions(-)

diff -puN drivers/regulator/core.c~linux-next-git-rejects drivers/regulator/core.c
--- a/drivers/regulator/core.c~linux-next-git-rejects
+++ a/drivers/regulator/core.c
@@ -1039,14 +1039,8 @@ static struct regulator *create_regulato
 		err = sysfs_create_link(&rdev->dev.kobj, &dev->kobj,
 					buf);
 		if (err) {
-<<<<<<< HEAD
-			printk(KERN_WARNING
-			       "%s: could not add device link %s err %d\n",
-			       __func__, dev->kobj.name, err);
-=======
 			rdev_warn(rdev, "could not add device link %s err %d\n",
 				  dev->kobj.name, err);
->>>>>>> FETCH_HEAD
 			goto link_name_err;
 		}
 	}
@@ -1269,12 +1263,7 @@ static int _regulator_enable(struct regu
 			ret = _regulator_enable(rdev->supply);
 			mutex_unlock(&rdev->supply->mutex);
 			if (ret < 0) {
-<<<<<<< HEAD
-				printk(KERN_ERR "%s: failed to enable %s: %d\n",
-				       __func__, rdev_get_name(rdev), ret);
-=======
 				rdev_err(rdev, "failed to enable: %d\n", ret);
->>>>>>> FETCH_HEAD
 				return ret;
 			}
 		}
@@ -1315,22 +1304,16 @@ static int _regulator_enable(struct regu
 			if (ret < 0)
 				return ret;
 
-<<<<<<< HEAD
-=======
 			trace_regulator_enable_delay(rdev_get_name(rdev));
 
->>>>>>> FETCH_HEAD
 			if (delay >= 1000) {
 				mdelay(delay / 1000);
 				udelay(delay % 1000);
 			} else if (delay) {
 				udelay(delay);
 			}
-<<<<<<< HEAD
-=======
 
 			trace_regulator_enable_complete(rdev_get_name(rdev));
->>>>>>> FETCH_HEAD
 
 		} else if (ret < 0) {
 			rdev_err(rdev, "is_enabled() failed: %d\n", ret);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
aesni-nfg.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmap-area-cache.patch
arch-x86-kernel-apic-io_apicc-fix-warning.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
irq-use-per_cpu-kstat_irqs-checkpatch-fixes.patch
headers_check-better-search-for-functions-in-headers-fix.patch
headers_check-better-search-for-functions-in-headers-fix-checkpatch-fixes.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code-checkpatch-fixes.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-deactivate-invalidated-pages-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix.patch
fs-select-fix-information-leak-to-userspace-fix.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

