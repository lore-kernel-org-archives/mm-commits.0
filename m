From: akpm@linux-foundation.org
Subject: - fbcon-remove-stray-semicolons-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:40:57 -0700
Message-ID: <200807232353.m6NNrYXS018811@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58742 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754428AbYGWXxh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:53:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jbeulich@novell.com, mm-commits@vger.kernel.org


The patch titled
     fbcon-remove-stray-semicolons-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     fbcon-remove-stray-semicolons-checkpatch-fixes.patch

This patch was dropped because it was folded into fbcon-remove-stray-semicolons.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbcon-remove-stray-semicolons-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: space required after that ',' (ctx:VxV)
#18: FILE: drivers/video/console/fbcon.h:150:
+	attr_col_ec(bgshift,vc,info,0)
 	                   ^

ERROR: space required after that ',' (ctx:VxV)
#18: FILE: drivers/video/console/fbcon.h:150:
+	attr_col_ec(bgshift,vc,info,0)
 	                      ^

ERROR: space required after that ',' (ctx:VxV)
#18: FILE: drivers/video/console/fbcon.h:150:
+	attr_col_ec(bgshift,vc,info,0)
 	                           ^

ERROR: space required after that ',' (ctx:VxV)
#21: FILE: drivers/video/console/fbcon.h:152:
+	attr_col_ec(fgshift,vc,info,1)
 	                   ^

ERROR: space required after that ',' (ctx:VxV)
#21: FILE: drivers/video/console/fbcon.h:152:
+	attr_col_ec(fgshift,vc,info,1)
 	                      ^

ERROR: space required after that ',' (ctx:VxV)
#21: FILE: drivers/video/console/fbcon.h:152:
+	attr_col_ec(fgshift,vc,info,1)
 	                           ^

total: 6 errors, 0 warnings, 11 lines checked

./patches/fbcon-remove-stray-semicolons.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Cc: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/video/console/fbcon.h~fbcon-remove-stray-semicolons-checkpatch-fixes drivers/video/console/fbcon.h
--- a/drivers/video/console/fbcon.h~fbcon-remove-stray-semicolons-checkpatch-fixes
+++ a/drivers/video/console/fbcon.h
@@ -146,10 +146,8 @@ static inline int attr_col_ec(int shift,
 	return is_fg ? fg : bg;
 }
 
-#define attr_bgcol_ec(bgshift,vc,info)		\
-	attr_col_ec(bgshift,vc,info,0)
-#define attr_fgcol_ec(fgshift,vc,info)		\
-	attr_col_ec(fgshift,vc,info,1)
+#define attr_bgcol_ec(bgshift, vc, info) attr_col_ec(bgshift, vc, info, 0)
+#define attr_fgcol_ec(fgshift, vc, info) attr_col_ec(fgshift, vc, info, 1)
 
 /* Font */
 #define REFCOUNT(fd)	(((int *)(fd))[-1])
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
vmallocinfo-add-numa-information.patch
hugetlb-modular-state-for-hugetlb-page-size.patch
hugetlb-multiple-hstates-for-multiple-page-sizes.patch
bootmem-add-debugging-framework.patch
bootmem-clean-up-free_all_bootmem_core.patch
bootmem-free-reserve-helpers.patch
bootmem-factor-out-the-marking-of-a-pfn-range.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
security-protect-legacy-applications-from-executing-with-insufficient-privilege.patch
security-protect-legacy-apps-from-insufficient-privilege-cleanup.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option.patch
flag-parameters-paccept.patch
flag-parameters-anon_inode_getfd-extension.patch
flag-parameters-signalfd.patch
flag-parameters-eventfd.patch
flag-parameters-inotify_init.patch
flag-parameters-check-magic-constants.patch
spi-au1550_spi-improve-pio-transfer-mode.patch
autofs4-use-lookup-intent-flags-to-trigger-mounts.patch
rtc-cmos-improve-hpet-irq-glue.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed.patch
atmel_lcdfb-avoid-division-by-zero.patch
sm501-fixup-allocation-code-to-be-64bit-resource-compliant.patch
lcd-add-platform_lcd-driver.patch
fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact.patch
fbdev-add-new-cobalt-lcd-framebuffer-driver.patch
fbcon-remove-stray-semicolons.patch
fbcon-remove-stray-semicolons-checkpatch-fixes.patch

