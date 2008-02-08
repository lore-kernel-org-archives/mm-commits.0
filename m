From: akpm@linux-foundation.org
Subject: - proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-3.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:33:01 -0800
Message-ID: <200802080832.m188WgnE015727@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48847 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761291AbYBHIco (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:32:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-3
has been removed from the -mm tree.  Its filename was
     proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-3.patch

This patch was dropped because it was folded into proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-3
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/array.c~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-3 fs/proc/array.c
--- a/fs/proc/array.c~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-3
+++ a/fs/proc/array.c
@@ -98,9 +98,9 @@ static inline void task_name(struct seq_
 
 	get_task_comm(tcomm, p);
 
+	seq_printf(m, "Name:\t");
 	end = m->buf + m->size;
 	buf = m->buf + m->count;
-	seq_printf(m, "Name:\n");
 	name = tcomm;
 	i = sizeof(tcomm);
 	while (i && (buf < end)) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option.patch
proc-detect-duplicate-names-on-registration.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
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
