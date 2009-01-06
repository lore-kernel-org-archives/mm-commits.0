From: akpm@linux-foundation.org
Subject: - edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 06 Jan 2009 12:40:27 -0800
Message-ID: <200901062040.n06KeR3d000667@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58054 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755048AbZAFUkd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2009 15:40:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dougthompson@xmission.com, gregkh@suse.de, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch

This patch was dropped because it was folded into edac-struct-device-replace-bus_id-with-dev_name-dev_set_name.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: space required after that ',' (ctx:VxV)
#40: FILE: drivers/edac/edac_mc.c:404:
+		"%s (%s) %s %s already assigned %d\n",dev_name( p->dev),
 		                                     ^

ERROR: space prohibited after that open parenthesis '('
#40: FILE: drivers/edac/edac_mc.c:404:
+		"%s (%s) %s %s already assigned %d\n",dev_name( p->dev),

WARNING: line over 80 characters
#73: FILE: drivers/edac/edac_pci_sysfs.c:603:
+	debugf4("PCI HEADER TYPE= 0x%02x %s\n", header_type, dev_name(&dev->dev));

WARNING: line over 80 characters
#80: FILE: drivers/edac/edac_pci_sysfs.c:609:
+		debugf4("PCI SEC_STATUS= 0x%04x %s\n", status, dev_name(&dev->dev));

total: 2 errors, 2 warnings, 47 lines checked

./patches/edac-struct-device-replace-bus_id-with-dev_name-dev_set_name.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Doug Thompson <dougthompson@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_mc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/edac_mc.c~edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes
+++ a/drivers/edac/edac_mc.c
@@ -401,7 +401,7 @@ static int add_mc_to_global_list(struct 
 
 fail0:
 	edac_printk(KERN_WARNING, EDAC_MC,
-		"%s (%s) %s %s already assigned %d\n",dev_name( p->dev),
+		"%s (%s) %s %s already assigned %d\n", dev_name(p->dev),
 		edac_dev_name(mci), p->mod_name, p->ctl_name, p->mc_idx);
 	return 1;
 
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

