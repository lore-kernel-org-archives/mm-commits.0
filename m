From: akpm@linux-foundation.org
Subject: - fix-the-defaults-mentioned-in-documentation-nfsroottxt.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:43:23 -0800
Message-ID: <200702122243.l1CMhN0I013495@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44888 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030249AbXBLWnt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:43:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: da-x@monatomic.org, davem@davemloft.net, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     fix the defaults mentioned in Documentation/nfsroot.txt
has been removed from the -mm tree.  Its filename was
     fix-the-defaults-mentioned-in-documentation-nfsroottxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix the defaults mentioned in Documentation/nfsroot.txt
From: Dan Aloni <da-x@monatomic.org>

This patch fixes the documentation of nfsroot to match NFS_DEF_FILE_IO_SIZE.

Or perhaps we need to change NFS_DEF_FILE_IO_SIZE to match the
documentation?

Signed-off-by: Dan Aloni <da-x@monatomic.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/nfsroot.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/nfsroot.txt~fix-the-defaults-mentioned-in-documentation-nfsroottxt Documentation/nfsroot.txt
--- a/Documentation/nfsroot.txt~fix-the-defaults-mentioned-in-documentation-nfsroottxt
+++ a/Documentation/nfsroot.txt
@@ -67,8 +67,8 @@ nfsroot=[<server-ip>:]<root-dir>[,<nfs-o
   <nfs-options>	Standard NFS options. All options are separated by commas.
 		The following defaults are used:
 			port		= as given by server portmap daemon
-			rsize		= 1024
-			wsize		= 1024
+			rsize		= 4096
+			wsize		= 4096
 			timeo		= 7
 			retrans		= 3
 			acregmin	= 3
_

Patches currently in -mm which might be from da-x@monatomic.org are

origin.patch
fix-i-oat-for-kexec.patch
