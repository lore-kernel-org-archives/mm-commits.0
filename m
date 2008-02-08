From: akpm@linux-foundation.org
Subject: - add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:50:20 -0800
Message-ID: <200802080850.m188o1j6016406@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54035 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751164AbYBHIuP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:50:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, greg@kroah.com, hugh@veritas.com, rdunlap@xenotime.net, tiwai@suse.de, yi.y.yang@intel.com, mm-commits@vger.kernel.org


The patch titled
     add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2
has been removed from the -mm tree.  Its filename was
     add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch

This patch was dropped because it was folded into add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2
From: Andrew Morton <akpm@linux-foundation.org>

Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Greg KH <greg@kroah.com>
Cc: Yi Yang <yi.y.yang@intel.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/vsprintf.c~add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2 lib/vsprintf.c
--- a/lib/vsprintf.c~add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2
+++ a/lib/vsprintf.c
@@ -234,7 +234,7 @@ int strict_strto##type(const char *cp, u
 		if (ret != 0)						\
 			*res = -(*res);					\
 	} else								\
-		ret = strict_strtou##type(cp+1, base, res);		\
+		ret = strict_strtou##type(cp, base, res);		\
 									\
 	return ret;							\
 }									\
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
libfs-allow-error-return-from-simple-attributes.patch
fs-hfsplus-unicodec-fix-uninitialized-var-warning.patch
fs-afs-securityc-fix-uninitialized-var-warning.patch
mount-options-fix-tmpfs-fix.patch
char-applicom-use-pci_match_id.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch
