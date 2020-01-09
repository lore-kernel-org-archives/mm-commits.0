From: akpm@linux-foundation.org
Subject: + linux-next-rejects.patch added to -mm tree
Date: Thu, 09 Jan 2020 14:46:54 -0800
Message-ID: <20200109224654.veSj13m4U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729389AbgAIWqz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jan 2020 17:46:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been added to the -mm tree.  Its filename is
     linux-next-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev.h |    9 ---------
 1 file changed, 9 deletions(-)

--- a/include/linux/backing-dev.h~linux-next-rejects
+++ a/include/linux/backing-dev.h
@@ -514,13 +514,4 @@ static inline const char *bdi_dev_name(s
 	return dev_name(bdi->dev);
 }
 
-extern const char *bdi_unknown_name;
-
-static inline const char *bdi_dev_name(struct backing_dev_info *bdi)
-{
-	if (!bdi || !bdi->dev)
-		return bdi_unknown_name;
-	return dev_name(bdi->dev);
-}
