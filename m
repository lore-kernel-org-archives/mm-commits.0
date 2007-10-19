From: akpm@linux-foundation.org
Subject: - lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 18 Oct 2007 22:07:32 -0700
Message-ID: <200710190507.l9J57W2D016512@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53346 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752748AbXJSFOA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 01:14:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, ghaskins@novell.com, mingo@elte.hu, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch

This patch was dropped because it was folded into workqueue-debug-flushing-deadlocks-with-lockdep.patch

------------------------------------------------------
Subject: lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: use tabs not spaces
#29: FILE: kernel/lockdep.c:1524:
+^I       ^I$

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.


Cc: <stable@kernel.org>
Cc: Gregory Haskins <ghaskins@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN kernel/lockdep.c~lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes
+++ a/kernel/lockdep.c
@@ -1521,7 +1521,7 @@ cache_hit:
 }
 
 static int validate_chain(struct task_struct *curr, struct lockdep_map *lock,
-	       	struct held_lock *hlock, int chain_head, u64 chain_key)
+		struct held_lock *hlock, int chain_head, u64 chain_key)
 {
 	/*
 	 * Trylock needs to maintain the stack of held locks, but it
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
workqueue-debug-flushing-deadlocks-with-lockdep.patch
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
linux-kernel-markers.patch
linux-kernel-markers-samples.patch
uninline-forkc-exitc.patch
