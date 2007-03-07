From: akpm@linux-foundation.org
Subject: + nameic-remove-utterly-outdated-comment.patch added to -mm tree
Date: Wed, 07 Mar 2007 13:04:10 -0800
Message-ID: <200703072104.l27L4A9P008790@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57134 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423004AbXCGVEO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 16:04:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de


The patch titled
     namei.c: remove utterly outdated comment
has been added to the -mm tree.  Its filename is
     nameic-remove-utterly-outdated-comment.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: namei.c: remove utterly outdated comment
From: Christoph Hellwig <hch@lst.de>

We don't have a routine called namei() anymore since at least 2.3.x, and
the comment is just totally out of sync with the current lookup logic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |   11 -----------
 1 files changed, 11 deletions(-)

diff -puN fs/namei.c~nameic-remove-utterly-outdated-comment fs/namei.c
--- a/fs/namei.c~nameic-remove-utterly-outdated-comment
+++ a/fs/namei.c
@@ -1318,17 +1318,6 @@ access:
 	return ERR_PTR(-EACCES);
 }
 
-/*
- *	namei()
- *
- * is used by most simple commands to get the inode of a specified name.
- * Open, link etc use their own routines, but this is enough for things
- * like 'chmod' etc.
- *
- * namei exists in two versions: namei/lnamei. The only difference is
- * that namei follows links, while lnamei does not.
- * SMP-safe
- */
 int fastcall __user_walk_fd(int dfd, const char __user *name, unsigned flags,
 			    struct nameidata *nd)
 {
_

Patches currently in -mm which might be from hch@lst.de are

xfs-use-xfs_get_buf_noaddr-for-iclogs.patch
xfs-stop-using-kmalloc-in-xfs_buf_get_noaddr.patch
simplify-the-stacktrace-code.patch
allow-access-to-proc-pid-fd-after-setuid.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
freevxfs-possible-null-pointer-dereference-fix.patch
vfs-remove-superflous-sb-==-null-checks.patch
nameic-remove-utterly-outdated-comment.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes.patch
aio-is-unlikely.patch
ps3fb-thread-updates.patch
ps3av-thread-updates.patch
ps3fb-kill-superfluous-zero-initializations.patch
ps3av-misc-updates.patch
