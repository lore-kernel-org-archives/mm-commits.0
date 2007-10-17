From: akpm@linux-foundation.org
Subject: - file-capabilities-clear-fcaps-on-inode-change-fix.patch removed from -mm tree
Date: Tue, 16 Oct 2007 18:38:03 -0700
Message-ID: <200710170138.l9H1c3U8027970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42017 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760690AbXJQBnf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 21:43:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     unexport cap_inode_killpriv
has been removed from the -mm tree.  Its filename was
     file-capabilities-clear-fcaps-on-inode-change-fix.patch

This patch was dropped because it was folded into implement-file-posix-capabilities.patch

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

origin.patch
kernel-time-timekeepingc-cleanups.patch
make-fs-libfscsimple_commit_write-static.patch
allow-disabling-dnotify-without-embedded.patch
use-erestart_restartblock-if-poll-is-interrupted-by-a-signal.patch
remove-include-asm-ipch.patch
n_hdlcc-fix-check-after-use.patch
kernel-sys_nic-add-dummy-sys_ni_syscall-prototype.patch
make-kernel-profilectime_hook-static.patch
drivers-block-ccissc-fix-check-after-use.patch
ext2-reservations.patch
bitmaph-remove-dead-artifacts.patch
implement-file-posix-capabilities.patch
file-capabilities-clear-fcaps-on-inode-change-fix.patch
security-cleanups.patch
git-alsa.patch
git-dvb.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-block.patch
drivers-net-wireless-b43-mainc-fix-an-uninitialized.patch
i386-visws-extern-inline-static-inline.patch
make-kernel-power-maincsuspend_enter-static.patch
sysctl-parport-remove-binary-paths-fix.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
memory-controller-add-per-container-lru-and-reclaim-v7-cleanup.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
alpha-lock-bitops-fix.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
remove-asm-bitopsh-includes-reiser4.patch
