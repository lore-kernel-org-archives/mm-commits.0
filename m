From: akpm@linux-foundation.org
Subject: - cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:25:00 -0700
Message-ID: <200710190425.l9J4P06x014938@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40526 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751937AbXJSEZV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:25:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mingo@elte.hu, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes.patch

This patch was dropped because it was folded into cpusets-decrustify-cpuset-mask-update-code.patch

------------------------------------------------------
Subject: cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: use tabs not spaces
#30: FILE: kernel/cpuset.c:494:
+^I    ^I$

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cpuset.c~cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes kernel/cpuset.c
--- a/kernel/cpuset.c~cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes
+++ a/kernel/cpuset.c
@@ -491,7 +491,7 @@ static int validate_change(const struct 
 	/* Cpusets with tasks can't have empty cpus_allowed or mems_allowed */
 	if (cgroup_task_count(cur->css.cgroup)) {
 		if (cpus_empty(trial->cpus_allowed) ||
-	    	    nodes_empty(trial->mems_allowed)) {
+		    nodes_empty(trial->mems_allowed)) {
 			return -ENOSPC;
 		}
 	}
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
cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes.patch
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
