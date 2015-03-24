From: akpm@linux-foundation.org
Subject: + mm-rcu-protected-get_mm_exe_file-fix-2.patch added to -mm tree
Date: Tue, 24 Mar 2015 13:00:44 -0700
Message-ID: <5511c26c.OETR5e9MTNTltGE7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36398 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbbCXUAp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Mar 2015 16:00:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, khlebnikov@yandex-team.ru, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rcu-protected-get_mm_exe_file-fix-2
has been added to the -mm tree.  Its filename is
     mm-rcu-protected-get_mm_exe_file-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rcu-protected-get_mm_exe_file-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rcu-protected-get_mm_exe_file-fix-2.patch

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
Subject: mm-rcu-protected-get_mm_exe_file-fix-2

fix comment typo

Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/file.c~mm-rcu-protected-get_mm_exe_file-fix-2 fs/file.c
diff -puN include/linux/fs.h~mm-rcu-protected-get_mm_exe_file-fix-2 include/linux/fs.h
diff -puN include/linux/mm_types.h~mm-rcu-protected-get_mm_exe_file-fix-2 include/linux/mm_types.h
diff -puN kernel/fork.c~mm-rcu-protected-get_mm_exe_file-fix-2 kernel/fork.c
--- a/kernel/fork.c~mm-rcu-protected-get_mm_exe_file-fix-2
+++ a/kernel/fork.c
@@ -686,7 +686,7 @@ EXPORT_SYMBOL_GPL(mmput);
 /**
  * set_mm_exe_file - change a reference to the mm's executable file
  *
- * This changes mm's executale file (shown as symlink /proc/[pid]/exe).
+ * This changes mm's executable file (shown as symlink /proc/[pid]/exe).
  *
  * Main users are mmput(), sys_execve() and sys_prctl(PR_SET_MM_MAP/EXE_FILE).
  * Callers prevent concurrent invocations: in mmput() nobody alive left,
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
hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure-fix.patch
hugetlbfs-add-minimum-size-accounting-to-subpools-fix.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix.patch
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
fs-fat-remove-unnecessary-includes-fix.patch
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

