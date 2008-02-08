From: akpm@linux-foundation.org
Subject: - intel-iommu-fault_reason_index_cleanuppatch-fix.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:35:59 -0800
Message-ID: <200802080835.m188Zfvr015853@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45909 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757148AbYBHIft (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:35:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgross@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     intel-iommu-fault_reason_index_cleanuppatch-fix
has been removed from the -mm tree.  Its filename was
     intel-iommu-fault_reason_index_cleanuppatch-fix.patch

This patch was dropped because it was folded into intel-iommu-fault_reason_index_cleanuppatch.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: intel-iommu-fault_reason_index_cleanuppatch-fix
From: Andrew Morton <akpm@linux-foundation.org>

We normally leave those commas there, to make add-a-new-entry patches look
cleaner and smaller.  Plus it shrinks
intel-iommu-fault_reason_index_cleanuppatch.patch, too.

Cc: mark gross <mgross@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/intel-iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pci/intel-iommu.c~intel-iommu-fault_reason_index_cleanuppatch-fix drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~intel-iommu-fault_reason_index_cleanuppatch-fix
+++ a/drivers/pci/intel-iommu.c
@@ -759,7 +759,7 @@ static const char *fault_reason_strings[
 	"Context table ptr is invalid",
 	"non-zero reserved fields in RTP",
 	"non-zero reserved fields in CTP",
-	"non-zero reserved fields in PTE"
+	"non-zero reserved fields in PTE",
 };
 #define MAX_FAULT_REASON_IDX 	(ARRAY_SIZE(fault_reason_strings) - 1)
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option.patch
proc-detect-duplicate-names-on-registration.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-fix-openless-usage-due-to-proc_fops-flip.patch
intel-iommu-fault_reason_index_cleanuppatch.patch
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
