From: akpm@linux-foundation.org
Subject: [merged] rtc-parisc-add-a-missing-include-for-linux-rtch.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:41:51 -0700
Message-ID: <200904011841.n31Ifp5q009511@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933805AbZDATnJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:43:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dannf@hp.com, a.zummo@towertech.it, grundler@parisc-linux.org, kyle@mcmartin.ca, matthew@wil.cx, mm-commits@vger.kernel.org


The patch titled
     rtc-parisc: add a missing include for linux/rtc.h
has been removed from the -mm tree.  Its filename was
     rtc-parisc-add-a-missing-include-for-linux-rtch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-parisc: add a missing include for linux/rtc.h
From: dann frazier <dannf@hp.com>

Signed-off-by: dann frazier <dannf@hp.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-parisc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/rtc-parisc.c~rtc-parisc-add-a-missing-include-for-linux-rtch drivers/rtc/rtc-parisc.c
--- a/drivers/rtc/rtc-parisc.c~rtc-parisc-add-a-missing-include-for-linux-rtch
+++ a/drivers/rtc/rtc-parisc.c
@@ -7,6 +7,7 @@
 #include <linux/module.h>
 #include <linux/time.h>
 #include <linux/platform_device.h>
+#include <linux/rtc.h>
 
 #include <asm/rtc.h>
 
_

Patches currently in -mm which might be from dannf@hp.com are

origin.patch
rtc-parisc-use-rtc_valid_tm-in-parisc_get_time.patch
ipmi-add-oem-message-handling.patch

