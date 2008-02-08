From: akpm@linux-foundation.org
Subject: - proc-detect-duplicate-names-on-registration-fix.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:31:52 -0800
Message-ID: <200802080831.m188VX5Y015685@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44493 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757825AbYBHIcW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:32:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@sw.ru, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     proc-detect-duplicate-names-on-registration-fix
has been removed from the -mm tree.  Its filename was
     proc-detect-duplicate-names-on-registration-fix.patch

This patch was dropped because it was folded into proc-detect-duplicate-names-on-registration.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc-detect-duplicate-names-on-registration-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/generic.c~proc-detect-duplicate-names-on-registration-fix fs/proc/generic.c
--- a/fs/proc/generic.c~proc-detect-duplicate-names-on-registration-fix
+++ a/fs/proc/generic.c
@@ -548,8 +548,8 @@ static int proc_register(struct proc_dir
 
 	for (tmp = dir->subdir; tmp; tmp = tmp->next)
 		if (strcmp(tmp->name, dp->name) == 0) {
-			printk(KERN_WARNING "PDE '%s' already registered\n",
-				dp->name);
+			printk(KERN_WARNING "proc_dir_entry '%s' already "
+					"registered\n", dp->name);
 			dump_stack();
 			break;
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option.patch
proc-detect-duplicate-names-on-registration.patch
proc-detect-duplicate-names-on-registration-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-3.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix.patch
proc-fix-openless-usage-due-to-proc_fops-flip-checkpatch-fixes.patch
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
modules-make-module_address_lookup-safe-fix.patch
wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace-fix.patch
pid-sys_wait-fixes-v2-checkpatch-fixes.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
rewrite-rd-fixes.patch
fs-remove-fastcall-it-is-always-empty-checkpatch-fixes.patch
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
lib-remove-fastcall-from-lib-checkpatch-fixes.patch
remove-fastcall-from-linux-include-checkpatch-fixes.patch
constify-tables-in-kernel-sysctl_checkc-fix.patch
aoe-statically-initialise-devlist_lock.patch
ufs-fix-symlink-creation-on-ufs2-fix.patch
libfs-allow-error-return-from-simple-attributes-fix.patch
fs-hfsplus-unicodec-fix-uninitialized-var-warning.patch
fs-afs-securityc-fix-uninitialized-var-warning.patch
mount-options-fix-tmpfs-fix.patch
char-applicom-use-pci_match_id-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch
