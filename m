From: akpm@linux-foundation.org
Subject: + hdpuftrs-fix-build.patch added to -mm tree
Date: Sun, 26 Oct 2008 21:24:17 -0700
Message-ID: <200810270424.m9R4OHd7012796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750728AbYJ0EYu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 00:24:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl


The patch titled
     hdpuftrs: fix build
has been added to the -mm tree.  Its filename is
     hdpuftrs-fix-build.patch

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
Subject: hdpuftrs: fix build
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

drivers/misc/hdpuftrs/hdpu_nexus.c:118: error: expected identifier or '(' before 'return'
drivers/misc/hdpuftrs/hdpu_nexus.c:119: error: expected identifier or '(' before '}' token

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/hdpuftrs/hdpu_nexus.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/misc/hdpuftrs/hdpu_nexus.c~hdpuftrs-fix-build drivers/misc/hdpuftrs/hdpu_nexus.c
--- a/drivers/misc/hdpuftrs/hdpu_nexus.c~hdpuftrs-fix-build
+++ a/drivers/misc/hdpuftrs/hdpu_nexus.c
@@ -113,7 +113,6 @@ static int hdpu_nexus_probe(struct platf
 	if (!hdpu_chassis_id)
 		printk(KERN_WARNING "sky_nexus: "
 		       "Unable to create proc dir entry: sky_chassis_id\n");
-	}
 
 	return 0;
 }
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

hdpuftrs-fix-build.patch
linux-next.patch
reiser4.patch

