From: akpm@linux-foundation.org
Subject: - hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:27:42 -0700
Message-ID: <200710190427.l9J4RgUq014987@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56458 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752176AbXJSE2P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:28:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, clameter@sgi.com, cpw@sgi.com, mingo@elte.hu, oleg@tv-sign.ru, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     hotplug-cpu-migrate-a-task-within-its-cpuset-fix
has been removed from the -mm tree.  Its filename was
     hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch

This patch was dropped because it was folded into hotplug-cpu-migrate-a-task-within-its-cpuset.patch

------------------------------------------------------
Subject: hotplug-cpu-migrate-a-task-within-its-cpuset-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Christoph Lameter <clameter@sgi.com>
Cc: Cliff Wickman <cpw@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched.c~hotplug-cpu-migrate-a-task-within-its-cpuset-fix kernel/sched.c
--- a/kernel/sched.c~hotplug-cpu-migrate-a-task-within-its-cpuset-fix
+++ a/kernel/sched.c
@@ -5033,7 +5033,7 @@ static void move_task_off_dead_cpu(int d
 
 		/* No more Mr. Nice Guy. */
 		if (dest_cpu == NR_CPUS) {
-		cpumask_t cpus_allowed = cpuset_cpus_allowed_locked();
+		cpumask_t cpus_allowed = cpuset_cpus_allowed_locked(p);
 		/*
 		 * Try to stay on the same cpuset, where the current cpuset
 		 * may be a subset of all cpus.
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
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified-checkpatch-fixes.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix-2.patch
use-extended-crashkernel-command-line-on-i386.patch
hook-up-group-scheduler-with-control-groups-fix.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
uninline-forkc-exitc-checkpatch-fixes.patch
