From: akpm@linux-foundation.org
Subject: [folded] ptrace-unify-show_regs-prototype-fix.patch removed from -mm tree
Date: Tue, 26 Jul 2011 15:56:14 -0700
Message-ID: <201107262256.p6QMuEqm014561@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55709 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751892Ab1GZW4p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 18:56:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, tj@kernel.org, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     ptrace-unify-show_regs-prototype-fix
has been removed from the -mm tree.  Its filename was
     ptrace-unify-show_regs-prototype-fix.patch

This patch was dropped because it was folded into ptrace-unify-show_regs-prototype.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace-unify-show_regs-prototype-fix
From: Oleg Nesterov <oleg@redhat.com>

No need to declare show_regs() in ptrace.h, sched.h does this.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/ptrace.h~ptrace-unify-show_regs-prototype-fix include/linux/ptrace.h
--- a/include/linux/ptrace.h~ptrace-unify-show_regs-prototype-fix
+++ a/include/linux/ptrace.h
@@ -114,7 +114,6 @@
 #include <linux/sched.h>		/* For struct task_struct.  */
 
 
-extern void show_regs(struct pt_regs *);
 extern long arch_ptrace(struct task_struct *child, long request,
 			unsigned long addr, unsigned long data);
 extern int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len);
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
ptrace-unify-show_regs-prototype.patch
coredump-use-task-comm-instead-of-unknown.patch
do_coredump-fix-the-ispipe-error-check.patch
fs-execc-acct_arg_size-ptl-is-no-longer-needed-for-add_mm_counter.patch
ipc-introduce-shm_rmid_forced-sysctl.patch
ipc-introduce-shm_rmid_forced-sysctl-fix-2.patch

