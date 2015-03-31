From: akpm@linux-foundation.org
Subject: + mm-memblock-add-debug-output-for-the-memblock_add-fix.patch
 added to -mm tree
Date: Tue, 31 Mar 2015 16:38:20 -0700
Message-ID: <551b2fec.AHuHlPPWOG+TkY2t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55046 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbbCaXiV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Mar 2015 19:38:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Emilian.Medve@freescale.com, akinobu.mita@gmail.com, catalin.marinas@arm.com, fabf@skynet.be, kuleshovmail@gmail.com, phacht@linux.vnet.ibm.com, schwidefsky@de.ibm.com, tangchen@cn.fujitsu.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memblock-add-debug-output-for-the-memblock_add-fix
has been added to the -mm tree.  Its filename is
     mm-memblock-add-debug-output-for-the-memblock_add-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblock-add-debug-output-for-the-memblock_add-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblock-add-debug-output-for-the-memblock_add-fix.patch

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
Subject: mm-memblock-add-debug-output-for-the-memblock_add-fix

s/memblock_memory/memblock_add/ in message

Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Alexander Kuleshov <kuleshovmail@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Emil Medve <Emilian.Medve@freescale.com>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memblock.c~mm-memblock-add-debug-output-for-the-memblock_add-fix mm/memblock.c
--- a/mm/memblock.c~mm-memblock-add-debug-output-for-the-memblock_add-fix
+++ a/mm/memblock.c
@@ -587,7 +587,7 @@ static int __init_memblock memblock_add_
 {
 	struct memblock_type *_rgn = &memblock.memory;
 
-	memblock_dbg("memblock_memory: [%#016llx-%#016llx] flags %#02lx %pF\n",
+	memblock_dbg("memblock_add: [%#016llx-%#016llx] flags %#02lx %pF\n",
 		     (unsigned long long)base,
 		     (unsigned long long)base + size - 1,
 		     flags, (void *)_RET_IP_);
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

