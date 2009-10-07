From: akpm@linux-foundation.org
Subject: [folded] mmc-sdio-dont-require-cistpl_vers_1-to-contain-4-strings-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 07 Oct 2009 16:27:48 -0700
Message-ID: <200910072327.n97NRmwk020067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751459AbZJGX3D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Oct 2009 19:29:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david.vrabel@csr.com, mm-commits@vger.kernel.org


The patch titled
     mmc-sdio-dont-require-cistpl_vers_1-to-contain-4-strings-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mmc-sdio-dont-require-cistpl_vers_1-to-contain-4-strings-checkpatch-fixes.patch

This patch was dropped because it was folded into mmc-sdio-dont-require-cistpl_vers_1-to-contain-4-strings.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc-sdio-dont-require-cistpl_vers_1-to-contain-4-strings-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: braces {} are not necessary for single statement blocks
#36: FILE: drivers/mmc/core/sdio_cis.c:44:
+	if (nr_strings == 0) {
 		return 0;
 	}

total: 0 errors, 1 warnings, 18 lines checked

./patches/mmc-sdio-dont-require-cistpl_vers_1-to-contain-4-strings.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: David Vrabel <david.vrabel@csr.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/sdio_cis.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/mmc/core/sdio_cis.c~mmc-sdio-dont-require-cistpl_vers_1-to-contain-4-strings-checkpatch-fixes drivers/mmc/core/sdio_cis.c
--- a/drivers/mmc/core/sdio_cis.c~mmc-sdio-dont-require-cistpl_vers_1-to-contain-4-strings-checkpatch-fixes
+++ a/drivers/mmc/core/sdio_cis.c
@@ -41,9 +41,8 @@ static int cistpl_vers_1(struct mmc_card
 		if (buf[i] == 0)
 			nr_strings++;
 	}
-	if (nr_strings == 0) {
+	if (nr_strings == 0)
 		return 0;
-	}
 
 	size = i;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmc-sdio-dont-require-cistpl_vers_1-to-contain-4-strings.patch
mmc-sdio-dont-require-cistpl_vers_1-to-contain-4-strings-checkpatch-fixes.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-fix.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
include-trace-events-lockdeph-fix-do_div-warning.patch
st-fix-test-of-value-range-in-st_set_options.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes.patch
readahead-add-blk_run_backing_dev.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
reiser4-disable.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

