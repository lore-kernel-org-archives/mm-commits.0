From: akpm@linux-foundation.org
Subject: [obsolete]
 tools-testing-selftests-sysctl-validate-sysctl_writes_strict-fix.patch
 removed from -mm tree
Date: Wed, 07 May 2014 12:24:27 -0700
Message-ID: <536a886b.LfSdbG7WdYEIt3aL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56559 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaEGTY2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2014 15:24:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org, keescook@chromium.org, akpm@linux-foundation.org

Subject: [obsolete] tools-testing-selftests-sysctl-validate-sysctl_writes_strict-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,keescook@chromium.org,rdunlap@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 07 May 2014 12:24:27 -0700


The patch titled
     Subject: tools-testing-selftests-sysctl-validate-sysctl_writes_strict-fix
has been removed from the -mm tree.  Its filename was
     tools-testing-selftests-sysctl-validate-sysctl_writes_strict-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: tools-testing-selftests-sysctl-validate-sysctl_writes_strict-fix

remove misplaced hunk, per Randy

Cc: Kees Cook <keescook@chromium.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/sysctl.c~tools-testing-selftests-sysctl-validate-sysctl_writes_strict-fix kernel/sysctl.c
--- a/kernel/sysctl.c~tools-testing-selftests-sysctl-validate-sysctl_writes_strict-fix
+++ a/kernel/sysctl.c
@@ -1783,8 +1783,8 @@ static int _proc_do_string(char *data, i
 
 static void warn_sysctl_write(struct ctl_table *table)
 {
-	pr_warn("write to %s by %s used a non-zero file position!\n",
-		table->procname, current->comm);
+	pr_warn("%s wrote to %s when file position was not 0!\n",
+		current->comm, table->procname);
 	pr_warn("This will not be supported in the future.\n");
 	pr_warn("To silence warning, set kernel.sysctl_writes_strict = -1\n");
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1-fix.patch
ocfs2-limit-printk-when-journal-is-aborted-fix.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage-fix.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
arc-call-find_vma-with-the-mmap_sem-held-fix.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal-checkpatch-fixes.patch
swap-use-bdev_read_page-bdev_write_page-fix.patch
mm-update-comment-for-default_max_map_count-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk-fix.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix.patch
hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix-2.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
sysctl-allow-for-strict-write-position-handling-fix-2.patch
sysctl-allow-for-strict-write-position-handling-fix.patch
sysctl-allow-for-strict-write-position-handling-fix-3.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-page_ioc-work-around-gcc-bug.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

