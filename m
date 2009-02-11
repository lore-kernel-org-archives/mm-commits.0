From: akpm@linux-foundation.org
Subject: [folded] mmc-add-extended-csd-as-a-device-attribute-update.patch removed from -mm tree
Date: Wed, 11 Feb 2009 13:25:34 -0800
Message-ID: <200902112125.n1BLPYVd029157@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756369AbZBKVZo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 16:25:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ext-adrian.hunter@nokia.com, drzeus-list@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     mmc-add-extended-csd-as-a-device-attribute update
has been removed from the -mm tree.  Its filename was
     mmc-add-extended-csd-as-a-device-attribute-update.patch

This patch was dropped because it was folded into mmc-add-extended-csd-as-a-device-attribute.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc-add-extended-csd-as-a-device-attribute update
From: Adrian Hunter <ext-adrian.hunter@nokia.com>

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/mmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/core/mmc.c~mmc-add-extended-csd-as-a-device-attribute-update drivers/mmc/core/mmc.c
--- a/drivers/mmc/core/mmc.c~mmc-add-extended-csd-as-a-device-attribute-update
+++ a/drivers/mmc/core/mmc.c
@@ -276,7 +276,7 @@ static ssize_t mmc_ext_csd_show(struct d
 
 	if (!err) {
 		for (i = 511; i >= 0; i--)
-			n += sprintf(buf + n, "%02x", (unsigned)ext_csd[i]);
+			n += sprintf(buf + n, "%02x", ext_csd[i]);
 		n += sprintf(buf + n, "\n");
 	}
 
_

Patches currently in -mm which might be from ext-adrian.hunter@nokia.com are

linux-next.patch
mmc-add-extended-csd-as-a-device-attribute.patch
mmc-add-extended-csd-as-a-device-attribute-update.patch
omap-mmc-recover-from-transfer-failures-resend.patch
omap-mmc-replace-infinite-loops-with-timeouts.patch

