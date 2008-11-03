From: akpm@linux-foundation.org
Subject: + pcie-add-option-to-passively-listen-for-pcie-hotplug-events-checkpatch-fixes.patch added to -mm tree
Date: Mon, 03 Nov 2008 14:24:26 -0800
Message-ID: <200811032224.mA3MOR06002619@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751103AbYKCWZq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Nov 2008 17:25:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, mjg59@srcf.ucam.org, mjg@redhat.com


The patch titled
     pcie-add-option-to-passively-listen-for-pcie-hotplug-events-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     pcie-add-option-to-passively-listen-for-pcie-hotplug-events-checkpatch-fixes.patch

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
Subject: pcie-add-option-to-passively-listen-for-pcie-hotplug-events-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#48: FILE: drivers/pci/hotplug/pciehp_core.c:64:
+MODULE_PARM_DESC(pciehp_passive, "Listen for pciehp events, even if _OSC and OSHP are missing");

ERROR: code indent should use tabs where possible
#59: FILE: drivers/pci/hotplug/pciehp_core.c:94:
+  ^I.get_max_bus_speed =^Iget_max_bus_speed,$

ERROR: code indent should use tabs where possible
#60: FILE: drivers/pci/hotplug/pciehp_core.c:95:
+  ^I.get_cur_bus_speed =^Iget_cur_bus_speed,$

total: 2 errors, 1 warnings, 68 lines checked

./patches/pcie-add-option-to-passively-listen-for-pcie-hotplug-events.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/pciehp_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/pci/hotplug/pciehp_core.c~pcie-add-option-to-passively-listen-for-pcie-hotplug-events-checkpatch-fixes drivers/pci/hotplug/pciehp_core.c
--- a/drivers/pci/hotplug/pciehp_core.c~pcie-add-option-to-passively-listen-for-pcie-hotplug-events-checkpatch-fixes
+++ a/drivers/pci/hotplug/pciehp_core.c
@@ -91,8 +91,8 @@ static struct hotplug_slot_ops pciehp_ho
 static struct hotplug_slot_ops pciehp_passive_hotplug_slot_ops = {
 	.owner =		THIS_MODULE,
 	.get_adapter_status =	get_adapter_status,
-  	.get_max_bus_speed =	get_max_bus_speed,
-  	.get_cur_bus_speed =	get_cur_bus_speed,
+	.get_max_bus_speed =	get_max_bus_speed,
+	.get_cur_bus_speed =	get_cur_bus_speed,
 };
 
 /*
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

