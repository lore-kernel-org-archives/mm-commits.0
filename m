From: akpm@linux-foundation.org
Subject: - remove-bits_to_type-macro-fix.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:26:10 -0700
Message-ID: <200710190426.l9J4QAOt014960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50478 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750757AbXJSE0N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:26:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     remove-bits_to_type-macro-fix
has been removed from the -mm tree.  Its filename was
     remove-bits_to_type-macro-fix.patch

This patch was dropped because it was folded into remove-bits_to_type-macro.patch

------------------------------------------------------
Subject: remove-bits_to_type-macro-fix
From: Andrew Morton <akpm@linux-foundation.org>

In file included from drivers/ieee1394/nodemgr.c:11:
include/linux/bitmap.h: In function 'bitmap_zero':
include/linux/bitmap.h:137: error: implicit declaration of function 'DIV_ROUND_UP'

Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/bitops.h~remove-bits_to_type-macro-fix include/linux/bitops.h
diff -puN include/linux/bitmap.h~remove-bits_to_type-macro-fix include/linux/bitmap.h
--- a/include/linux/bitmap.h~remove-bits_to_type-macro-fix
+++ a/include/linux/bitmap.h
@@ -6,6 +6,7 @@
 #include <linux/types.h>
 #include <linux/bitops.h>
 #include <linux/string.h>
+#include <linux/kernel.h>
 
 /*
  * bitmaps provide bit arrays that consume one or more unsigned
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
