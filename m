From: akpm@linux-foundation.org
Subject: + page-allocator-clean-up-functions-related-to-pages_min-checkpatch-fixes.patch added to -mm tree
Date: Tue, 26 May 2009 22:30:29 -0700
Message-ID: <200905270530.n4R5UTL3030523@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750975AbZE0Faa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 May 2009 01:30:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, minchan.kim@gmail.com


The patch titled
     page-allocator-clean-up-functions-related-to-pages_min-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     page-allocator-clean-up-functions-related-to-pages_min-checkpatch-fixes.patch

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
Subject: page-allocator-clean-up-functions-related-to-pages_min-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: trailing whitespace
#119: FILE: mm/page_alloc.c:4474:
+ * setup_per_zone_wmarks - called when min_free_kbytes changes $

WARNING: line over 80 characters
#123: FILE: mm/page_alloc.c:4477:
+ * Ensures that the watermark[min,low,high] values for each zone are set correctly

total: 1 errors, 1 warnings, 62 lines checked

./patches/page-allocator-clean-up-functions-related-to-pages_min.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/mm.h~page-allocator-clean-up-functions-related-to-pages_min-checkpatch-fixes include/linux/mm.h
diff -puN mm/memory_hotplug.c~page-allocator-clean-up-functions-related-to-pages_min-checkpatch-fixes mm/memory_hotplug.c
diff -puN mm/page_alloc.c~page-allocator-clean-up-functions-related-to-pages_min-checkpatch-fixes mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-clean-up-functions-related-to-pages_min-checkpatch-fixes
+++ a/mm/page_alloc.c
@@ -4465,11 +4465,11 @@ static void setup_per_zone_lowmem_reserv
 }
 
 /**
- * setup_per_zone_wmarks - called when min_free_kbytes changes 
+ * setup_per_zone_wmarks - called when min_free_kbytes changes
  * or when memory is hot-added
  *
- * Ensures that the watermark[min,low,high] values for each zone are set correctly
- * with respect to min_free_kbytes.
+ * Ensures that the watermark[min,low,high] values for each zone are set
+ * correctly with respect to min_free_kbytes.
  */
 void setup_per_zone_wmarks(void)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-fbdev-uninline-lock_fb_info.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
devres-warn-and-return-dont-crash-on-device_del-of-uninitialized-device-cleanup.patch
dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
mtd-flex-onenand-support.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
drivers-usb-serial-sierrac-fix-printk-warning.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
videobuf-dma-contig-zero-copy-userptr-support-v3-comments-checkpatch-fixes.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
page-allocator-clean-up-functions-related-to-pages_min-checkpatch-fixes.patch
page-allocator-add-inactive-ratio-calculation-function-of-each-zone-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
remove-put_cpu_no_resched-fix.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
proc-merge-arrayc-into-basec-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
documentation-changes-perl-is-needed-to-build-the-kernel-fix.patch
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

