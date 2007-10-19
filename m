From: akpm@linux-foundation.org
Subject: - fix-random-hard-freeze-with-avm-cards-using-b1dma-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:08:05 -0700
Message-ID: <200710190408.l9J485Op014205@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57631 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751102AbXJSEIK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:08:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     fix-random-hard-freeze-with-avm-cards-using-b1dma-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     fix-random-hard-freeze-with-avm-cards-using-b1dma-checkpatch-fixes.patch

This patch was dropped because it was folded into fix-random-hard-freeze-with-avm-cards-using-b1dma.patch

------------------------------------------------------
Subject: fix-random-hard-freeze-with-avm-cards-using-b1dma-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: use tabs not spaces
#88: FILE: drivers/isdn/hardware/avm/b1dma.c:842:
+ ^I^Iunsigned long flags;$

total: 1 errors, 0 warnings, 76 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hardware/avm/b1dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/isdn/hardware/avm/b1dma.c~fix-random-hard-freeze-with-avm-cards-using-b1dma-checkpatch-fixes drivers/isdn/hardware/avm/b1dma.c
--- a/drivers/isdn/hardware/avm/b1dma.c~fix-random-hard-freeze-with-avm-cards-using-b1dma-checkpatch-fixes
+++ a/drivers/isdn/hardware/avm/b1dma.c
@@ -839,7 +839,7 @@ u16 b1dma_send_message(struct capi_ctr *
 	u16 retval = CAPI_NOERROR;
 
  	if (CAPIMSG_CMD(skb->data) == CAPI_DATA_B3_REQ) {
- 		unsigned long flags;
+		unsigned long flags;
 		spin_lock_irqsave(&card->lock, flags);
 		retval = capilib_data_b3_req(&cinfo->ncci_head,
 					     CAPIMSG_APPID(skb->data),
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
console-keyboard-events-and-accessibility.patch
add-kernel-notifierc.patch
console-events-and-accessibility.patch
fix-random-hard-freeze-with-avm-cards-using-b1dma.patch
fix-random-hard-freeze-with-avm-cards-using-b1dma-checkpatch-fixes.patch
jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch
task-containersv11-basic-task-container-framework-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-simplify-proc-cgroups-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
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
