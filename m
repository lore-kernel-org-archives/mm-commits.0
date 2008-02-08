From: akpm@linux-foundation.org
Subject: - ufs-fix-symlink-creation-on-ufs2-fix.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:46:25 -0800
Message-ID: <200802080846.m188k6Pj016232@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39193 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758053AbYBHIqn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:46:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dushistov@mail.ru, stevenaaus@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     ufs-fix-symlink-creation-on-ufs2-fix
has been removed from the -mm tree.  Its filename was
     ufs-fix-symlink-creation-on-ufs2-fix.patch

This patch was dropped because it was folded into ufs-fix-symlink-creation-on-ufs2.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ufs-fix-symlink-creation-on-ufs2-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Steven <stevenaaus@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ufs/super.c~ufs-fix-symlink-creation-on-ufs2-fix fs/ufs/super.c
--- a/fs/ufs/super.c~ufs-fix-symlink-creation-on-ufs2-fix
+++ a/fs/ufs/super.c
@@ -132,7 +132,7 @@ static void ufs_print_super_stuff(struct
 		       (unsigned long long)
 		       fs64_to_cpu(sb, usb3->fs_un1.fs_u2.cs_nffree));
 		printk(KERN_INFO"  fs_maxsymlinklen: %u\n",
-		       usb3->fs_un2.fs_44.fs_maxsymlinklen);
+		       fs32_to_cpu(sb, usb3->fs_un2.fs_44.fs_maxsymlinklen));
 	} else {
 		printk(" sblkno:      %u\n", fs32_to_cpu(sb, usb1->fs_sblkno));
 		printk(" cblkno:      %u\n", fs32_to_cpu(sb, usb1->fs_cblkno));
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
mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch
rewrite-rd.patch
fs-remove-fastcall-it-is-always-empty.patch
kernel-remove-fastcall-in-kernel.patch
lib-remove-fastcall-from-lib.patch
remove-fastcall-from-linux-include.patch
constify-tables-in-kernel-sysctl_checkc.patch
aoe-statically-initialise-devlist_lock.patch
ufs-fix-symlink-creation-on-ufs2.patch
ufs-fix-symlink-creation-on-ufs2-fix.patch
libfs-allow-error-return-from-simple-attributes-fix.patch
fs-hfsplus-unicodec-fix-uninitialized-var-warning.patch
fs-afs-securityc-fix-uninitialized-var-warning.patch
mount-options-fix-tmpfs-fix.patch
char-applicom-use-pci_match_id-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch
