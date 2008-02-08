From: akpm@linux-foundation.org
Subject: - constify-tables-in-kernel-sysctl_checkc-fix.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:45:31 -0800
Message-ID: <200802080845.m188jCZa016220@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57176 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757980AbYBHIqI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:46:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davej@codemonkey.org.uk, ebiederm@xmission.com, jbeulich@novell.com, mm-commits@vger.kernel.org


The patch titled
     constify-tables-in-kernel-sysctl_checkc-fix
has been removed from the -mm tree.  Its filename was
     constify-tables-in-kernel-sysctl_checkc-fix.patch

This patch was dropped because it was folded into constify-tables-in-kernel-sysctl_checkc.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: constify-tables-in-kernel-sysctl_checkc-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl_check.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sysctl_check.c~constify-tables-in-kernel-sysctl_checkc-fix kernel/sysctl_check.c
--- a/kernel/sysctl_check.c~constify-tables-in-kernel-sysctl_checkc-fix
+++ a/kernel/sysctl_check.c
@@ -423,7 +423,7 @@ static const struct trans_ctl_table tran
 	{}
 };
 
-static const struct trans_ctl_table trans_net_ax25_table[] = {
+static const struct trans_ctl_table trans_net_ax25_param_table[] = {
 	{ NET_AX25_IP_DEFAULT_MODE,	"ip_default_mode" },
 	{ NET_AX25_DEFAULT_MODE,	"ax25_default_mode" },
 	{ NET_AX25_BACKOFF_TYPE,	"backoff_type" },
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
