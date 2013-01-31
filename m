From: akpm@linux-foundation.org
Subject: + eventfd-fix-incorrect-filename-is-a-comment.patch added to -mm tree
Date: Thu, 31 Jan 2013 12:52:21 -0800
Message-ID: <20130131205221.AAD4231C1B2@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:36856 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab3AaUwY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Jan 2013 15:52:24 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so347663vch.4
        for <mm-commits@vger.kernel.org>; Thu, 31 Jan 2013 12:52:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sustrik@250bpm.com


The patch titled
     Subject: include/linux/eventfd.h: fix incorrect filename is a comment
has been added to the -mm tree.  Its filename is
     eventfd-fix-incorrect-filename-is-a-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

eventfd-fix-incorrect-filename-is-a-comment.patch

