From: akpm@linux-foundation.org
Subject: [folded-merged] drivers-rtc-rtc-mrst-fix-suspend-resume-fix.patch removed from -mm tree
Date: Wed, 25 Mar 2015 15:51:28 -0700
Message-ID: <55133bf0.pP30KLgibs571EtT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34088 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbbCYWv2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Mar 2015 18:51:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, feng.tang@intel.com, lars@metafoo.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-rtc-rtc-mrst-fix-suspend-resume-fix
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-mrst-fix-suspend-resume-fix.patch

This patch was dropped because it was folded into drivers-rtc-rtc-mrst-fix-suspend-resume.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-rtc-rtc-mrst-fix-suspend-resume-fix

device_driver.name is const char *

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mrst.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-mrst.c~drivers-rtc-rtc-mrst-fix-suspend-resume-fix drivers/rtc/rtc-mrst.c
--- a/drivers/rtc/rtc-mrst.c~drivers-rtc-rtc-mrst-fix-suspend-resume-fix
+++ a/drivers/rtc/rtc-mrst.c
@@ -531,7 +531,7 @@ static struct platform_driver vrtc_mrst_
 	.remove		= vrtc_mrst_platform_remove,
 	.shutdown	= vrtc_mrst_platform_shutdown,
 	.driver = {
-		.name	= (char *) driver_name,
+		.name	= driver_name,
 		.pm	= MRST_PM_OPS,
 	}
 };
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
drivers-rtc-rtc-mrst-fix-suspend-resume.patch
mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention.patch
mm.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch
mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings-fix.patch
mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place-fix-2.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-introduce-automatic-device_id-generation-fix.patch
zsmalloc-support-compaction-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch
lib-find__bit-reimplementation-fix.patch
checkpatch-match-more-world-writable-permissions-fix.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-add-abracon-abx80x-driver-fix.patch
rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
kernel-forkc-avoid-division-by-zero-fix.patch
kernel-forkc-avoid-division-by-zero-fix-fix.patch
doc-sysctl-kerneltxt-document-threads-max-fix.patch
mm-rcu-protected-get_mm_exe_file-fix-2.patch
affs-kstrdup-memory-handling-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
linux-next.patch
linux-next-git-rejects.patch
linux-next-rejects.patch
include-sound-fix-build.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch
tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch
documentation-spi-spidev_testc-fix-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

