From: akpm@linux-foundation.org
Subject: - cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-fix.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:22:07 -0700
Message-ID: <200807250022.m6P0M73h013948@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752022AbYGYAWa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:22:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balbir@in.ibm.com, danms@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, serge@us.ibm.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-fix
has been removed from the -mm tree.  Its filename was
     cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-fix.patch

This patch was dropped because it was folded into cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-fix
From: Andrew Morton <akpm@linux-foundation.org>

kernel/ns_cgroup.c: In function 'ns_cgroup_clone':
kernel/ns_cgroup.c:29: error: 'PROC_NUMBUF' undeclared (first use in this function)
kernel/ns_cgroup.c:29: error: (Each undeclared identifier is reported only once
kernel/ns_cgroup.c:29: error: for each function it appears in.)
kernel/ns_cgroup.c:29: warning: unused variable 'name'


Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Dan Smith <danms@us.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Serge Hallyn <serge@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ns_cgroup.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/ns_cgroup.c~cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-fix kernel/ns_cgroup.c
--- a/kernel/ns_cgroup.c~cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-fix
+++ a/kernel/ns_cgroup.c
@@ -7,6 +7,7 @@
 #include <linux/module.h>
 #include <linux/cgroup.h>
 #include <linux/fs.h>
+#include <linux/proc_fs.h>
 #include <linux/slab.h>
 #include <linux/nsproxy.h>
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm.patch
build-kernel-profileo-only-when-requested-cleanups.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
exec-remove-some-includes.patch
inflate-refactor-inflate-malloc-code.patch
drivers-misc-hpiloc-needs-config_pci.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
gpio-sysfs-interface-updated.patch
gpio-add-bt8xxgpio-driver.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction.patch
ext3-handle-corrupted-orphan-list-at-mount.patch
ext3-handle-deleting-corrupted-indirect-blocks.patch
jbd-dont-abort-if-flushing-file-data-failed.patch
reiserfs-convert-j_flush_sem-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex.patch
quota-move-function-macros-from-quotah-to-quotaopsh.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-fix.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-checkpatch-fixes.patch
devcgroup-code-cleanup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-limit-change-shrink-usage-checkpatch-fixes.patch
coredump-format_corename-fix-the-core_uses_pid-logic-checkpatch-fixes.patch
workqueues-make-get_online_cpus-useable-for-work-func-fix.patch
ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-rewrite-undo-list-locking-checkpatch-fixes.patch
fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch
block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
edac-mpc85xx-fix-pci-ofdev-2nd-pass-checkpatch-fixes.patch

