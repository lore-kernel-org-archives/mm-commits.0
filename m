From: akpm@linux-foundation.org
Subject: - aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:42:03 -0800
Message-ID: <200802080841.m188fiBe016059@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37890 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752310AbYBHImv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:42:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix
has been removed from the -mm tree.  Its filename was
     aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch

This patch was dropped because it was folded into aout-remove-unnecessary-inclusions-of-asm-linux-aouth.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix
From: Andrew Morton <akpm@linux-foundation.org>

alpha allnoconfig:

fs/exec.c: In function 'search_binary_handler':
fs/exec.c:1191: error: dereferencing pointer to incomplete type
fs/exec.c:1192: error: dereferencing pointer to incomplete type
fs/exec.c:1209: error: dereferencing pointer to incomplete type

for struct exec.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/exec.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix fs/exec.c
--- a/fs/exec.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix
+++ a/fs/exec.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <linux/file.h>
 #include <linux/mman.h>
+#include <linux/a.out.h>
 #include <linux/stat.h>
 #include <linux/fcntl.h>
 #include <linux/smp_lock.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option.patch
proc-detect-duplicate-names-on-registration.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-fix-openless-usage-due-to-proc_fops-flip.patch
intel-iommu-fault_reason_index_cleanuppatch.patch
modules-make-module_address_lookup-safe-fix.patch
wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace.patch
pid-sys_wait-fixes-v2.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth.patch
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
