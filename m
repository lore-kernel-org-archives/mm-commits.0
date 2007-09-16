From: akpm@linux-foundation.org
Subject: - leds-add-include-linux-spinlock_typesh-to.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:26:40 -0700
Message-ID: <200709160926.l8G9Qeuk009199@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33964 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751995AbXIPJi3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:38:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yoichi_yuasa@tripeaks.co.jp, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds: add #include <linux/spinlock_types.h> to include/linux/leds.h for rwlock_t
has been removed from the -mm tree.  Its filename was
     leds-add-include-linux-spinlock_typesh-to.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-mips.patch
git-mtd.patch
move-a-few-definitions-to-au1000_xxs1500c.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
