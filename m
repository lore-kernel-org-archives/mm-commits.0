From: akpm@linux-foundation.org
Subject: - cpuset-sched_load_balance-flag-fix.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:24:27 -0700
Message-ID: <200710190424.l9J4ORws014924@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33646 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750886AbXJSEYl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:24:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mingo@elte.hu, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     cpuset-sched_load_balance-flag-fix
has been removed from the -mm tree.  Its filename was
     cpuset-sched_load_balance-flag-fix.patch

This patch was dropped because it was folded into cpuset-sched_load_balance-flag.patch

------------------------------------------------------
Subject: cpuset-sched_load_balance-flag-fix
From: Andrew Morton <akpm@linux-foundation.org>

don't be weird

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/sched.c~cpuset-sched_load_balance-flag-fix kernel/sched.c
--- a/kernel/sched.c~cpuset-sched_load_balance-flag-fix
+++ a/kernel/sched.c
@@ -6270,7 +6270,8 @@ void partition_sched_domains(int ndoms_n
 		}
 		/* no match - a current sched domain not in new doms_new[] */
 		detach_destroy_domains(doms_cur + i);
-match1:;
+match1:
+		;
 	}
 
 	/* Build new domains */
@@ -6281,7 +6282,8 @@ match1:;
 		}
 		/* no match - add a new doms_new */
 		build_sched_domains(doms_new + i);
-match2:;
+match2:
+		;
 	}
 
 	/* Remember the new sched domains */
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
cpuset-sched_load_balance-flag-fix.patch
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
