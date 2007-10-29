From: akpm@linux-foundation.org
Subject: + i4l-errors-with-assignments-in-if.patch added to -mm tree
Date: Mon, 29 Oct 2007 13:47:38 -0700
Message-ID: <200710292047.l9TKlciM022569@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42577 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751150AbXJ2UsT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 16:48:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 12o3l@tiscali.nl, kkeil@suse.de


The patch titled
     i4l: errors with assignments in if
has been added to the -mm tree.  Its filename is
     i4l-errors-with-assignments-in-if.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i4l: errors with assignments in if
From: Roel Kluin <12o3l@tiscali.nl>

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hisax/elsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/mach-omap2/clock.c~i4l-errors-with-assignments-in-if arch/arm/mach-omap2/clock.c
diff -puN drivers/isdn/hisax/elsa.c~i4l-errors-with-assignments-in-if drivers/isdn/hisax/elsa.c
--- a/drivers/isdn/hisax/elsa.c~i4l-errors-with-assignments-in-if
+++ a/drivers/isdn/hisax/elsa.c
@@ -883,7 +883,7 @@ setup_elsa_isa(struct IsdnCard *card)
 	val += 'A' - 3;
 	if (val == 'B' || val == 'C')
 		val ^= 1;
-	if ((cs->subtyp == ELSA_PCFPRO) && (val = 'G'))
+	if ((cs->subtyp == ELSA_PCFPRO) && (val == 'G'))
 		val = 'C';
 	printk(KERN_INFO
 	       "Elsa: %s found at %#lx Rev.:%c IRQ %d\n",
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

origin.patch
git-arm-master.patch
git-ocfs2.patch
git-s390.patch
i4l-errors-with-assignments-in-if.patch
