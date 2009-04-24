From: akpm@linux-foundation.org
Subject: + ptrace-tracehook_unsafe_exec-remove-the-stale-comment.patch added to -mm tree
Date: Thu, 23 Apr 2009 17:02:49 -0700
Message-ID: <200904240002.n3O02nbT005216@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54698 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751604AbZDXAFV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Apr 2009 20:05:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, roland@redhat.com


The patch titled
     ptrace: tracehook_unsafe_exec(): remove the stale comment
has been added to the -mm tree.  Its filename is
     ptrace-tracehook_unsafe_exec-remove-the-stale-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: tracehook_unsafe_exec(): remove the stale comment
From: Oleg Nesterov <oleg@redhat.com>

tracehook_unsafe_exec() doesn't need task_lock(), remove the old comment.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tracehook.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/tracehook.h~ptrace-tracehook_unsafe_exec-remove-the-stale-comment include/linux/tracehook.h
--- a/include/linux/tracehook.h~ptrace-tracehook_unsafe_exec-remove-the-stale-comment
+++ a/include/linux/tracehook.h
@@ -142,8 +142,6 @@ static inline void tracehook_report_sysc
  * @task:		current task doing exec
  *
  * Return %LSM_UNSAFE_* bits applied to an exec because of tracing.
- *
- * Called with task_lock() held on @task.
  */
 static inline int tracehook_unsafe_exec(struct task_struct *task)
 {
_

Patches currently in -mm which might be from oleg@redhat.com are

slow_work_thread-should-do-the-exclusive-wait.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
ptrace-remove-pt_dtrace-from-arch-h8300.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
ptrace-remove-pt_dtrace-from-m68k-m68knommu.patch
ptrace-remove-pt_dtrace-from-arch-m32r.patch
ptrace-mm_need_new_owner-use-real_parent-to-search-in-the-siblings.patch
ptrace-tracehook_unsafe_exec-remove-the-stale-comment.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
signals-tracehook_notify_jctl-change.patch

