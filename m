From: akpm@linux-foundation.org
Subject: + videobuf-dma-contig-zero-copy-userptr-support-v3-comments-checkpatch-fixes.patch added to -mm tree
Date: Tue, 12 May 2009 14:49:32 -0700
Message-ID: <200905122149.n4CLnX60005735@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752284AbZELVxe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 May 2009 17:53:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, damm@igel.co.jp, hannes@cmpxchg.org, hverkuil@xs4all.nl, lethal@linux-sh.org, mchehab@infradead.org


The patch titled
     videobuf-dma-contig-zero-copy-userptr-support-v3-comments-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     videobuf-dma-contig-zero-copy-userptr-support-v3-comments-checkpatch-fixes.patch

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
Subject: videobuf-dma-contig-zero-copy-userptr-support-v3-comments-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: trailing whitespace
#28: FILE: drivers/media/video/videobuf-dma-contig.c:117:
+ * This function resets the user space pointer $

total: 1 errors, 0 warnings, 28 lines checked

./patches/videobuf-dma-contig-zero-copy-userptr-support-v3-comments.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Magnus Damm <damm@igel.co.jp>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/videobuf-dma-contig.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/videobuf-dma-contig.c~videobuf-dma-contig-zero-copy-userptr-support-v3-comments-checkpatch-fixes drivers/media/video/videobuf-dma-contig.c
--- a/drivers/media/video/videobuf-dma-contig.c~videobuf-dma-contig-zero-copy-userptr-support-v3-comments-checkpatch-fixes
+++ a/drivers/media/video/videobuf-dma-contig.c
@@ -114,7 +114,7 @@ static struct vm_operations_struct video
  * videobuf_dma_contig_user_put() - reset pointer to user space buffer
  * @mem: per-buffer private videobuf-dma-contig data
  *
- * This function resets the user space pointer 
+ * This function resets the user space pointer
  */
 static void videobuf_dma_contig_user_put(struct videobuf_dma_contig_memory *mem)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

alpha-unbreak-percpu-again.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
drivers-gpu-drm-i915-intel_fbc-remove-sysrq-g-handler.patch
dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read.patch
input-keyboard-introduce-lm8323-driver.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
revert-fbdev-uninline-lock_fb_info.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
fs-sysfs-filec-use-create_singlethread_workqueue.patch
squashfs-fix-breakage-when-pagesize-blocksize.patch
mm-madvisec-dont-open-code-is_vm_hugetlb_page.patch
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
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
remove-put_cpu_no_resched-fix.patch
lib-do-code-optimization-for-radix_tree_lookup-and-radix_tree_lookup_slot-checkpatch-fixes.patch
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

