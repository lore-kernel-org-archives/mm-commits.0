From: akpm@linux-foundation.org
Subject: + mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch added
 to -mm tree
Date: Thu, 08 May 2014 15:11:30 -0700
Message-ID: <536c0112.TaT1IhroeJgzACbr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41971 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733AbaEHWLc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2014 18:11:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, torvalds@linux-foundation.org, peterz@infradead.org, mingo@kernel.org, kirill.shutemov@linux.intel.com, davej@redhat.com, arigo@tunes.org, akpm@linux-foundation.org

Subject: + mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch added to -mm tree
To: akpm@linux-foundation.org,arigo@tunes.org,davej@redhat.com,kirill.shutemov@linux.intel.com,mingo@kernel.org,peterz@infradead.org,torvalds@linux-foundation.org
From: akpm@linux-foundation.org
Date: Thu, 08 May 2014 15:11:30 -0700


The patch titled
     Subject: mm-mark-remap_file_pages-syscall-as-deprecated-fix
has been added to the -mm tree.  Its filename is
     mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch

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
Subject: mm-mark-remap_file_pages-syscall-as-deprecated-fix

fix spello

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Armin Rigo <arigo@tunes.org>
Cc: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/fremap.c~mm-mark-remap_file_pages-syscall-as-deprecated-fix mm/fremap.c
--- a/mm/fremap.c~mm-mark-remap_file_pages-syscall-as-deprecated-fix
+++ a/mm/fremap.c
@@ -149,7 +149,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 	int has_write_lock = 0;
 	vm_flags_t vm_flags = 0;
 
-	pr_warn_once("%s (%d) uses depricated remap_file_pages() syscall. "
+	pr_warn_once("%s (%d) uses deprecated remap_file_pages() syscall. "
 			"See Documentation/vm/remap_file_pages.txt.\n",
 			current->comm, current->pid);
 
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
memcg-fold-mem_cgroup_stolen-fix.patch
mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk-fix.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix.patch
rtc-da9063-rtc-driver-fix.patch
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

