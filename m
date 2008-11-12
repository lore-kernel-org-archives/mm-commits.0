From: akpm@linux-foundation.org
Subject: + fs-ncpfs-getoptc-cleanup-keneldoc.patch added to -mm tree
Date: Wed, 12 Nov 2008 14:42:18 -0800
Message-ID: <200811122242.mACMgI1H032155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752746AbYKLWnU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 17:43:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qhfeng.kernel@gmail.com, VANDROVE@vc.cvut.cz, randy.dunlap@oracle.com


The patch titled
     fs/ncpfs/getopt.c: cleanup keneldoc
has been added to the -mm tree.  Its filename is
     fs-ncpfs-getoptc-cleanup-keneldoc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
drivers-message-i2o-iopc-cleanup-kerneldoc.patch
drivers-staging-usbip-stub_txc-cleanup-kerneldoc.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch

