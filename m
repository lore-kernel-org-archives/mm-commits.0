From: akpm@linux-foundation.org
Subject: + rapidio-fix-comment.patch added to -mm tree
Date: Wed, 10 Oct 2012 13:38:09 -0700
Message-ID: <20121010203810.0B8B25C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:36643 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757180Ab2JJUiM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Oct 2012 16:38:12 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so69179wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 10 Oct 2012 13:38:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kreese@caviumnetworks.com, alexandre.bounine@idt.com


The patch titled
     Subject: rapidio: fix comment
has been added to the -mm tree.  Its filename is
     rapidio-fix-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chad Reese <kreese@caviumnetworks.com>
Subject: rapidio: fix comment

The resource index for the mailboxes was incorrect.

Signed-off-by: Chad Reese <kreese@caviumnetworks.com>
Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rio.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/rio.h~rapidio-fix-comment include/linux/rio.h
--- a/include/linux/rio.h~rapidio-fix-comment
+++ a/include/linux/rio.h
@@ -63,7 +63,7 @@
  *
  *	0	RapidIO inbound doorbells
  *	1	RapidIO inbound mailboxes
- *	1	RapidIO outbound mailboxes
+ *	2	RapidIO outbound mailboxes
  */
 #define RIO_DOORBELL_RESOURCE	0
 #define RIO_INB_MBOX_RESOURCE	1
_

Patches currently in -mm which might be from kreese@caviumnetworks.com are

origin.patch
rapidio-fix-comment.patch

