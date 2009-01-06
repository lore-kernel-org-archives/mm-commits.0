From: akpm@linux-foundation.org
Subject: - edac-x38-use-the-architectures-readq-function-fix-fix.patch removed from -mm tree
Date: Tue, 06 Jan 2009 12:40:49 -0800
Message-ID: <200901062040.n06Kenr8000970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54600 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752117AbZAFUky (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2009 15:40:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dougthompson@xmission.com, mitake@clustcom.com, mm-commits@vger.kernel.org


The patch titled
     edac-x38-use-the-architectures-readq-function-fix-fix
has been removed from the -mm tree.  Its filename was
     edac-x38-use-the-architectures-readq-function-fix-fix.patch

This patch was dropped because it was folded into edac-x38-use-the-architectures-readq-function.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac-x38-use-the-architectures-readq-function-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

i386 allmodconfig:

drivers/edac/x38_edac.c:167: error: conflicting types for 'readq'
/usr/src/devel/arch/x86/include/asm/io.h:56: error: previous definition of 'readq' was here

Cc: Doug Thompson <dougthompson@xmission.com>
Cc: Hitoshi Mitake <mitake@clustcom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/Kconfig~edac-x38-use-the-architectures-readq-function-fix-fix drivers/edac/Kconfig
--- a/drivers/edac/Kconfig~edac-x38-use-the-architectures-readq-function-fix-fix
+++ a/drivers/edac/Kconfig
@@ -104,7 +104,7 @@ config EDAC_I3000
 
 config EDAC_X38
 	tristate "Intel X38"
-	depends on EDAC_MM_EDAC && PCI && X86
+	depends on EDAC_MM_EDAC && PCI && X86_64
 	help
 	  Support for error detection and correction on the Intel
 	  X38 server chipsets.
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
minix-fix-add-links-wrong-position-calculation.patch
fs-execc-make-do_coredump-void.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name.patch
edac-x38-use-the-architectures-readq-function.patch
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

