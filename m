From: akpm@linux-foundation.org
Subject: - binfmtsh-include-listh-fix.patch removed from -mm tree
Date: Tue, 06 Jan 2009 12:33:14 -0800
Message-ID: <200901062033.n06KXFpu027266@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750928AbZAFUdS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2009 15:33:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, h-shimamoto@ct.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     binfmtsh-include-listh-fix
has been removed from the -mm tree.  Its filename was
     binfmtsh-include-listh-fix.patch

This patch was dropped because it was folded into binfmtsh-include-listh.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: binfmtsh-include-listh-fix
From: Andrew Morton <akpm@linux-foundation.org>

/usr/src/devel/usr/include/linux/binfmts.h:4: included file 'linux/list.h' is not exported

Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/binfmts.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/binfmts.h~binfmtsh-include-listh-fix include/linux/binfmts.h
--- a/include/linux/binfmts.h~binfmtsh-include-listh-fix
+++ a/include/linux/binfmts.h
@@ -1,7 +1,6 @@
 #ifndef _LINUX_BINFMTS_H
 #define _LINUX_BINFMTS_H
 
-#include <linux/list.h>
 #include <linux/capability.h>
 
 struct pt_regs;
@@ -19,6 +18,7 @@ struct pt_regs;
 #define BINPRM_BUF_SIZE 128
 
 #ifdef __KERNEL__
+#include <linux/list.h>
 
 #define CORENAME_MAX_SIZE 128
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-invoke-oom-killer-from-page-fault.patch
mm-write_cache_pages-more-terminate-quickly.patch
swapfile-change-discard-pgoff_t-to-sector_t.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error.patch
vmscan-shrink_active_list-reduce-lru_lock-hold-time.patch
mm-mmapc-fix-coding-style.patch
mm-check-for-no-mmaps-in-exit_mmap.patch
mm-stop-kswapds-infinite-loop-at-high-order-allocation-take2.patch
mm-hugetlb-get-rid-of-redundant-if-operation.patch
init-properly-placing-noinline-keyword.patch
add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch
poll-allow-f_op-poll-to-sleep-take6.patch
ioc4-automatically-load-sgiioc4-subordinate-module.patch
binfmtsh-include-listh.patch
binfmtsh-include-listh-fix.patch
spi_gpio-driver-cleanups.patch
kprobes-support-probing-module-__exit-function-fix.patch
kprobes-support-probing-module-__exit-function-fix-2.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
minix-fix-add-links-wrong-position-calculation-checkpatch-fixes.patch
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup-checkpatch-fixes.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
fs-execc-make-do_coredump-void-checkpatch-fixes.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
edac-x38-use-the-architectures-readq-function-fix.patch
edac-x38-use-the-architectures-readq-function-fix-fix.patch
dma_alloc_from_coherent-fix-fallback-to-generic-memory.patch
dma_alloc_coherent-clean-it-up.patch
parport-ieee1284-use-del_timer_sync-in-parport_wait_event-checkpatch-fixes.patch
w1-allow-master-io-commands-fix.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
kmemleak-add-the-base-support-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

