From: akpm@linux-foundation.org
Subject: + dcache-trivial-comment-fix.patch added to -mm tree
Date: Thu, 13 Sep 2007 18:25:32 -0700
Message-ID: <200709140125.l8E1PW3U015328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55809 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750987AbXINBZr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 21:25:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@fieldses.org, bfields@citi.umich.edu


The patch titled
     dcache: trivial comment fix
has been added to the -mm tree.  Its filename is
     dcache-trivial-comment-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dcache: trivial comment fix
From: "J. Bruce Fields" <bfields@fieldses.org>

As it stands this comment is confusing, and not quite grammatical.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/dcache.c~dcache-trivial-comment-fix fs/dcache.c
--- a/fs/dcache.c~dcache-trivial-comment-fix
+++ a/fs/dcache.c
@@ -1514,8 +1514,8 @@ static void switch_names(struct dentry *
  * This forceful removal will result in ugly /proc output if
  * somebody holds a file open that got deleted due to a rename.
  * We could be nicer about the deleted file, and let it show
- * up under the name it got deleted rather than the name that
- * deleted it.
+ * up under the name it had before it was deleted rather than
+ * under the original name of the file that was moved on top of it.
  */
  
 /*
_

Patches currently in -mm which might be from bfields@fieldses.org are

leases-can-be-hidden-by-flocks.patch
git-nfs.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-nfsd.patch
nfs-fix-oops-re-sysctls-and-v4-support.patch
fix-f_version-type-should-be-u64-instead-of-unsigned-long.patch
dcache-trivial-comment-fix.patch
fs-nfsd-exportc-make-3-functions-static.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
