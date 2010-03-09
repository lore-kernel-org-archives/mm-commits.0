From: akpm@linux-foundation.org
Subject: + fbdev-bfin-lq035q1-fb-remove-duplicated-include.patch added to -mm tree
Date: Tue, 09 Mar 2010 12:32:10 -0800
Message-ID: <201003092032.o29KWAB0003418@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751826Ab0CIUcM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 15:32:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: weiyi.huang@gmail.com, vapier@gentoo.org


The patch titled
     fbdev: bfin-lq035q1-fb: remove duplicated #include
has been added to the -mm tree.  Its filename is
     fbdev-bfin-lq035q1-fb-remove-duplicated-include.patch

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
Subject: fbdev: bfin-lq035q1-fb: remove duplicated #include
From: Huang Weiyi <weiyi.huang@gmail.com>

Remove duplicated #include('s) in
  drivers/video/bfin-lq035q1-fb.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/bfin-lq035q1-fb.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/video/bfin-lq035q1-fb.c~fbdev-bfin-lq035q1-fb-remove-duplicated-include drivers/video/bfin-lq035q1-fb.c
--- a/drivers/video/bfin-lq035q1-fb.c~fbdev-bfin-lq035q1-fb-remove-duplicated-include
+++ a/drivers/video/bfin-lq035q1-fb.c
@@ -22,7 +22,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/platform_device.h>
 #include <linux/spi/spi.h>
-#include <linux/dma-mapping.h>
 
 #include <asm/blackfin.h>
 #include <asm/irq.h>
_

Patches currently in -mm which might be from weiyi.huang@gmail.com are

linux-next.patch
fbdev-bfin-lq035q1-fb-remove-duplicated-include.patch

