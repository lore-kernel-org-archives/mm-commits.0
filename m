From: akpm@linux-foundation.org
Subject: [merged] include-minor-comment-fix-in-generich.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:07:07 -0700
Message-ID: <53e3dc6b.+3pMhKh3vnCoIKF6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:43950 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062AbaHGUHI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:07:08 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so1174177pab.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:07:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geoff@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/byteorder/generic.h: minor comment fix
has been removed from the -mm tree.  Its filename was
     include-minor-comment-fix-in-generich.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geoff Levand <geoff@infradead.org>
Subject: include/linux/byteorder/generic.h: minor comment fix

Signed-off-by: Geoff Levand <geoff@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/byteorder/generic.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/byteorder/generic.h~include-minor-comment-fix-in-generich include/linux/byteorder/generic.h
--- a/include/linux/byteorder/generic.h~include-minor-comment-fix-in-generich
+++ a/include/linux/byteorder/generic.h
@@ -2,7 +2,7 @@
 #define _LINUX_BYTEORDER_GENERIC_H
 
 /*
- * linux/byteorder_generic.h
+ * linux/byteorder/generic.h
  * Generic Byte-reordering support
  *
  * The "... p" macros, like le64_to_cpup, can be used with pointers
_

Patches currently in -mm which might be from geoff@infradead.org are

origin.patch

