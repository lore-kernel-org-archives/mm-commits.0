From: akpm@linux-foundation.org
Subject: [merged] drivers-char-tlclkc-fix-typo.patch removed from -mm tree
Date: Mon, 13 Feb 2012 13:12:48 -0800
Message-ID: <20120213211248.4E379A02E6@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:47229 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab2BMVMu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2012 16:12:50 -0500
Received: by eekb15 with SMTP id b15so185249eek.1
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2012 13:12:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: standby24x7@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/char/tlclk.c: fix typo
has been removed from the -mm tree.  Its filename was
     drivers-char-tlclkc-fix-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from standby24x7@gmail.com are

origin.patch
linux-next.patch
drivers-leds-leds-lp5521c-fix-typo.patch

