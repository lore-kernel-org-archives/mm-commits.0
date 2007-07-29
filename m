From: akpm@linux-foundation.org
Subject: + fix-auditscc-kernel-doc.patch added to -mm tree
Date: Sun, 29 Jul 2007 00:47:19 -0700
Message-ID: <200707290747.l6T7lJKc014414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45744 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758451AbXG2Hrx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 03:47:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, viro@zeniv.linux.org.uk


The patch titled
     fix auditsc.c kernel-doc
has been added to the -mm tree.  Its filename is
     fix-auditscc-kernel-doc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix auditsc.c kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warnings:
Warning(/scsi/linsrc/linux-2.6.23-rc1-mm1//kernel/auditsc.c:1611): No description found for parameter 'dentry'
Warning(/scsi/linsrc/linux-2.6.23-rc1-mm1//kernel/auditsc.c:1654): No description found for parameter 'dentry'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditsc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/auditsc.c~fix-auditscc-kernel-doc kernel/auditsc.c
--- a/kernel/auditsc.c~fix-auditscc-kernel-doc
+++ a/kernel/auditsc.c
@@ -1606,7 +1606,7 @@ static void audit_copy_inode(struct audi
 /**
  * audit_inode - store the inode and device from a lookup
  * @name: name being audited
- * @inode: inode being audited
+ * @dentry: dentry being audited
  *
  * Called from fs/namei.c:path_lookup().
  */
@@ -1641,7 +1641,7 @@ void __audit_inode(const char *name, con
 /**
  * audit_inode_child - collect inode info for created/removed objects
  * @dname: inode's dentry name
- * @inode: inode being audited
+ * @dentry: dentry being audited
  * @parent: inode of dentry parent
  *
  * For syscalls that create or remove filesystem objects, audit_inode
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
update-dontdiff-file.patch
kernel-doc-fixes-for-pci-and-drivers-base.patch
x86-64-calgary-fix-section-mismatch-warnings-in-tce.patch
various-doc-kernel-parameters-fixes.patch
pnp-fix-kernel-doc-warnings.patch
sched-fix-kernel-doc-warnings.patch
fix-filemapc-kernel-doc.patch
git-acpi.patch
fix-auditscc-kernel-doc.patch
git-mtd.patch
git-net.patch
aha152x-in-debug-mode.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-kgdb-kernel-doc.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
i2ch-kernel-doc-additions.patch
irqh-fix-kernel-doc.patch
docbook-bad-file-references.patch
kthread-silence-bogus-section-mismatch-warning.patch
profile-likely-unlikely-macros.patch
