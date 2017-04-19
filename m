From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Wed, 19 Apr 2017 13:41:04 -0700
Message-ID: <20170419204104.CIi7lMgQP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47908 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1765568AbdDSUlG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Apr 2017 16:41:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/trace.h |    8 --------
 1 file changed, 8 deletions(-)

diff -puN kernel/trace/trace.h~linux-next-git-rejects kernel/trace/trace.h
--- a/kernel/trace/trace.h~linux-next-git-rejects
+++ a/kernel/trace/trace.h
@@ -896,11 +896,7 @@ int using_ftrace_ops_list_func(void);
 void ftrace_init_tracefs(struct trace_array *tr, struct dentry *d_tracer);
 void ftrace_init_tracefs_toplevel(struct trace_array *tr,
 				  struct dentry *d_tracer);
-<<<<<<< HEAD
-void ftrace_clear_pids(struct trace_array *tr);
-=======
 int init_function_trace(void);
->>>>>>> linux-next/akpm-base
 #else
 static inline int ftrace_trace_task(struct trace_array *tr)
 {
@@ -919,11 +915,7 @@ ftrace_init_global_array_ops(struct trac
 static inline void ftrace_reset_array_ops(struct trace_array *tr) { }
 static inline void ftrace_init_tracefs(struct trace_array *tr, struct dentry *d) { }
 static inline void ftrace_init_tracefs_toplevel(struct trace_array *tr, struct dentry *d) { }
-<<<<<<< HEAD
-static inline void ftrace_clear_pids(struct trace_array *tr) { }
-=======
 static inline int init_function_trace(void) { return 0; }
->>>>>>> linux-next/akpm-base
 /* ftace_func_t type is not defined, use macro instead of static inline */
 #define ftrace_init_array_ops(tr, func) do { } while (0)
 #endif /* CONFIG_FUNCTION_TRACER */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes.patch
mm-use-is_migrate_highatomic-to-simplify-the-code-fix.patch
mm-introduce-memalloc_nofs_saverestore-api-fix.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes.patch
mm-page_alloc-count-movable-pages-when-stealing-from-pageblock-fix.patch
swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
linux-next-rejects.patch
drm-use-set_memoryh-header-fix.patch
drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch
docs-vm-transhuge-fix-few-trivial-typos-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

