From: akpm@linux-foundation.org
Subject: + fix-the-defaults-mentioned-in-documentation-nfsroottxt.patch added to -mm tree
Date: Tue, 06 Feb 2007 15:08:12 -0800
Message-ID: <200702062308.l16N8Cj0032103@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54721 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030538AbXBFXIu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 18:08:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: da-x@monatomic.org, davem@davemloft.net, trond.myklebust@fys.uio.no


The patch titled
     fix the defaults mentioned in Documentation/nfsroot.txt
has been added to the -mm tree.  Its filename is
     fix-the-defaults-mentioned-in-documentation-nfsroottxt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 2 insertions(+), 2 deletions(-)

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

fix-i-oat-for-kexec.patch
fix-the-defaults-mentioned-in-documentation-nfsroottxt.patch
