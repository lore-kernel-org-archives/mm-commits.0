From: akpm@linux-foundation.org
Subject: [merged] drivers-base-iommuc-add-missing-includes.patch removed from -mm tree
Date: Thu, 07 May 2009 12:16:30 -0700
Message-ID: <200905071916.n47JGURB020372@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753173AbZEGTTZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 May 2009 15:19:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gregkh@suse.de, joerg.roedel@amd.com, mm-commits@vger.kernel.org


The patch titled
     drivers/base/iommu.c: add missing includes
has been removed from the -mm tree.  Its filename was
     drivers-base-iommuc-add-missing-includes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/base/iommu.c: add missing includes
From: Andrew Morton <akpm@linux-foundation.org>

Fix zillions of -mm x86_64 allmodconfig build errors - the file uses
EXPORT_SYMBOL() and kmalloc but misses the needed includes.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/iommu.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/base/iommu.c~drivers-base-iommuc-add-missing-includes drivers/base/iommu.c
--- a/drivers/base/iommu.c~drivers-base-iommuc-add-missing-includes
+++ a/drivers/base/iommu.c
@@ -18,6 +18,8 @@
 
 #include <linux/bug.h>
 #include <linux/types.h>
+#include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/iommu.h>
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
drivers-gpu-drm-i915-intel_fbc-remove-sysrq-g-handler.patch
dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read-fix.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
mtd-fix-timeout-in-m25p80-driver-fix.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
mm-madvisec-dont-open-code-is_vm_hugetlb_page.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
leds-of_register_platform_driver-doesnt-exist-on-sparc64.patch
squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
remove-put_cpu_no_resched-fix.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

