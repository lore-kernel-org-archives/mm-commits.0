From: akpm@linux-foundation.org
Subject: + maintainers-mention-lockd-and-sunrpc-in-nfs-entries.patch added to -mm tree
Date: Wed, 23 Jul 2008 12:57:50 -0700
Message-ID: <200807231957.m6NJvob4009100@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52544 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753083AbYGWT6H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 15:58:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@fieldses.org, bfields@citi.umich.edu, trond.myklebust@fys.uio.no


The patch titled
     MAINTAINERS: mention lockd and sunrpc in nfs entries
has been added to the -mm tree.  Its filename is
     maintainers-mention-lockd-and-sunrpc-in-nfs-entries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -2443,7 +2443,7 @@ L:	kernel-janitors@vger.kernel.org
 W:	http://www.kerneljanitors.org/
 S:	Maintained
 
-KERNEL NFSD
+KERNEL NFSD, SUNRPC, AND LOCKD SERVERS
 P:	J. Bruce Fields
 M:	bfields@fieldses.org
 P:	Neil Brown
@@ -3069,7 +3069,7 @@ M:	ja@ssi.bg
 L:	netdev@vger.kernel.org
 S:	Maintained
 
-NFS CLIENT
+NFS, SUNRPC, AND LOCKD CLIENTS
 P:	Trond Myklebust
 M:	Trond.Myklebust@netapp.com
 L:	linux-nfs@vger.kernel.org
_

Patches currently in -mm which might be from bfields@fieldses.org are

lockd-trivial-sparse-endian-annotations.patch
maintainers-mention-lockd-and-sunrpc-in-nfs-entries.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix.patch
lockd-dont-return-eagain-for-a-permanent-error.patch
locks-add-special-return-value-for-asynchronous-locks.patch
locks-cleanup-code-duplication.patch
locks-allow-lock-to-return-file_lock_deferred.patch
fuse-nfs-export-special-lookups.patch
fuse-lockd-support.patch

