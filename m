From: akpm@linux-foundation.org
Subject: - devcgroup-code-cleanup-fix.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:22:53 -0700
Message-ID: <200807250022.m6P0MrWT013964@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752865AbYGYAXJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:23:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, lizf@cn.fujitsu.com, menage@google.com, serue@us.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     devcgroup-code-cleanup-fix
has been removed from the -mm tree.  Its filename was
     devcgroup-code-cleanup-fix.patch

This patch was dropped because it was folded into devcgroup-code-cleanup.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devcgroup-code-cleanup-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/device_cgroup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN security/device_cgroup.c~devcgroup-code-cleanup-fix security/device_cgroup.c
--- a/security/device_cgroup.c~devcgroup-code-cleanup-fix
+++ a/security/device_cgroup.c
@@ -394,7 +394,7 @@ static int devcgroup_update_access(struc
 		wh.major = ~0;
 		b++;
 	} else if (isdigit(*b)) {
-		wh.major = simple_strtoul(b, &b, 0);
+		wh.major = simple_strtoul(b, &b, 10);
 	} else {
 		return -EINVAL;
 	}
@@ -407,7 +407,7 @@ static int devcgroup_update_access(struc
 		wh.minor = ~0;
 		b++;
 	} else if (isdigit(*b)) {
-		wh.minor = simple_strtoul(b, &b, 0);
+		wh.minor = simple_strtoul(b, &b, 10);
 	} else {
 		return -EINVAL;
 	}
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
devcgroup-code-cleanup.patch
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

