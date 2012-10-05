From: akpm@linux-foundation.org
Subject: [merged] rapidio-fix-kerneldoc-warnings-after-dma-support-was-added.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:20:18 -0700
Message-ID: <20121005202019.2E858200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:55438 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUUV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:20:21 -0400
Received: by mail-bk0-f74.google.com with SMTP id q16so139102bkw.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:20:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, rpjday@crashcourse.ca, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: fix kerneldoc warnings after DMA support was added
has been removed from the -mm tree.  Its filename was
     rapidio-fix-kerneldoc-warnings-after-dma-support-was-added.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

