From: akpm@linux-foundation.org
Subject: + drivers-char-tlclkc-fix-typo.patch added to -mm tree
Date: Wed, 08 Feb 2012 14:39:48 -0800
Message-ID: <20120208223948.841DAA035C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:41141 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095Ab2BHWjt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Feb 2012 17:39:49 -0500
Received: by ghrr17 with SMTP id r17so107048ghr.1
        for <mm-commits@vger.kernel.org>; Wed, 08 Feb 2012 14:39:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: standby24x7@gmail.com


The patch titled
     Subject: drivers/char/tlclk.c: fix typo
has been added to the -mm tree.  Its filename is
     drivers-char-tlclkc-fix-typo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Masanari Iida <standby24x7@gmail.com>
Subject: drivers/char/tlclk.c: fix typo

Correct spelling "telclk_interrup" to "telclk_interrupt" in
drivers/char/tlclk.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tlclk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/tlclk.c~drivers-char-tlclkc-fix-typo drivers/char/tlclk.c
--- a/drivers/char/tlclk.c~drivers-char-tlclkc-fix-typo
+++ a/drivers/char/tlclk.c
@@ -797,7 +797,7 @@ static int __init tlclk_init(void)
 	telclk_interrupt = (inb(TLCLK_REG7) & 0x0f);
 
 	if (0x0F == telclk_interrupt ) { /* not MCPBL0010 ? */
-		printk(KERN_ERR "telclk_interrup = 0x%x non-mcpbl0010 hw.\n",
+		printk(KERN_ERR "telclk_interrupt = 0x%x non-mcpbl0010 hw.\n",
 			telclk_interrupt);
 		ret = -ENXIO;
 		goto out3;
_
Subject: Subject: drivers/char/tlclk.c: fix typo

Patches currently in -mm which might be from standby24x7@gmail.com are

linux-next.patch
drivers-char-tlclkc-fix-typo.patch
drivers-leds-leds-lp5521c-fix-typo.patch

