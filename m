From: akpm@linux-foundation.org
Subject: + vlynq-includecheck-fix-drivers-vlynq-vlynqc.patch added to -mm tree
Date: Wed, 26 Aug 2009 17:38:04 -0700
Message-ID: <200908270038.n7R0c4wu016357@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753608AbZH0Aie (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Aug 2009 20:38:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaswinderrajput@gmail.com, florian@openwrt.org


The patch titled
     vlynq: includecheck fix: drivers/vlynq/vlynq.c
has been added to the -mm tree.  Its filename is
     vlynq-includecheck-fix-drivers-vlynq-vlynqc.patch

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

linux-next.patch
gitignore-usr-initramfs_datacpiobz2-and-usr-initramfs_datacpiolzma.patch
mm-includecheck-fix-for-mm-shmemc.patch
mm-includecheck-fix-for-mm-nommuc.patch
vlynq-includecheck-fix-drivers-vlynq-vlynqc.patch
includecheck-fix-documentation-cfag12864b-examplec.patch

