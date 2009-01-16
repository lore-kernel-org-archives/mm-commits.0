From: akpm@linux-foundation.org
Subject: + mmc-add-extended-csd-as-a-device-attribute-update.patch added to -mm tree
Date: Fri, 16 Jan 2009 14:29:28 -0800
Message-ID: <200901162229.n0GMTS64017748@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755551AbZAPW3l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 17:29:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-adrian.hunter@nokia.com, drzeus-list@drzeus.cx


The patch titled
     mmc-add-extended-csd-as-a-device-attribute update
has been added to the -mm tree.  Its filename is
     mmc-add-extended-csd-as-a-device-attribute-update.patch

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

mmc-add-extended-csd-as-a-device-attribute.patch
mmc-add-extended-csd-as-a-device-attribute-update.patch

