From: akpm@linux-foundation.org
Subject: + leds-add-include-linux-spinlock_typesh-to.patch added to -mm tree
Date: Thu, 13 Sep 2007 18:49:19 -0700
Message-ID: <200709140149.l8E1nJGe016123@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58359 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698AbXINBtc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 21:49:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yoichi_yuasa@tripeaks.co.jp, rpurdie@rpsys.net


The patch titled
     leds: add #include <linux/spinlock_types.h> to include/linux/leds.h for rwlock_t
has been added to the -mm tree.  Its filename is
     leds-add-include-linux-spinlock_typesh-to.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: leds: add #include <linux/spinlock_types.h> to include/linux/leds.h for rwlock_t
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/leds.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/leds.h~leds-add-include-linux-spinlock_typesh-to include/linux/leds.h
--- a/include/linux/leds.h~leds-add-include-linux-spinlock_typesh-to
+++ a/include/linux/leds.h
@@ -13,6 +13,7 @@
 #define __LINUX_LEDS_H_INCLUDED
 
 #include <linux/list.h>
+#include <linux/spinlock.h>
 
 struct device;
 /*
_

Patches currently in -mm which might be from yoichi_yuasa@tripeaks.co.jp are

leds-add-include-linux-spinlock_typesh-to.patch
git-mips.patch
git-mtd.patch
move-a-few-definitions-to-au1000_xxs1500c.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
