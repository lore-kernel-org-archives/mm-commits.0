From: akpm@linux-foundation.org
Subject: - afs-drop-explicit-extern.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:54:50 -0700
Message-ID: <200707162054.l6GKsoau001854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57688 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756906AbXGPVXk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:23:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     AFS: drop explicit extern
has been removed from the -mm tree.  Its filename was
     afs-drop-explicit-extern.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: AFS: drop explicit extern
From: Randy Dunlap <randy.dunlap@oracle.com>

Don't use explicit extern specifier and quieten sparse warning:
fs/afs/vnode.c:564:12: warning: function 'afs_vnode_link' with external linkage has definition

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-By: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/vnode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/afs/vnode.c~afs-drop-explicit-extern fs/afs/vnode.c
--- a/fs/afs/vnode.c~afs-drop-explicit-extern
+++ a/fs/afs/vnode.c
@@ -561,7 +561,7 @@ no_server:
 /*
  * create a hard link
  */
-extern int afs_vnode_link(struct afs_vnode *dvnode, struct afs_vnode *vnode,
+int afs_vnode_link(struct afs_vnode *dvnode, struct afs_vnode *vnode,
 			  struct key *key, const char *name)
 {
 	struct afs_server *server;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
sysctlc-add-text-telling-people-to-use-ctl_unnumbered-fix.patch
git-acpi.patch
git-alsa.patch
git-mtd.patch
git-unionfs.patch
git-ipwireless_cs.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
report-that-kernel-is-tainted-if-there-were-an-oops-before.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
docbook-dont-reference-file-without-kernel-doc.patch
profile-likely-unlikely-macros.patch
