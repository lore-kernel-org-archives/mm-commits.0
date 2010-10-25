From: akpm@linux-foundation.org
Subject: + drivers-crypto-dubious-error-check.patch added to -mm tree
Date: Mon, 25 Oct 2010 15:46:59 -0700
Message-ID: <201010252246.o9PMkxOv020817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751305Ab0JYWrH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Oct 2010 18:47:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nikai@nikai.net, davem@davemloft.net, herbert@gondor.hengli.com.au


The patch titled
     drivers/crypto/n2_core.c: dubious error check
has been added to the -mm tree.  Its filename is
     drivers-crypto-dubious-error-check.patch

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
Subject: drivers/crypto/n2_core.c: dubious error check
From: Nicolas Kaiser <nikai@nikai.net>

Looks like a copy-and-paste problem to me.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/crypto/n2_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/crypto/n2_core.c~drivers-crypto-dubious-error-check drivers/crypto/n2_core.c
--- a/drivers/crypto/n2_core.c~drivers-crypto-dubious-error-check
+++ a/drivers/crypto/n2_core.c
@@ -1832,7 +1832,7 @@ static int __devinit get_irq_props(struc
 		return -ENODEV;
 
 	ino = mdesc_get_property(mdesc, node, "ino", &ino_len);
-	if (!intr)
+	if (!ino)
 		return -ENODEV;
 
 	if (intr_len != ino_len)
_

Patches currently in -mm which might be from nikai@nikai.net are

origin.patch
linux-next.patch
drivers-media-video-gspca-cpia1c-fix-error-check.patch
drivers-crypto-dubious-error-check.patch

