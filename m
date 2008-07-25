From: akpm@linux-foundation.org
Subject: - quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix-fix.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:19:34 -0700
Message-ID: <200807250019.m6P0JYHi013799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752915AbYGYATi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:19:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix-fix
has been removed from the -mm tree.  Its filename was
     quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix-fix.patch

This patch was dropped because it was folded into quota-move-function-macros-from-quotah-to-quotaopsh.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/super.c |    1 +
 fs/ufs/super.c      |    1 +
 2 files changed, 2 insertions(+)

diff -puN fs/reiserfs/super.c~quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix-fix fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix-fix
+++ a/fs/reiserfs/super.c
@@ -22,6 +22,7 @@
 #include <linux/blkdev.h>
 #include <linux/buffer_head.h>
 #include <linux/exportfs.h>
+#include <linux/quotaops.h>
 #include <linux/vfs.h>
 #include <linux/mnt_namespace.h>
 #include <linux/mount.h>
diff -puN fs/ufs/super.c~quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix-fix fs/ufs/super.c
--- a/fs/ufs/super.c~quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix-fix
+++ a/fs/ufs/super.c
@@ -76,6 +76,7 @@
 
 #include <linux/errno.h>
 #include <linux/fs.h>
+#include <linux/quotaops.h>
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/stat.h>
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
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix-fix.patch
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

