From: akpm@linux-foundation.org
Subject: +
 lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes.patch added to -mm tree
Date: Tue, 17 Jan 2017 14:36:08 -0800
Message-ID: <587e9c58.FtrLtITGnkN+5QNr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47240 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751291AbdAQWna (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2017 17:43:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes.patch

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
Subject: lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes

WARNING: line over 80 characters
#214: FILE: mm/page_alloc.c:4332:
+static bool show_mem_node_skip(unsigned int flags, int nid, nodemask_t *nodemask)

WARNING: line over 80 characters
#230: FILE: mm/page_alloc.c:4338:
+	 * no node mask - aka implicit memory numa policy. Do not bother with the

WARNING: line over 80 characters
#231: FILE: mm/page_alloc.c:4339:
+	 * synchronization - read_mems_allowed_begin - because we do not have to be

total: 0 errors, 3 warnings, 198 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes mm/page_alloc.c
--- a/mm/page_alloc.c~lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes
+++ a/mm/page_alloc.c
@@ -4335,9 +4335,9 @@ static bool show_mem_node_skip(unsigned
 		return false;
 
 	/*
-	 * no node mask - aka implicit memory numa policy. Do not bother with the
-	 * synchronization - read_mems_allowed_begin - because we do not have to be
-	 * precise here.
+	 * no node mask - aka implicit memory numa policy. Do not bother with
+	 * the synchronization - read_mems_allowed_begin - because we do not
+	 * have to be precise here.
 	 */
 	if (!nodemask)
 		nodemask = &cpuset_current_mems_allowed;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-respect-foll_force-foll_cow-for-thp-checkpatch-fixes.patch
proc-add-a-schedule-point-in-proc_pid_readdir-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
dax-enable-iostat-for-read-write-fix.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
kernel-watchdog-prevent-false-hardlockup-on-overloaded-system-fix.patch
mm.patch
mm-throttle-show_mem-from-warn_alloc-fix.patch
userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing-fix-fix.patch
mm-page_alloc-split-buffered_rmqueue-fix.patch
lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

