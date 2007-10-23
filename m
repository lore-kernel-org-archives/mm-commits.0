From: akpm@linux-foundation.org
Subject: - fix-auditscc-kernel-doc.patch removed from -mm tree
Date: Mon, 22 Oct 2007 23:48:04 -0700
Message-ID: <200710230648.l9N6m4ua004338@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35634 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868AbXJWG4N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Oct 2007 02:56:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fix auditsc.c kernel-doc
has been removed from the -mm tree.  Its filename was
     fix-auditscc-kernel-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1615,7 +1615,7 @@ static void audit_copy_inode(struct audi
 /**
  * audit_inode - store the inode and device from a lookup
  * @name: name being audited
- * @inode: inode being audited
+ * @dentry: dentry being audited
  *
  * Called from fs/namei.c:path_lookup().
  */
@@ -1650,7 +1650,7 @@ void __audit_inode(const char *name, con
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
git-mtd.patch
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
profile-likely-unlikely-macros.patch
