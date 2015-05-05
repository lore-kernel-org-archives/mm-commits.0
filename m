From: akpm@linux-foundation.org
Subject: [obsolete]
 watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 05 May 2015 15:12:40 -0700
Message-ID: <55494058.gfVjdgzurDwtEcGT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34068 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbbEEWMk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2015 18:12:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jhubbard@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix-checkpatch-fixes.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix-checkpatch-fixes

ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'Commit 0123456789ab ("commit description")'
#4: 
Commit 8fcf2cc768acd845c1fed837bf9cfe2d7106336d in linux-next introduced a

ERROR: else should follow close brace '}'
#52: FILE: kernel/watchdog.c:929:
+	}
+	else

total: 2 errors, 0 warnings, 22 lines checked

./patches/watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/watchdog.c~watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix-checkpatch-fixes kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix-checkpatch-fixes
+++ a/kernel/watchdog.c
@@ -925,9 +925,9 @@ void __init lockup_detector_init(void)
 			pr_info("Disabling watchdog on nohz_full cores by default\n");
 		cpumask_andnot(&watchdog_cpumask, cpu_possible_mask,
 			       tick_nohz_full_mask);
-	}
-	else
+	} else {
 		cpumask_copy(&watchdog_cpumask, cpu_possible_mask);
+	}
 
 	if (watchdog_enabled)
 		watchdog_enable_all_cpus();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
revert-zram-move-compact_store-to-sysfs-functions-area.patch
maintainers-add-co-maintainer-for-led-subsystem.patch
revert-fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-meminit-inline-some-helper-functions-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
linux-next.patch
linux-next-rejects.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

