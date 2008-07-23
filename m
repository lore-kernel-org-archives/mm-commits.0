From: akpm@linux-foundation.org
Subject: - lcd-add-platform_lcd-driver-fix.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:39:43 -0700
Message-ID: <200807232352.m6NNqKTS018778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750799AbYGWXwy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:52:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ben-linux@fluff.org, mm-commits@vger.kernel.org


The patch titled
     lcd-add-platform_lcd-driver-fix
has been removed from the -mm tree.  Its filename was
     lcd-add-platform_lcd-driver-fix.patch

This patch was dropped because it was folded into lcd-add-platform_lcd-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lcd-add-platform_lcd-driver-fix
From: Andrew Morton <akpm@linux-foundation.org>

drivers/video/backlight/platform_lcd.c:153: error: 'platform_lcd_suspend' undeclared here (not in a function)
drivers/video/backlight/platform_lcd.c:154: error: 'platform_lcd_resume' undeclared here (not in a function)

Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/platform_lcd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/platform_lcd.c~lcd-add-platform_lcd-driver-fix drivers/video/backlight/platform_lcd.c
--- a/drivers/video/backlight/platform_lcd.c~lcd-add-platform_lcd-driver-fix
+++ a/drivers/video/backlight/platform_lcd.c
@@ -139,8 +139,8 @@ static int platform_lcd_resume(struct pl
 	return 0;
 }
 #else
-#define s3c2410bl_suspend NULL
-#define s3c2410bl_resume  NULL
+#define platform_lcd_suspend NULL
+#define platform_lcd_resume NULL
 #endif
 
 static struct platform_driver platform_lcd_driver = {
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
lcd-add-platform_lcd-driver-fix.patch
fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact.patch
fbdev-add-new-cobalt-lcd-framebuffer-driver.patch
fbcon-remove-stray-semicolons-checkpatch-fixes.patch

