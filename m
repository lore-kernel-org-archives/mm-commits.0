From: akpm@linux-foundation.org
Subject: + kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch added to -mm tree
Date: Tue, 06 May 2014 13:49:21 -0700
Message-ID: <53694ad1.7FuzKQAuuX4SqJqS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40861 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545AbaEFUtW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2014 16:49:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, fabf@skynet.be, akpm@linux-foundation.org

Subject: + kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch added to -mm tree
To: akpm@linux-foundation.org,fabf@skynet.be,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Tue, 06 May 2014 13:49:21 -0700


The patch titled
     Subject: kernel-posix-timersc-code-clean-up-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch

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
Subject: kernel-posix-timersc-code-clean-up-checkpatch-fixes

WARNING: space prohibited between function name and open parenthesis '('
#55: FILE: kernel/posix-timers.c:345:
+					       sizeof (struct k_itimer), 0,

ERROR: do not use assignment in if condition
#70: FILE: kernel/posix-timers.c:504:
+	if ((event->sigev_notify & SIGEV_THREAD_ID) &&

total: 1 errors, 1 warnings, 192 lines checked

./patches/kernel-posix-timersc-code-clean-up.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Fabian Frederick <fabf@skynet.be>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/posix-timers.c~kernel-posix-timersc-code-clean-up-checkpatch-fixes kernel/posix-timers.c
--- a/kernel/posix-timers.c~kernel-posix-timersc-code-clean-up-checkpatch-fixes
+++ a/kernel/posix-timers.c
@@ -342,7 +342,7 @@ static __init int init_posix_timers(void
 	posix_timers_register_clock(CLOCK_TAI, &clock_tai);
 
 	posix_timers_cache = kmem_cache_create("posix_timers_cache",
-					       sizeof (struct k_itimer), 0,
+					       sizeof(struct k_itimer), 0,
 					       SLAB_PANIC, NULL);
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported.patch
slub-use-sysfses-release-mechanism-for-kmem_cache.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
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
tools-testing-selftests-sysctl-validate-sysctl_writes_strict-fix.patch
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
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1-fix.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch

