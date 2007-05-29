From: akpm@linux-foundation.org
Subject: + afs-drop-explicit-extern.patch added to -mm tree
Date: Tue, 29 May 2007 15:44:42 -0700
Message-ID: <200705292244.l4TMigo6013520@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750883AbXE2Wq1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 18:46:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, dhowells@redhat.com


The patch titled
     AFS: drop explicit extern
has been added to the -mm tree.  Its filename is
     afs-drop-explicit-extern.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+), 1 deletion(-)

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

mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
romfs-printk-format-warnings.patch
add-pci_try_set_mwi.patch
git-unionfs.patch
add-pci_try_set_mwi-prism54pci.patch
git-ipwireless_cs.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
kconfig-no-strange-misc-devices.patch
afs-drop-explicit-extern.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
profile-likely-unlikely-macros.patch
