From: akpm@linux-foundation.org
Subject: - fix-trivial-typos-in-anon_inodesc-comments.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:59:27 -0700
Message-ID: <200707162059.l6GKxRuL002430@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51662 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758924AbXGPVPM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:15:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     Fix trivial typos in anon_inodes.c comments
has been removed from the -mm tree.  Its filename was
     fix-trivial-typos-in-anon_inodesc-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix trivial typos in anon_inodes.c comments
From: J. Bruce Fields <bfields@citi.umich.edu>

Trivial typo and grammar fixes.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/anon_inodes.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

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
@@ -141,9 +141,9 @@ err_put_filp:
 }
 
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

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
git-vfs-lease-api.patch
knfsd-lockd-nfsd4-use-same-grace-period-for-lockd-and-nfsd4.patch
knfsd-nfsd4-fix-nfsv4-filehandle-size-units-confusion.patch
knfsd-nfsd4-silence-a-compiler-warning-in-acl-code.patch
knfsd-nfsd4-fix-enc_stateid_sz-for-nfsd-callbacks.patch
knfsd-nfsd4-fix-handling-of-acl-errrors.patch
knfsd-nfsd-remove-unused-header-interfaceh.patch
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size.patch
knfsd-nfsd4-dont-delegate-files-that-have-had-conflicts.patch
knfsd-nfsd-make-all-exp_finding-functions-return-errnos-on-err.patch
knfsd-nfsd4-build-rpcsec_gss-whenever-nfsd4-is-built.patch
knfsd-nfsd4-store-pseudoflavor-in-request.patch
knfsd-nfsd4-parse-secinfo-information-in-exports-downcall.patch
knfsd-nfsd4-simplify-exp_pseudoroot-arguments.patch
knfsd-nfsd-remove-superfluous-assignment-from-nfsd_lookup.patch
knfsd-nfsd-provide-export-lookup-wrappers-which-take-a-svc_rqst.patch
knfsd-nfsd-set-rq_client-to-ip-address-determined-domain.patch
knfsd-nfsd-use-ip-address-based-domain-in-secinfo-case.patch
knfsd-nfsd-factor-nfsd_lookup-into-2-pieces.patch
knfsd-nfsd4-return-nfserr_wrongsec.patch
knfsd-nfsd4-make-readonly-access-depend-on-pseudoflavor.patch
knfsd-nfsd-factor-out-code-from-show_expflags.patch
knfsd-nfsd-display-export-secinfo-information.patch
knfsd-rpc-add-gss-krb5-and-spkm3-oid-values.patch
knfsd-nfsd4-implement-secinfo.patch
knfsd-nfsd4-secinfo-handling-without-secinfo=-option.patch
knfsd-nfsd-allow-auth_sys-nlm-on-rpcsec_gss-exports.patch
knfsd-nfsd-enforce-per-flavor-id-squashing.patch
