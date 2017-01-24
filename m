From: akpm@linux-foundation.org
Subject: [folded-merged]
 proc-add-a-schedule-point-in-proc_pid_readdir-fix.patch removed from -mm
 tree
Date: Tue, 24 Jan 2017 15:13:41 -0800
Message-ID: <5887dfa5.CCI/FmT/e9LBOhNo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41188 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751002AbdAXXNm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2017 18:13:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, edumazet@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc-add-a-schedule-point-in-proc_pid_readdir-fix
has been removed from the -mm tree.  Its filename was
     proc-add-a-schedule-point-in-proc_pid_readdir-fix.patch

This patch was dropped because it was folded into proc-add-a-schedule-point-in-proc_pid_readdir.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: proc-add-a-schedule-point-in-proc_pid_readdir-fix

coding style fix

Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/proc/base.c~proc-add-a-schedule-point-in-proc_pid_readdir-fix fs/proc/base.c
--- a/fs/proc/base.c~proc-add-a-schedule-point-in-proc_pid_readdir-fix
+++ a/fs/proc/base.c
@@ -3179,6 +3179,7 @@ int proc_pid_readdir(struct file *file,
 	     iter.tgid += 1, iter = next_tgid(ns, iter)) {
 		char name[PROC_NUMBUF];
 		int len;
+
 		cond_resched();
 		if (!has_pid_permissions(ns, iter.task, 2))
 			continue;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
proc-add-a-schedule-point-in-proc_pid_readdir.patch
mm-page_alloc-fix-premature-oom-when-racing-with-cpuset-mems-update-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
dax-enable-iostat-for-read-write-fix.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-throttle-show_mem-from-warn_alloc-fix.patch
userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing-fix-fix.patch
lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes.patch
mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath-fix.patch
mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix.patch
mm-track-active-portions-of-a-section-at-boot-fix.patch
mm-memory_hotplugc-unexport-__remove_pages.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
linux-next-rejects.patch
reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

