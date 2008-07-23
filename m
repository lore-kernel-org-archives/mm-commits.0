From: akpm@linux-foundation.org
Subject: - sync_file_range_write-may-and-will-block-document-that-fix.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:00:25 -0700
Message-ID: <200807232313.m6NND3XY016933@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58205 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754002AbYGWXNH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:13:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, pavel@suse.cz, mm-commits@vger.kernel.org


The patch titled
     sync_file_range_write-may-and-will-block-document-that-fix
has been removed from the -mm tree.  Its filename was
     sync_file_range_write-may-and-will-block-document-that-fix.patch

This patch was dropped because it was folded into sync_file_range_write-may-and-will-block-document-that.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sync_file_range_write-may-and-will-block-document-that-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sync.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/sync.c~sync_file_range_write-may-and-will-block-document-that-fix fs/sync.c
--- a/fs/sync.c~sync_file_range_write-may-and-will-block-document-that-fix
+++ a/fs/sync.c
@@ -139,8 +139,8 @@ asmlinkage long sys_fdatasync(unsigned i
  * before performing the write.
  *
  * SYNC_FILE_RANGE_WRITE: initiate writeout of all those dirty pages in the
- * range which are not presently under writeback. Notice that even this this
- *  may and will block if you attempt to write more than request queue size.
+ * range which are not presently under writeback. Note that this may block for
+ * significant periods due to exhaustion of disk request structures.
  *
  * SYNC_FILE_RANGE_WAIT_AFTER: wait upon writeout of all pages in the range
  * after performing the write.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-verify-the-page-links-and-memory-model.patch
mspec-convert-nopfn-to-fault.patch
page-allocator-inlnie-some-__alloc_pages-wrappers.patch
kill-generic_file_direct_io.patch
use-generic_access_phys-for-dev-mem-mappings.patch
spufs-use-the-new-vm_ops-access.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries.patch
page-flags-record-page-flag-overlays-explicitly.patch
mapping_set_error-add-unlikely.patch
huge-page-private-reservation-review-cleanups.patch
vma-page-offset-has-no-callees-drop-it.patch
sync_file_range_write-may-and-will-block-document-that.patch
sync_file_range_write-may-and-will-block-document-that-fix.patch
vmallocinfo-add-numa-information-fix.patch
hugetlb-modular-state-for-hugetlb-page-size-checkpatch-fixes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes-checkpatch-fixes.patch
hugetlb-override-default-huge-page-size-non-const-fix-fix.patch
linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
revert-revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-add-debugging-framework-fix.patch
bootmem-clean-up-free_all_bootmem_core-fix.patch
bootmem-free-reserve-helpers-fix.patch
revert-revert-revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-factor-out-the-marking-of-a-pfn-range-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-v850-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-powerpc-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-arm-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-mips-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-dvb.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-mtd-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-powerpc-fixes.patch
mmu-notifiers-add-mm_take_all_locks-operation-checkpatch-fixes.patch
mmu-notifier-core-checkpatch-fixes.patch
mmu-notifier-core-fix.patch
mmu-notifier-core-fix-2.patch
security-protect-legacy-apps-from-insufficient-privilege-cleanup.patch
security-protect-legacy-applications-from-executing-with-insufficient-privilege-checkpatch-fixes.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option-fix.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-sys_ni.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
flag-parameters-inotify_init-fix.patch
flag-parameters-check-magic-constants-alpha.patch
spi-au1550_spi-improve-pio-transfer-mode-checkpatch-fixes.patch
autofs4-use-lookup-intent-flags-to-trigger-mounts-fix.patch
rtc-cmos-improve-hpet-irq-glue-build-fix.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
atmel_lcdfb-avoid-division-by-zero-checkpatch-fixes.patch
sm501-fixup-allocation-code-to-be-64bit-resource-compliant-sm501-align-panel-fb-to-page_size-fix.patch
lcd-add-platform_lcd-driver-fix.patch
fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact.patch
fbdev-add-new-cobalt-lcd-framebuffer-driver.patch
fbcon-remove-stray-semicolons-checkpatch-fixes.patch

