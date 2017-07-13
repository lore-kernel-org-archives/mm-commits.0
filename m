From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
Date: Thu, 13 Jul 2017 13:37:09 -0700
Message-ID: <20170713203709.U3mrtL7EK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58706 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753095AbdGMUhL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:37:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc.h |    2 +-
 include/linux/sem.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/ipc.h~linux-next-rejects include/linux/ipc.h
--- a/include/linux/ipc.h~linux-next-rejects
+++ a/include/linux/ipc.h
@@ -23,6 +23,6 @@ struct kern_ipc_perm {
 
 	struct rcu_head rcu;
 	atomic_t refcount;
-} ____cacheline_aligned_in_smp;
+} ____cacheline_aligned_in_smp __randomize_layout;
 
 #endif /* _LINUX_IPC_H */
diff -puN include/linux/sem.h~linux-next-rejects include/linux/sem.h
--- a/include/linux/sem.h~linux-next-rejects
+++ a/include/linux/sem.h
@@ -41,7 +41,7 @@ struct sem_array {
 	unsigned int		use_global_lock;/* >0: global lock required */
 
 	struct sem		sems[];
-};
+} __randomize_layout;
 
 #ifdef CONFIG_SYSVIPC
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

