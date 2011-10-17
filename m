From: akpm@google.com
Subject: + drivers-misc-vmw_balloonc-fix-typo-in-code-comment.patch added to -mm tree
Date: Mon, 17 Oct 2011 14:04:16 -0700
Message-ID: <201110172104.p9HL4GXC002401@hpaq5.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:23617 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab1JQVEU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2011 17:04:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rakib.mullick@gmail.com, dtor@vmware.com


The patch titled
     Subject: drivers/misc/vmw_balloon.c: fix typo in code comment
has been added to the -mm tree.  Its filename is
     drivers-misc-vmw_balloonc-fix-typo-in-code-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Rakib Mullick <rakib.mullick@gmail.com>
Subject: drivers/misc/vmw_balloon.c: fix typo in code comment

Fix typo in code comment.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Acked-by: Dmitry Torokhov <dtor@vmware.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/misc/vmw_balloon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/vmw_balloon.c~drivers-misc-vmw_balloonc-fix-typo-in-code-comment drivers/misc/vmw_balloon.c
--- a/drivers/misc/vmw_balloon.c~drivers-misc-vmw_balloonc-fix-typo-in-code-comment
+++ a/drivers/misc/vmw_balloon.c
@@ -151,7 +151,7 @@ MODULE_LICENSE("GPL");
 struct vmballoon_stats {
 	unsigned int timer;
 
-	/* allocation statustics */
+	/* allocation statistics */
 	unsigned int alloc;
 	unsigned int alloc_fail;
 	unsigned int sleep_alloc;
_
Subject: Subject: drivers/misc/vmw_balloon.c: fix typo in code comment

Patches currently in -mm which might be from rakib.mullick@gmail.com are

drivers-misc-vmw_balloonc-determine-page-allocation-flag-can_sleep-outside-loop.patch
drivers-misc-vmw_balloonc-fix-typo-in-code-comment.patch

