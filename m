From: akpm@linux-foundation.org
Subject: [folded-merged] rtc-add-abracon-abx80x-driver-fix.patch removed
 from -mm tree
Date: Wed, 01 Apr 2015 12:22:09 -0700
Message-ID: <551c4561.CIKlMZ1/W7QXyHgi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33319 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972AbbDATWK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2015 15:22:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, alexandre.belloni@free-electrons.com, pebolle@tiscali.nl, phdm@macqel.be, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-add-abracon-abx80x-driver-fix
has been removed from the -mm tree.  Its filename was
     rtc-add-abracon-abx80x-driver-fix.patch

This patch was dropped because it was folded into rtc-add-abracon-abx80x-driver.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-add-abracon-abx80x-driver-fix

s/GPL/GPL v2/, per Paul.

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Philippe De Muyter <phdm@macqel.be>
Cc: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-abx80x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-abx80x.c~rtc-add-abracon-abx80x-driver-fix drivers/rtc/rtc-abx80x.c
--- a/drivers/rtc/rtc-abx80x.c~rtc-add-abracon-abx80x-driver-fix
+++ a/drivers/rtc/rtc-abx80x.c
@@ -190,4 +190,4 @@ module_i2c_driver(abx80x_driver);
 
 MODULE_AUTHOR("Alexandre Belloni <alexandre.belloni@free-electrons.com>");
 MODULE_DESCRIPTION("Abracon ABX80X RTC driver");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-change-x86-microcode-loader-maintainer.patch
ocfs2-make-mlog_errno-return-the-errno.patch
mm.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch
mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings-fix.patch
mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
document-interaction-between-compaction-and-the-unevictable-lru-fix.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-mmapc-use-while-instead-of-ifgoto-fix.patch
mm-hugetlb-introduce-pagehugeactive-flag-fix.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag-fix.patch
mm-memblock-add-debug-output-for-the-memblock_add-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-introduce-automatic-device_id-generation-fix.patch
zsmalloc-support-compaction-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch
lib-find__bit-reimplementation-fix.patch
checkpatch-match-more-world-writable-permissions-fix.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-add-abracon-abx80x-driver.patch
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
linux-next-rejects.patch
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

