From: akpm@linux-foundation.org
Subject: - rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch removed from -mm tree
Date: Tue, 06 Jan 2009 12:37:16 -0800
Message-ID: <200901062037.n06KbHNr030592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751200AbZAFUi7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2009 15:38:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, david-b@pacbell.net, mano@roarinelk.homelinux.net, mm-commits@vger.kernel.org


The patch titled
     rtc-au1000-on-chip-counter0-as-rtc-driver-fix
has been removed from the -mm tree.  Its filename was
     rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch

This patch was dropped because it was folded into rtc-au1000-on-chip-counter0-as-rtc-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-au1000-on-chip-counter0-as-rtc-driver-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Manuel Lauss <mano@roarinelk.homelinux.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/Kconfig~rtc-au1000-on-chip-counter0-as-rtc-driver-fix drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-au1000-on-chip-counter0-as-rtc-driver-fix
+++ a/drivers/rtc/Kconfig
@@ -639,7 +639,7 @@ config RTC_DRV_AT91SAM9_GPBR
 	  on some systems other software needs to use that register.
 
 config RTC_DRV_AU1XXX
-	tristate "Au1xxx Counter0 RTC support
+	tristate "Au1xxx Counter0 RTC support"
 	depends on SOC_AU1X00
 	help
 	  This is a driver for the Au1xxx on-chip Counter0 (Time-Of-Year
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
spi_gpio-driver.patch
kprobes-support-probing-module-__exit-function.patch
rtc-au1000-on-chip-counter0-as-rtc-driver.patch
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

