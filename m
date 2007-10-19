From: akpm@linux-foundation.org
Subject: - hook-up-group-scheduler-with-control-groups-fix.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:34:29 -0700
Message-ID: <200710190434.l9J4YTo4015358@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47129 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752555AbXJSEfD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:35:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balbir@in.ibm.com, dhaval@linux.vnet.ibm.com, menage@google.com, mingo@elte.hu, randy.dunlap@oracle.com, vatsa@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     hook-up-group-scheduler-with-control-groups-fix
has been removed from the -mm tree.  Its filename was
     hook-up-group-scheduler-with-control-groups-fix.patch

This patch was dropped because it was folded into hook-up-group-scheduler-with-control-groups.patch

------------------------------------------------------
Subject: hook-up-group-scheduler-with-control-groups-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Menage <menage@google.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched.c~hook-up-group-scheduler-with-control-groups-fix kernel/sched.c
--- a/kernel/sched.c~hook-up-group-scheduler-with-control-groups-fix
+++ a/kernel/sched.c
@@ -204,7 +204,7 @@ static inline struct task_group *task_gr
 
 #ifdef CONFIG_FAIR_USER_SCHED
 	tg = p->user->tg;
-#elif CONFIG_FAIR_CGROUP_SCHED
+#elif defined(CONFIG_FAIR_CGROUP_SCHED)
 	tg = container_of(task_subsys_state(p, cpu_cgroup_subsys_id),
 				struct task_group, css);
 #else
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
remove-bits_to_type-macro.patch
use-helpers-to-obtain-task-pid-in-printks.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified.patch
ipc-integrate-ipc_checkid-into-ipc_lock.patch
hook-up-group-scheduler-with-control-groups.patch
hook-up-group-scheduler-with-control-groups-fix.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
uninline-forkc-exitc-checkpatch-fixes.patch
