From: akpm@linux-foundation.org
Subject: [folded] cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time-fix.patch removed from -mm tree
Date: Wed, 23 Sep 2009 15:28:25 -0700
Message-ID: <200909232228.n8NMSPTB015061@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751014AbZIWW25 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 18:28:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, a.p.zijlstra@chello.nl, bblum@google.com, ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com, menage@google.com, mingo@elte.hu, oleg@redhat.com


The patch titled
     cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time-fix
has been removed from the -mm tree.  Its filename was
     cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time-fix.patch

This patch was dropped because it was folded into cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time-fix
From: Dave Young <hidave.darkstar@gmail.com>

kernel/sched.c:10452: error: expected ';', ',' or ')' before 'bool'
kernel/sched.c:10536: error: 'cpu_cgroup_attach' undeclared here (not in a function)

Cc: Ben Blum <bblum@google.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched.c~cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time-fix kernel/sched.c
--- a/kernel/sched.c~cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time-fix
+++ a/kernel/sched.c
@@ -10446,7 +10446,7 @@ cpu_cgroup_can_attach(struct cgroup_subs
 
 static void
 cpu_cgroup_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
-		  struct cgroup *old_cont, struct task_struct *tsk
+		  struct cgroup *old_cont, struct task_struct *tsk,
 		  bool threadgroup)
 {
 	sched_move_task(tsk);
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

origin.patch
cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time.patch
cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time-fix.patch
pc-fs-char_devc-remove-useless-loop-fix.patch

