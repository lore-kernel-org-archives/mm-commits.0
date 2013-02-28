From: akpm@linux-foundation.org
Subject: [merged] eventfd-fix-incorrect-filename-is-a-comment.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:17:33 -0800
Message-ID: <20130228201733.AC58F31C23A@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:59263 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759441Ab3B1URe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:17:34 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so245268ggi.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:17:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sustrik@250bpm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/eventfd.h: fix incorrect filename is a comment
has been removed from the -mm tree.  Its filename was
     eventfd-fix-incorrect-filename-is-a-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Martin Sustrik <sustrik@250bpm.com>
Subject: include/linux/eventfd.h: fix incorrect filename is a comment

Comment in eventfd.h referred to 'include/asm-generic/fcntl.h'
while the correct path is 'include/uapi/asm-generic/fcntl.h'.

Signed-off-by: Martin Sustrik <sustrik@250bpm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/eventfd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/eventfd.h~eventfd-fix-incorrect-filename-is-a-comment include/linux/eventfd.h
--- a/include/linux/eventfd.h~eventfd-fix-incorrect-filename-is-a-comment
+++ a/include/linux/eventfd.h
@@ -13,7 +13,7 @@
 #include <linux/wait.h>
 
 /*
- * CAREFUL: Check include/asm-generic/fcntl.h when defining
+ * CAREFUL: Check include/uapi/asm-generic/fcntl.h when defining
  * new flags, since they might collide with O_* ones. We want
  * to re-use O_* flags that couldn't possibly have a meaning
  * from eventfd, in order to leave a free define-space for
_

Patches currently in -mm which might be from sustrik@250bpm.com are

origin.patch

