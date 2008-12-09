From: akpm@linux-foundation.org
Subject: - audit-remove-excess-kernel-doc.patch removed from -mm tree
Date: Tue, 09 Dec 2008 10:45:42 -0800
Message-ID: <200812091845.mB9IjgCB027011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753547AbYLISp4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Dec 2008 13:45:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, eparis@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     audit: remove excess kernel-doc
has been removed from the -mm tree.  Its filename was
     audit-remove-excess-kernel-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: audit: remove excess kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Delete excess kernel-doc notation in kernel/auditsc.c:

Warning(linux-2.6.27-git10//kernel/auditsc.c:1481): Excess function parameter or struct member 'tsk' description in 'audit_syscall_entry'
Warning(linux-2.6.27-git10//kernel/auditsc.c:1564): Excess function parameter or struct member 'tsk' description in 'audit_syscall_exit'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditsc.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/auditsc.c~audit-remove-excess-kernel-doc kernel/auditsc.c
--- a/kernel/auditsc.c~audit-remove-excess-kernel-doc
+++ a/kernel/auditsc.c
@@ -1544,7 +1544,6 @@ void audit_free(struct task_struct *tsk)
 
 /**
  * audit_syscall_entry - fill in an audit record at syscall entry
- * @tsk: task being audited
  * @arch: architecture type
  * @major: major syscall type (function)
  * @a1: additional syscall register 1
@@ -1635,7 +1634,6 @@ void audit_syscall_entry(int arch, int m
 
 /**
  * audit_syscall_exit - deallocate audit context after a system call
- * @tsk: task being audited
  * @valid: success/failure flag
  * @return_code: syscall return value
  *
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
rtc-twl4030-rename-ioctl-function-when-rtc_intf_dev=n.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
arm-fix-kernel-doc-syntax.patch
mtd-remove-excess-kernel-doc-notation.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
proc-move-inode-comment-text-file-to-source-file.patch
esp-fix-section-mismatch-warning.patch
fs-use-menuconfig-to-control-the-misc-filesystems-menu.patch
documentation-when-to-bug-and-when-to-not-bug.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
max3100-spi-uart-driver-select-serial_core.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
i2o-remove-extraneous-kernel-doc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
documentation-update-header-file-paths.patch
documentation-update-s390-header-file-paths.patch
w1-add-list-masters-w1-command.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
ldisc-n_tty-export-all-n_tty-ldisc-methods.patch
pps-serial-clients-support.patch
pps-parallel-port-clients-support.patch
pps-low-level-irq-timestamps-recording.patch
fix-similar-typos-to-successfull-v2.patch

