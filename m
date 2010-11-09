From: akpm@linux-foundation.org
Subject: [merged] drivers-crypto-dubious-error-check.patch removed from -mm tree
Date: Tue, 09 Nov 2010 10:53:59 -0800
Message-ID: <201011091856.oA9IuEEc000968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752627Ab0KIS44 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Nov 2010 13:56:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nikai@nikai.net, davem@davemloft.net, herbert@gondor.hengli.com.au, mm-commits@vger.kernel.org


The patch titled
     drivers/crypto/n2_core.c: dubious error check
has been removed from the -mm tree.  Its filename was
     drivers-crypto-dubious-error-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
drivers-media-video-gspca-cpia1c-fix-error-check.patch

