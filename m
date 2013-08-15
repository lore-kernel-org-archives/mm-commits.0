From: akpm@linux-foundation.org
Subject: [merged] drivers-staging-comedi-drivers-das16c-needs-slabh.patch
 removed from -mm tree
Date: Thu, 15 Aug 2013 13:20:44 -0700
Message-ID: <520d381c.PBaECeyV12GrM/YX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42195 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759719Ab3HOUUp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Aug 2013 16:20:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hsweeten@visionengravers.com, greg@kroah.com, abbotti@mev.co.uk, akpm@linux-foundation.org

Subject: [merged] drivers-staging-comedi-drivers-das16c-needs-slabh.patch removed from -mm tree
To: akpm@linux-foundation.org,abbotti@mev.co.uk,greg@kroah.com,hsweeten@visionengravers.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 15 Aug 2013 13:20:44 -0700


The patch titled
     Subject: drivers/staging/comedi/drivers/das16.c: needs slab.h
has been removed from the -mm tree.  Its filename was
     drivers-staging-comedi-drivers-das16c-needs-slabh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/staging/comedi/drivers/das16.c: needs slab.h

alpha allmodconfig:

drivers/staging/comedi/drivers/das16.c: In function 'das16_detach':
drivers/staging/comedi/drivers/das16.c:1234: error: implicit declaration of function 'kfree'                                                                    

Cc: Greg KH <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/comedi/drivers/das16.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/staging/comedi/drivers/das16.c~drivers-staging-comedi-drivers-das16c-needs-slabh drivers/staging/comedi/drivers/das16.c
--- a/drivers/staging/comedi/drivers/das16.c~drivers-staging-comedi-drivers-das16c-needs-slabh
+++ a/drivers/staging/comedi/drivers/das16.c
@@ -81,6 +81,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
 #include <linux/interrupt.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
block-support-embedded-device-command-line-partition.patch
mm.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-vmstats-track-tlb-flush-stats-on-up-too-fix.patch
swap-make-swap-discard-async-checkpatch-fixes.patch
swap-make-cluster-allocation-per-cpu-checkpatch-fixes.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch
mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch
vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix.patch
genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix.patch
mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages-fix.patch
mm-hotplug-verify-hotplug-memory-range-fix.patch
lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
linux-next.patch
revert-selinux-do-not-handle-seclabel-as-a-special-flag.patch
memcg-trivial-cleanups.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix-2.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

