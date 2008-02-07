From: akpm@linux-foundation.org
Subject: - kernel-ptracec-should-include-linux-syscallsh.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:21:50 -0800
Message-ID: <200802070021.m170LVlo006344@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48618 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932969AbYBGAo0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     kernel/ptrace.c should #include <linux/syscalls.h>
has been removed from the -mm tree.  Its filename was
     kernel-ptracec-should-include-linux-syscallsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/ptrace.c should #include <linux/syscalls.h>
From: Adrian Bunk <bunk@kernel.org>

Every file should include the headers containing the prototypes for its global
functions (in this case sys_ptrace()).

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/ptrace.c~kernel-ptracec-should-include-linux-syscallsh kernel/ptrace.c
--- a/kernel/ptrace.c~kernel-ptracec-should-include-linux-syscallsh
+++ a/kernel/ptrace.c
@@ -20,6 +20,7 @@
 #include <linux/signal.h>
 #include <linux/audit.h>
 #include <linux/pid_namespace.h>
+#include <linux/syscalls.h>
 
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-acpi.patch
powerpc-vdso_do_func_patch3264-must-be-__init.patch
powerpc-free_property-mustnt-be-__init.patch
hvc_rtas_init-must-be-__init.patch
git-dvb.patch
git-gfs2-nmw.patch
git-mtd.patch
git-ocfs2.patch
if-0-pci_cleanup_aer_correct_error_status.patch
git-scsi-misc.patch
scsi-aic94xx-cleanups.patch
scsi-qlogicptic-section-fixes.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
git-xtensa.patch
move-edactxt-two-levels-up.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
kill-udffs_dateversion.patch
the-scheduled-time-option-removal.patch
reiser4.patch
