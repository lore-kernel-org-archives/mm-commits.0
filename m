From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Tue, 07 Apr 2020 18:55:23 -0700
Message-ID: <20200408015523.1epPxxtT0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbgDHBzY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:55:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/csky/include/asm/thread_info.h |    7 -------
 1 file changed, 7 deletions(-)

--- a/arch/csky/include/asm/thread_info.h~linux-next-git-rejects
+++ a/arch/csky/include/asm/thread_info.h
@@ -54,17 +54,10 @@ static inline struct thread_info *curren
 #define TIF_SIGPENDING		0	/* signal pending */
 #define TIF_NOTIFY_RESUME	1       /* callback before returning to user */
 #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
-<<<<<<< HEAD
-#define TIF_SYSCALL_TRACE	3	/* syscall trace active */
-#define TIF_SYSCALL_TRACEPOINT	4       /* syscall tracepoint instrumentation */
-#define TIF_SYSCALL_AUDIT	5	/* syscall auditing */
-#define TIF_UPROBE		6	/* uprobe breakpoint or singlestep */
-=======
 #define TIF_UPROBE		3	/* uprobe breakpoint or singlestep */
 #define TIF_SYSCALL_TRACE	4	/* syscall trace active */
 #define TIF_SYSCALL_TRACEPOINT	5       /* syscall tracepoint instrumentation */
 #define TIF_SYSCALL_AUDIT	6	/* syscall auditing */
->>>>>>> linux-next/akpm-base
 #define TIF_POLLING_NRFLAG	16	/* poll_idle() is TIF_NEED_RESCHED */
 #define TIF_MEMDIE		18      /* is terminating due to OOM killer */
 #define TIF_RESTORE_SIGMASK	20	/* restore signal mask in do_signal() */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mempolicy-allow-lookup_node-to-handle-fatal-signal-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
mm-clarify-__gfp_memalloc-usage-checkpatch-fixes.patch
mm-hugetlbc-fix-printk-format-warning-for-32-bit-phys_addr_t-fix.patch
linux-next-fix.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
seq_read-info-message-about-buggy-next-functions-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
