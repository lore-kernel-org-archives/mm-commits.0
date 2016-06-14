From: akpm@linux-foundation.org
Subject: + befs-fix-function-name-in-documentation.patch added to -mm tree
Date: Tue, 14 Jun 2016 16:10:30 -0700
Message-ID: <57608ee6.M2EaR6FgAjghuwb8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56574 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbcFNXKb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jun 2016 19:10:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luisbg@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: befs: fix function name in documentation
has been added to the -mm tree.  Its filename is
     befs-fix-function-name-in-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/befs-fix-function-name-in-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/befs-fix-function-name-in-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: befs: fix function name in documentation

Documentation of function befs_load_cb() lists it as load_befs_sb().  Fix
the misnomer.

Link: http://lkml.kernel.org/r/1465700235-22881-2-git-send-email-luisbg@osg.samsung.com
Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/befs/super.c~befs-fix-function-name-in-documentation fs/befs/super.c
--- a/fs/befs/super.c~befs-fix-function-name-in-documentation
+++ a/fs/befs/super.c
@@ -14,7 +14,7 @@
 #include "super.h"
 
 /**
- * load_befs_sb -- Read from disk and properly byteswap all the fields
+ * befs_load_sb -- Read from disk and properly byteswap all the fields
  * of the befs superblock
  *
  *
_

Patches currently in -mm which might be from luisbg@osg.samsung.com are

befs-check-return-of-sb_min_blocksize.patch
befs-fix-function-name-in-documentation.patch
befs-remove-unused-functions.patch

