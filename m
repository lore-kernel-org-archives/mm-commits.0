From: akpm@linux-foundation.org
Subject: - fs-ncpfs-getoptc-cleanup-keneldoc.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:17:33 -0800
Message-ID: <200901072217.n07MHXc2017179@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932192AbZAGWhe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:37:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qhfeng.kernel@gmail.com, VANDROVE@vc.cvut.cz, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     fs/ncpfs/getopt.c: cleanup keneldoc
has been removed from the -mm tree.  Its filename was
     fs-ncpfs-getoptc-cleanup-keneldoc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/ncpfs/getopt.c: cleanup keneldoc
From: Qinghuang Feng <qhfeng.kernel@gmail.com>

There are no argument named @flag in ncp_getopt(), remove it.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Petr Vandrovec <VANDROVE@vc.cvut.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/getopt.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/ncpfs/getopt.c~fs-ncpfs-getoptc-cleanup-keneldoc fs/ncpfs/getopt.c
--- a/fs/ncpfs/getopt.c~fs-ncpfs-getoptc-cleanup-keneldoc
+++ a/fs/ncpfs/getopt.c
@@ -16,7 +16,6 @@
  *	@opts: an array of &struct option entries controlling parser operations
  *	@optopt: output; will contain the current option
  *	@optarg: output; will contain the value (if one exists)
- *	@flag: output; may be NULL; should point to a long for or'ing flags
  *	@value: output; may be NULL; will be overwritten with the integer value
  *		of the current argument.
  *
_

Patches currently in -mm which might be from qhfeng.kernel@gmail.com are

origin.patch
linux-next.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
ext2-fix-ext2_splice_branch-comments.patch

