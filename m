From: akpm@linux-foundation.org
Subject: [merged] vlynq-includecheck-fix-drivers-vlynq-vlynqc.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:53:20 -0700
Message-ID: <200909231953.n8NJrKgE030934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58451 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753568AbZIWT7w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:59:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaswinderrajput@gmail.com, florian@openwrt.org, mm-commits@vger.kernel.org


The patch titled
     vlynq: includecheck fix: drivers/vlynq/vlynq.c
has been removed from the -mm tree.  Its filename was
     vlynq-includecheck-fix-drivers-vlynq-vlynqc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vlynq: includecheck fix: drivers/vlynq/vlynq.c
From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

Fix the following 'make includecheck' warning:

drivers/vlynq/vlynq.c: linux/device.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Signed-off-by: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/vlynq/vlynq.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/vlynq/vlynq.c~vlynq-includecheck-fix-drivers-vlynq-vlynqc drivers/vlynq/vlynq.c
--- a/drivers/vlynq/vlynq.c~vlynq-includecheck-fix-drivers-vlynq-vlynqc
+++ a/drivers/vlynq/vlynq.c
@@ -28,7 +28,6 @@
 #include <linux/errno.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
-#include <linux/device.h>
 #include <linux/delay.h>
 #include <linux/io.h>
 
_

Patches currently in -mm which might be from jaswinderrajput@gmail.com are

origin.patch
linux-next.patch
includecheck-fix-documentation-cfag12864b-examplec.patch

