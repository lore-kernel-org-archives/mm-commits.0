From: akpm@linux-foundation.org
Subject: - i_version-remount-support.patch removed from -mm tree
Date: Fri, 24 Oct 2008 12:40:59 -0700
Message-ID: <200810241940.m9OJexN8001039@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752357AbYJXTlL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Oct 2008 15:41:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zohar@linux.vnet.ibm.com, hch@lst.de, viro@zeniv.linux.org.uk, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     i_version: remount support
has been removed from the -mm tree.  Its filename was
     i_version-remount-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


