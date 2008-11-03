From: akpm@linux-foundation.org
Subject: + edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch added to -mm tree
Date: Mon, 03 Nov 2008 14:57:56 -0800
Message-ID: <200811032257.mA3MvvYg017813@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756239AbYKCW6J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Nov 2008 17:58:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dougthompson@xmission.com, gregkh@suse.de, kay.sievers@vrfy.org


The patch titled
     edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

autofs4-collect-version-check-return-checkpatch-fixes.patch
maintainers-make-ioat-easier-to-find.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
pci-uninline-pci_ioremap_bar.patch
pcie-add-option-to-passively-listen-for-pcie-hotplug-events-checkpatch-fixes.patch
cpusets-update-mems-allowed-in-page-allocator-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
init-properly-placing-noinline-keyword.patch
oops-handling-ensure-that-any-oops-is-flushed-to-the-mtdoops-console-fix.patch
spi_gpio-driver-cleanups.patch
rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch
rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock-fix.patch
quota-permit-separately-enabling-quota-accounting-and-enforcing-limits-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix-2.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
quota-support-64-bit-quota-format-fix.patch
quota-support-64-bit-quota-format-fix-2.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-broke.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

