From: akpm@linux-foundation.org
Subject: + fix-typos-in-fs-sysfs-filec.patch added to -mm tree
Date: Thu, 19 Jul 2007 17:47:46 -0700
Message-ID: <200707200047.l6K0lkZ3031517@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54001 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937887AbXGTAr6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 20:47:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eike-kernel@sf-tec.de


The patch titled
     Fix typos in fs/sysfs/file.c
has been added to the -mm tree.  Its filename is
     fix-typos-in-fs-sysfs-filec.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
git-r8169.patch
initialize-filp-private_data-only-once-in-em28xx_v4l2_open.patch
fix-typos-in-fs-sysfs-filec.patch
document-pci_iomap.patch
