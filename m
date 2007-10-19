From: akpm@linux-foundation.org
Subject: - pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:21:15 -0700
Message-ID: <200710190421.l9J4LF9E014769@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44402 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750759AbXJSEWV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:22:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@openvz.org, oleg@tv-sign.ru, sukadev@us.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2
has been removed from the -mm tree.  Its filename was
     pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch

This patch was dropped because it was folded into pid-namespaces-changes-to-show-virtual-ids-to-user.patch

------------------------------------------------------
Subject: pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2
From: Andrew Morton <akpm@linux-foundation.org>

mm/migrate.c: In function 'sys_move_pages':
mm/migrate.c:921: error: dereferencing pointer to incomplete type

Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/migrate.c~pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2 mm/migrate.c
--- a/mm/migrate.c~pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2
+++ a/mm/migrate.c
@@ -19,6 +19,7 @@
 #include <linux/pagemap.h>
 #include <linux/buffer_head.h>
 #include <linux/mm_inline.h>
+#include <linux/nsproxy.h>
 #include <linux/pagevec.h>
 #include <linux/rmap.h>
 #include <linux/topology.h>
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
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
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
