From: akpm@linux-foundation.org
Subject: + sm501-fix-use-of-old-asm-ioh-instead-of-linux-ioh.patch added to -mm tree
Date: Mon, 23 Nov 2009 12:41:11 -0800
Message-ID: <200911232041.nANKfBZ6010177@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756930AbZKWUlP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Nov 2009 15:41:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@simtec.co.uk, krzysztof.h1@poczta.fm, linux@simtec.co.uk, vince@simtec.co.uk


The patch titled
     sm501: fix use of old <asm/io.h> instead of <linux/io.h>
has been added to the -mm tree.  Its filename is
     sm501-fix-use-of-old-asm-ioh-instead-of-linux-ioh.patch

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
Subject: sm501: fix use of old <asm/io.h> instead of <linux/io.h>
From: Ben Dooks <ben@simtec.co.uk>

Fix the old style use of <asm/io.h> by replacing it with <linux/io.h>.

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Signed-off-by: Simtec Linux Team <linux@simtec.co.uk>
Cc: Vincent Sanders <vince@simtec.co.uk>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sm501fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/sm501fb.c~sm501-fix-use-of-old-asm-ioh-instead-of-linux-ioh drivers/video/sm501fb.c
--- a/drivers/video/sm501fb.c~sm501-fix-use-of-old-asm-ioh-instead-of-linux-ioh
+++ a/drivers/video/sm501fb.c
@@ -29,8 +29,8 @@
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/console.h>
+#include <linux/io.h>
 
-#include <asm/io.h>
 #include <asm/uaccess.h>
 #include <asm/div64.h>
 
_

Patches currently in -mm which might be from ben@simtec.co.uk are

linux-next.patch
s3cmci-convert-missed-s3c2410_gpio-calls-to-gpiolib-calls.patch
spi_s3c24xx-add-fiq-pseudo-dma-support.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
sm501-fix-missing-uses-of-resource_size.patch
sm501-fix-use-of-old-asm-ioh-instead-of-linux-ioh.patch
sm501-implement-acceleration-features.patch

