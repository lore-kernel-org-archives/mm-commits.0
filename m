From: akpm@linux-foundation.org
Subject: - cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:31:32 -0800
Message-ID: <200802080831.m188VDxr015677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42943 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760484AbYBHIbR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:31:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch

This patch was dropped because it was folded into cleanup-the-code-managed-with-pid_ns-option.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: no space between function name and open parenthesis '('
#371: FILE: kernel/pid_namespace.c:40:
+	list_for_each_entry (pcache, &pid_caches_lh, list)

WARNING: line over 80 characters
#449: FILE: kernel/pid_namespace.c:118:
+struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *old_ns)

total: 0 errors, 2 warnings, 475 lines checked

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/pid_namespace.c~cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes
+++ a/kernel/pid_namespace.c
@@ -37,7 +37,7 @@ static struct kmem_cache *create_pid_cac
 	struct kmem_cache *cachep;
 
 	mutex_lock(&pid_caches_mutex);
-	list_for_each_entry (pcache, &pid_caches_lh, list)
+	list_for_each_entry(pcache, &pid_caches_lh, list)
 		if (pcache->nr_ids == nr_ids)
 			goto out;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch
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
