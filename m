From: akpm@linux-foundation.org
Subject: - ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:29:43 -0700
Message-ID: <200710190429.l9J4ThGB015126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59348 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966388AbXJSEaS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:30:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Nadia.Derbey@bull.net, mm-commits@vger.kernel.org


The patch titled
     ipc-integrate-ipc_checkid-into-ipc_lock-fix
has been removed from the -mm tree.  Its filename was
     ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch

This patch was dropped because it was folded into ipc-integrate-ipc_checkid-into-ipc_lock.patch

------------------------------------------------------
Subject: ipc-integrate-ipc_checkid-into-ipc_lock-fix
From: Andrew Morton <akpm@linux-foundation.org>

ipc/util.h: In function 'ipc_lock_check':
ipc/util.h:157: error: implicit declaration of function 'IS_ERR'
ipc/util.h:162: error: implicit declaration of function 'ERR_PTR'
ipc/util.h:162: warning: return makes pointer from integer without a cast

Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN ipc/util.h~ipc-integrate-ipc_checkid-into-ipc_lock-fix ipc/util.h
--- a/ipc/util.h~ipc-integrate-ipc_checkid-into-ipc_lock-fix
+++ a/ipc/util.h
@@ -11,6 +11,7 @@
 #define _IPC_UTIL_H
 
 #include <linux/idr.h>
+#include <linux/err.h>
 
 #define USHRT_MAX 0xffff
 #define SEQ_MULTIPLIER	(IPCMNI)
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
ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix-2.patch
use-extended-crashkernel-command-line-on-i386.patch
hook-up-group-scheduler-with-control-groups-fix.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
uninline-forkc-exitc-checkpatch-fixes.patch
