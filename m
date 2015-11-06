From: akpm@linux-foundation.org
Subject: + fs-fix-inodec-kernel-doc-warning.patch added to -mm tree
Date: Fri, 06 Nov 2015 14:48:28 -0800
Message-ID: <563d2e3c.YhLGfhfI1dDiPUHF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51295 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757626AbbKFWs3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 17:48:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/inode.c: fix kernel-doc warning
has been added to the -mm tree.  Its filename is
     fs-fix-inodec-kernel-doc-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-fix-inodec-kernel-doc-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-fix-inodec-kernel-doc-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fs-fix-inodec-kernel-doc-warning.patch
fs-fix-writebackc-kernel-doc-warnings.patch

