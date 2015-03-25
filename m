From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 25 Mar 2015 12:23:27 -0700
Message-ID: <55130b2f.ONjQBGNZfLAbEilV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59583 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbbCYTX2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Mar 2015 15:23:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/regulator/palmas-regulator.c |    6 ------
 include/linux/libata.h               |    3 ---
 2 files changed, 9 deletions(-)

diff -puN drivers/regulator/palmas-regulator.c~linux-next-git-rejects drivers/regulator/palmas-regulator.c
--- a/drivers/regulator/palmas-regulator.c~linux-next-git-rejects
+++ a/drivers/regulator/palmas-regulator.c
@@ -1577,17 +1577,11 @@ static int palmas_regulators_probe(struc
 	if (!pmic)
 		return -ENOMEM;
 
-<<<<<<< HEAD
-	if (of_device_is_compatible(node, "ti,tps659038-pmic"))
-		palmas_generic_regs_info[PALMAS_REG_REGEN2].ctrl_addr =
-							TPS659038_REGEN2_CTRL;
-=======
 	if (of_device_is_compatible(node, "ti,tps659038-pmic")) {
 		palmas_generic_regs_info[PALMAS_REG_REGEN2].ctrl_addr =
 							TPS659038_REGEN2_CTRL;
 		palmas_ddata.has_regen3 = false;
 	}
->>>>>>> linux-next/akpm-base
 
 	pmic->dev = &pdev->dev;
 	pmic->palmas = palmas;
diff -puN include/linux/libata.h~linux-next-git-rejects include/linux/libata.h
--- a/include/linux/libata.h~linux-next-git-rejects
+++ a/include/linux/libata.h
@@ -231,10 +231,7 @@ enum {
 	ATA_FLAG_SW_ACTIVITY	= (1 << 22), /* driver supports sw activity
 					      * led */
 	ATA_FLAG_NO_DIPM	= (1 << 23), /* host not happy with DIPM */
-<<<<<<< HEAD
 	ATA_FLAG_LOWTAG		= (1 << 24), /* host wants lowest available tag */
-=======
->>>>>>> linux-next/akpm-base
 	ATA_FLAG_SAS_HOST	= (1 << 25), /* SAS host */
 
 	/* bits 24:31 of ap->flags are reserved for LLD specific flags */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
drivers-rtc-rtc-mrst-fix-suspend-resume-fix.patch
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
mm-memory-failurec-define-page-types-for-action_result-in-one-place-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-support-madvisemadv_free-fix-2.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
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

