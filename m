From: akpm@linux-foundation.org
Subject: - rtc-cmos-improve-hpet-irq-glue-build-fix.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:35:55 -0700
Message-ID: <200807232348.m6NNmW7q018578@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756515AbYGWXtt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:49:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, bwalle@suse.de, crmafra@ift.unesp.br, dbrownell@users.sourceforge.net, tomi@nomi.cz, mm-commits@vger.kernel.org


The patch titled
     rtc-cmos-improve-hpet-irq-glue-build-fix
has been removed from the -mm tree.  Its filename was
     rtc-cmos-improve-hpet-irq-glue-build-fix.patch

This patch was dropped because it was folded into rtc-cmos-improve-hpet-irq-glue.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-cmos-improve-hpet-irq-glue-build-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Bernhard Walle <bwalle@suse.de>
Cc: Carlos R. Mafra <crmafra@ift.unesp.br>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Tomas Janousek <tomi@nomi.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-cmos.c~rtc-cmos-improve-hpet-irq-glue-build-fix drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-cmos-improve-hpet-irq-glue-build-fix
+++ a/drivers/rtc/rtc-cmos.c
@@ -134,7 +134,7 @@ static inline int hpet_register_irq_hand
 	return 0;
 }
 
-static inline int hpet_unregister_irq_handler(rtc_irq_handler handler)
+static inline int hpet_unregister_irq_handler(irq_handler_t handler)
 {
 	return 0;
 }
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
rtc-cmos-improve-hpet-irq-glue-build-fix.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
atmel_lcdfb-avoid-division-by-zero-checkpatch-fixes.patch
sm501-fixup-allocation-code-to-be-64bit-resource-compliant-sm501-align-panel-fb-to-page_size-fix.patch
lcd-add-platform_lcd-driver-fix.patch
fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact.patch
fbdev-add-new-cobalt-lcd-framebuffer-driver.patch
fbcon-remove-stray-semicolons-checkpatch-fixes.patch

