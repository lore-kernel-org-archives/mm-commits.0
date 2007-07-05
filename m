From: akpm@linux-foundation.org
Subject: + fix-trivial-typos-in-anon_inodesc-comments.patch added to -mm tree
Date: Thu, 05 Jul 2007 14:27:23 -0700
Message-ID: <200707052127.l65LRNn5020586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47186 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758532AbXGEV1h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 17:27:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@citi.umich.edu, davidel@xmailserver.org


The patch titled
     Fix trivial typos in anon_inodes.c comments
has been added to the -mm tree.  Its filename is
     fix-trivial-typos-in-anon_inodesc-comments.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix trivial typos in anon_inodes.c comments
From: J. Bruce Fields <bfields@citi.umich.edu>

Trivial typo and grammar fixes.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/anon_inodes.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/anon_inodes.c~fix-trivial-typos-in-anon_inodesc-comments fs/anon_inodes.c
--- a/fs/anon_inodes.c~fix-trivial-typos-in-anon_inodesc-comments
+++ a/fs/anon_inodes.c
@@ -53,7 +53,7 @@ static struct dentry_operations anon_ino
 };
 
 /**
- * anon_inode_getfd - creates a new file instance by hooking it up to and
+ * anon_inode_getfd - creates a new file instance by hooking it up to an
  *                    anonymous inode, and a dentry that describe the "class"
  *                    of the file
  *
@@ -66,7 +66,7 @@ static struct dentry_operations anon_ino
  *
  * Creates a new file by hooking it on a single inode. This is useful for files
  * that do not need to have a full-fledged inode in order to operate correctly.
- * All the files created with anon_inode_getfd() will share a single inode, by
+ * All the files created with anon_inode_getfd() will share a single inode,
  * hence saving memory and avoiding code duplication for the file/inode/dentry
  * setup.
  */
@@ -142,9 +142,9 @@ err_put_filp:
 EXPORT_SYMBOL_GPL(anon_inode_getfd);
 
 /*
- * A single inode exist for all anon_inode files. Contrary to pipes,
- * anon_inode inodes has no per-instance data associated, so we can avoid
- * the allocation of multiple of them.
+ * A single inode exists for all anon_inode files. Contrary to pipes,
+ * anon_inode inodes have no associated per-instance data, so we need
+ * only allocate one of them.
  */
 static struct inode *anon_inode_mkinode(void)
 {
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

auth_gss-unregister-gss_domain-when-unloading-module.patch
fix-trivial-typos-in-anon_inodesc-comments.patch
knfsd-lockd-nfsd4-use-same-grace-period-for-lockd-and-nfsd4.patch
knfsd-nfsd4-fix-nfsv4-filehandle-size-units-confusion.patch
knfsd-nfsd4-silence-a-compiler-warning-in-acl-code.patch
knfsd-nfsd4-fix-enc_stateid_sz-for-nfsd-callbacks.patch
knfsd-nfsd4-fix-handling-of-acl-errrors.patch
knfsd-nfsd-remove-unused-header-interfaceh.patch
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size.patch
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix-fix-fix.patch
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix-fix-fix-fix.patch
knfsd-nfsd4-dont-delegate-files-that-have-had-conflicts.patch
