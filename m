From: akpm@linux-foundation.org
Subject: [merged] fs-fix-inodec-kernel-doc-warning.patch removed from -mm
 tree
Date: Tue, 10 Nov 2015 12:32:54 -0800
Message-ID: <56425476.pIIytRINvRoUC5yR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbbKJUcz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Nov 2015 15:32:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/inode.c: fix kernel-doc warning
has been removed from the -mm tree.  Its filename was
     fs-fix-inodec-kernel-doc-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: fs/inode.c: fix kernel-doc warning

Fix kernel-doc warning in fs/inode.c:

..//fs/inode.c:1606: warning: No description found for parameter 'inode'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/inode.c~fs-fix-inodec-kernel-doc-warning fs/inode.c
--- a/fs/inode.c~fs-fix-inodec-kernel-doc-warning
+++ a/fs/inode.c
@@ -1597,6 +1597,7 @@ static int update_time(struct inode *ino
 /**
  *	touch_atime	-	update the access time
  *	@path: the &struct path to update
+ *	@inode: inode to update
  *
  *	Update the accessed time on an inode and mark it for writeback.
  *	This function automatically handles read only file systems and media,
_

Patches currently in -mm which might be from rdunlap@infradead.org are


