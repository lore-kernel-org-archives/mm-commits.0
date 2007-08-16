From: akpm@linux-foundation.org
Subject: + file-capabilities-clear-fcaps-on-inode-change-fix.patch added to -mm tree
Date: Thu, 16 Aug 2007 14:05:22 -0700
Message-ID: <200708162105.l7GL5M5m006688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56850 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758348AbXHPVFt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Aug 2007 17:05:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, serue@us.ibm.com


The patch titled
     unexport cap_inode_killpriv
has been added to the -mm tree.  Its filename is
     file-capabilities-clear-fcaps-on-inode-change-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: unexport cap_inode_killpriv
From: Adrian Bunk <bunk@kernel.org>

This patch removes the unused EXPORT_SYMBOL(cap_inode_killpriv).

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/commoncap.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN security/commoncap.c~file-capabilities-clear-fcaps-on-inode-change-fix security/commoncap.c
--- a/security/commoncap.c~file-capabilities-clear-fcaps-on-inode-change-fix
+++ a/security/commoncap.c
@@ -542,7 +542,6 @@ EXPORT_SYMBOL(cap_bprm_apply_creds);
 EXPORT_SYMBOL(cap_bprm_secureexec);
 EXPORT_SYMBOL(cap_inode_setxattr);
 EXPORT_SYMBOL(cap_inode_removexattr);
-EXPORT_SYMBOL(cap_inode_killpriv);
 EXPORT_SYMBOL(cap_task_post_setuid);
 EXPORT_SYMBOL(cap_task_kill);
 EXPORT_SYMBOL(cap_task_setscheduler);
_

Patches currently in -mm which might be from bunk@kernel.org are

pass-g-to-assembler-under-config_debug_info-fix.patch
alpm-enable-link-power-management-for-ata-drivers-make-drivers-ata-libata-scsicata_scsi_link_pm_policy-static.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
fix-ide-ide-remove-ide-dma-check.patch
drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch
file-capabilities-clear-fcaps-on-inode-change-fix.patch
kconfig-syntax-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
make-fs-libfscsimple_commit_write-static.patch
remove-fs-ext2-balloccreserve_blocks.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
