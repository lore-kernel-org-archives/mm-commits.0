From: akpm@linux-foundation.org
Subject: [merged] rapidio-fix-comment.patch removed from -mm tree
Date: Thu, 11 Oct 2012 13:59:16 -0700
Message-ID: <20121011205916.99D10100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:54259 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759054Ab2JKU7R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Oct 2012 16:59:17 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so270416qcq.1
        for <mm-commits@vger.kernel.org>; Thu, 11 Oct 2012 13:59:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kreese@caviumnetworks.com, alexandre.bounine@idt.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: fix comment
has been removed from the -mm tree.  Its filename was
     rapidio-fix-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

