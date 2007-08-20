From: akpm@linux-foundation.org
Subject: - fix-typos-in-fs-sysfs-filec.patch removed from -mm tree
Date: Mon, 20 Aug 2007 12:12:01 -0700
Message-ID: <200708201912.l7KJC1MS018311@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40551 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756920AbXHTTVD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:21:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eike-kernel@sf-tec.de, mm-commits@vger.kernel.org


The patch titled
     Fix typos in fs/sysfs/file.c
has been removed from the -mm tree.  Its filename was
     fix-typos-in-fs-sysfs-filec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix typos in fs/sysfs/file.c
From: Rolf Eike Beer <eike-kernel@sf-tec.de>

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/file.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/sysfs/file.c~fix-typos-in-fs-sysfs-filec fs/sysfs/file.c
--- a/fs/sysfs/file.c~fix-typos-in-fs-sysfs-filec
+++ a/fs/sysfs/file.c
@@ -335,7 +335,7 @@ static int sysfs_release(struct inode * 
  * again will not get new data, or reset the state of 'poll'.
  * Reminder: this only works for attributes which actively support
  * it, and it is not possible to test an attribute from userspace
- * to see if it supports poll (Nether 'poll' or 'select' return
+ * to see if it supports poll (Neither 'poll' nor 'select' return
  * an appropriate error code).  When in doubt, set a suitable timeout value.
  */
 static unsigned int sysfs_poll(struct file *filp, poll_table *wait)
_

Patches currently in -mm which might be from eike-kernel@sf-tec.de are

git-dvb.patch
git-r8169.patch
