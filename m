From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-fix-premature-oom-when-racing-with-cpuset-mems-update-fix.patch added to -mm tree
Date: Fri, 20 Jan 2017 15:23:17 -0800
Message-ID: <58829be5.iEOg72Zqe2mWoyTI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40742 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752125AbdATXXS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2017 18:23:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-fix-premature-oom-when-racing-with-cpuset-mems-update-fix
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fix-premature-oom-when-racing-with-cpuset-mems-update-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-fix-premature-oom-when-racing-with-cpuset-mems-update-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-fix-premature-oom-when-racing-with-cpuset-mems-update-fix.patch

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
Subject: mm-page_alloc-fix-premature-oom-when-racing-with-cpuset-mems-update-fix

fix typo in comment

Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-fix-premature-oom-when-racing-with-cpuset-mems-update-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-fix-premature-oom-when-racing-with-cpuset-mems-update-fix
+++ a/mm/page_alloc.c
@@ -3746,7 +3746,7 @@ retry:
 
 nopage:
 	/*
-	 * When updating a task's mems_allowed or mempolicy nodeask, it is
+	 * When updating a task's mems_allowed or mempolicy nodemask, it is
 	 * possible to race with parallel threads in such a way that our
 	 * allocation can fail while the mask is being updated. If we are about
 	 * to fail, check if the cpuset changed during allocation and if so,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-respect-foll_force-foll_cow-for-thp-checkpatch-fixes.patch
proc-add-a-schedule-point-in-proc_pid_readdir-fix.patch
mm-page_alloc-fix-premature-oom-when-racing-with-cpuset-mems-update-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
dax-enable-iostat-for-read-write-fix.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
kernel-watchdog-prevent-false-hardlockup-on-overloaded-system-fix.patch
mm.patch
mm-throttle-show_mem-from-warn_alloc-fix.patch
userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing-fix-fix.patch
lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes.patch
mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix.patch
mm-track-active-portions-of-a-section-at-boot-fix.patch
mm-memory_hotplugc-unexport-__remove_pages.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

