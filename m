From: akpm@linux-foundation.org
Subject: - fix-cpusets-update_cpumask-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:25:27 -0700
Message-ID: <200710190425.l9J4PRWU014948@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39882 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974AbXJSEZt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:25:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, balbir@in.ibm.com, clg@fr.ibm.com, ebiederm@xmission.com, menage@google.com, nickpiggin@yahoo.com.au, pj@sgi.com, rientjes@google.co


The patch titled
     fix-cpusets-update_cpumask-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     fix-cpusets-update_cpumask-checkpatch-fixes.patch

This patch was dropped because it was folded into fix-cpusets-update_cpumask.patch

------------------------------------------------------
Subject: fix-cpusets-update_cpumask-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: inline keyword should sit between storage class and type
#114: FILE: kernel/cpuset.c:690:
+static int inline started_after_time(struct task_struct *t1,

ERROR: inline keyword should sit between storage class and type
#137: FILE: kernel/cpuset.c:713:
+static int inline started_after(void *p1, void *p2)

total: 2 errors, 0 warnings, 292 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Paul Jackson <pj@sgi.com>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/cpuset.c~fix-cpusets-update_cpumask-checkpatch-fixes kernel/cpuset.c
--- a/kernel/cpuset.c~fix-cpusets-update_cpumask-checkpatch-fixes
+++ a/kernel/cpuset.c
@@ -687,7 +687,7 @@ done:
 	/* Don't kfree(doms) -- partition_sched_domains() does that. */
 }
 
-static int inline started_after_time(struct task_struct *t1,
+static inline int started_after_time(struct task_struct *t1,
 				     struct timespec *time,
 				     struct task_struct *t2)
 {
@@ -710,7 +710,7 @@ static int inline started_after_time(str
 	}
 }
 
-static int inline started_after(void *p1, void *p2)
+static inline int started_after(void *p1, void *p2)
 {
 	struct task_struct *t1 = p1;
 	struct task_struct *t2 = p2;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
console-keyboard-events-and-accessibility.patch
add-kernel-notifierc.patch
console-events-and-accessibility.patch
fix-random-hard-freeze-with-avm-cards-using-b1dma.patch
jbd-config_jbd_debug-cannot-create-proc-entry.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
add-containerstats-v3.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
cpuset-sched_load_balance-flag.patch
cpusets-decrustify-cpuset-mask-update-code.patch
fix-cpusets-update_cpumask.patch
fix-cpusets-update_cpumask-checkpatch-fixes.patch
remove-bits_to_type-macro-fix.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified-checkpatch-fixes.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix-2.patch
use-extended-crashkernel-command-line-on-i386.patch
hook-up-group-scheduler-with-control-groups-fix.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
uninline-forkc-exitc-checkpatch-fixes.patch
