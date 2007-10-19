From: akpm@linux-foundation.org
Subject: - git-nfs-vs-git-unionfs.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:39:08 -0700
Message-ID: <200710190439.l9J4d8E1015560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53300 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934221AbXJSEj1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:39:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jsipek@cs.sunysb.edu, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     git-nfs-vs-git-unionfs
has been removed from the -mm tree.  Its filename was
     git-nfs-vs-git-unionfs.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-nfs-vs-git-unionfs
From: Andrew Morton <akpm@linux-foundation.org>

Put this back - unionfs uses it.

Please don't commit unreviewed VFS patches to fs-specific trees.

Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/writeback.h~git-nfs-vs-git-unionfs include/linux/writeback.h
--- a/include/linux/writeback.h~git-nfs-vs-git-unionfs
+++ a/include/linux/writeback.h
@@ -63,6 +63,7 @@ struct writeback_control {
 	unsigned for_writepages:1;	/* This is a writepages() call */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned more_io:1;		/* more io to be dispatched */
+	void *fs_private;               /* For use by ->writepages() */
 };
 
 /*
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
linux-kernel-markers.patch
linux-kernel-markers-samples.patch
uninline-forkc-exitc.patch
