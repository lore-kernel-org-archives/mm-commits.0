From: akpm@linux-foundation.org
Subject: - maintainers-mention-lockd-and-sunrpc-in-nfs-entries.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:07:51 -0700
Message-ID: <200808042007.m74K7pTW027854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762011AbYHDUIJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:08:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@fieldses.org, bfields@citi.umich.edu, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: mention lockd and sunrpc in nfs entries
has been removed from the -mm tree.  Its filename was
     maintainers-mention-lockd-and-sunrpc-in-nfs-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: mention lockd and sunrpc in nfs entries
From: "J. Bruce Fields" <bfields@fieldses.org>

The actual division of labor is a little vague in some of the common
code, but if the patches get to one of us then we can sort it out.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-mention-lockd-and-sunrpc-in-nfs-entries MAINTAINERS
--- a/MAINTAINERS~maintainers-mention-lockd-and-sunrpc-in-nfs-entries
+++ a/MAINTAINERS
@@ -2446,7 +2446,7 @@ L:	kernel-janitors@vger.kernel.org
 W:	http://www.kerneljanitors.org/
 S:	Maintained
 
-KERNEL NFSD
+KERNEL NFSD, SUNRPC, AND LOCKD SERVERS
 P:	J. Bruce Fields
 M:	bfields@fieldses.org
 P:	Neil Brown
@@ -3070,7 +3070,7 @@ M:	ja@ssi.bg
 L:	netdev@vger.kernel.org
 S:	Maintained
 
-NFS CLIENT
+NFS, SUNRPC, AND LOCKD CLIENTS
 P:	Trond Myklebust
 M:	Trond.Myklebust@netapp.com
 L:	linux-nfs@vger.kernel.org
_

Patches currently in -mm which might be from bfields@fieldses.org are


