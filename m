From: akpm@linux-foundation.org
Subject: + audit-remove-excess-kernel-doc.patch added to -mm tree
Date: Mon, 27 Oct 2008 13:16:21 -0700
Message-ID: <200810272016.m9RKGLdQ011719@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751921AbYJ0URK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 16:17:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, eparis@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     audit: remove excess kernel-doc
has been added to the -mm tree.  Its filename is
     audit-remove-excess-kernel-doc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1465,7 +1465,6 @@ void audit_free(struct task_struct *tsk)
 
 /**
  * audit_syscall_entry - fill in an audit record at syscall entry
- * @tsk: task being audited
  * @arch: architecture type
  * @major: major syscall type (function)
  * @a1: additional syscall register 1
@@ -1556,7 +1555,6 @@ void audit_syscall_entry(int arch, int m
 
 /**
  * audit_syscall_exit - deallocate audit context after a system call
- * @tsk: task being audited
  * @valid: success/failure flag
  * @return_code: syscall return value
  *
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

docbook-fix-command-spacing.patch
docs-fix-managementstyle-book-name.patch
i2o-fix-kernel-doc-warnings.patch
mm-fix-kernel-doc-function-notation.patch
linux-next.patch
fujitsu-laptop-fix-section-mismatch-warning.patch
acpi-compal-laptop-use-rfkill-switch-subsystem-fix.patch
kgdb-fix-kernel-doc-error.patch
audit-remove-excess-kernel-doc.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
scsi-ioctl-fix-kernel-doc-warning.patch
fs-fix-inodec-kernel-doc-warnings.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
profile-likely-unlikely-macros.patch

