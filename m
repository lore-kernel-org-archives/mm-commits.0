From: akpm@linux-foundation.org
Subject: + i_version-remount-support.patch added to -mm tree
Date: Thu, 16 Oct 2008 13:33:53 -0700
Message-ID: <200810162033.m9GKXrSx015467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34508 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754728AbYJPUjY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 16:39:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zohar@linux.vnet.ibm.com, hch@lst.de, viro@zeniv.linux.org.uk, zohar@us.ibm.com


The patch titled
     i_version: remount support
has been added to the -mm tree.  Its filename is
     i_version-remount-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i_version: remount support
From: Mimi Zohar <zohar@linux.vnet.ibm.com>

Add support for remounting a filesystem with the i_version option.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/fs.h~i_version-remount-support include/linux/fs.h
--- a/include/linux/fs.h~i_version-remount-support
+++ a/include/linux/fs.h
@@ -136,7 +136,7 @@ extern int dir_notify_enable;
 /*
  * Superblock flags that can be altered by MS_REMOUNT
  */
-#define MS_RMT_MASK	(MS_RDONLY|MS_SYNCHRONOUS|MS_MANDLOCK)
+#define MS_RMT_MASK	(MS_RDONLY|MS_SYNCHRONOUS|MS_MANDLOCK|MS_I_VERSION)
 
 /*
  * Old magic mount flag and mask
_

Patches currently in -mm which might be from zohar@linux.vnet.ibm.com are

origin.patch
i_version-remount-support.patch

