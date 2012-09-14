From: akpm@linux-foundation.org
Subject: + rapidio-fix-kerneldoc-warnings-after-dma-support-was-added.patch added to -mm tree
Date: Fri, 14 Sep 2012 12:16:19 -0700
Message-ID: <20120914191620.1794A20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:43774 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759876Ab2INTQW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Sep 2012 15:16:22 -0400
Received: by weyr1 with SMTP id r1so277474wey.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Sep 2012 12:16:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, rpjday@crashcourse.ca


The patch titled
     Subject: rapidio: fix kerneldoc warnings after DMA support was added
has been added to the -mm tree.  Its filename is
     rapidio-fix-kerneldoc-warnings-after-dma-support-was-added.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: fix kerneldoc warnings after DMA support was added

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rio.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/rio.h~rapidio-fix-kerneldoc-warnings-after-dma-support-was-added include/linux/rio.h
--- a/include/linux/rio.h~rapidio-fix-kerneldoc-warnings-after-dma-support-was-added
+++ a/include/linux/rio.h
@@ -236,6 +236,7 @@ enum rio_phy_type {
  * @phys_efptr: RIO port extended features pointer
  * @name: Port name string
  * @priv: Master port private data
+ * @dma: DMA device associated with mport
  */
 struct rio_mport {
 	struct list_head dbells;	/* list of doorbell events */
@@ -404,7 +405,7 @@ union rio_pw_msg {
 
 #ifdef CONFIG_RAPIDIO_DMA_ENGINE
 
-/**
+/*
  * enum rio_write_type - RIO write transaction types used in DMA transfers
  *
  * Note: RapidIO specification defines write (NWRITE) and
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

linux-next.patch
rapidio-tsi721-modify-mport-name-assignment.patch
rapidio-fix-kerneldoc-warnings-after-dma-support-was-added.patch

