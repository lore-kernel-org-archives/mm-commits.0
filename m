From: akpm@linux-foundation.org
Subject: + include-minor-comment-fix-in-generich.patch added to -mm tree
Date: Thu, 10 Jul 2014 13:41:57 -0700
Message-ID: <53befa95.vSOe7fUHL4p+khHm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:34002 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbaGJUl6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Jul 2014 16:41:58 -0400
Received: by mail-oa0-f74.google.com with SMTP id o6so33061oag.3
        for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2014 13:41:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geoff@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/byteorder/generic.h: minor comment fix
has been added to the -mm tree.  Its filename is
     include-minor-comment-fix-in-generich.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-minor-comment-fix-in-generich.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-minor-comment-fix-in-generich.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

include-minor-comment-fix-in-generich.patch

