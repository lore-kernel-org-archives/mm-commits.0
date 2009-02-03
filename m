From: akpm@linux-foundation.org
Subject: + dvb-fix-kconfig-typo.patch added to -mm tree
Date: Tue, 03 Feb 2009 00:43:18 -0800
Message-ID: <200902030843.n138hIs1030528@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751212AbZBCInl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2009 03:43:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nm127@freemail.hu, mchehab@infradead.org


The patch titled
     dvb: fix Kconfig typo
has been added to the -mm tree.  Its filename is
     dvb-fix-kconfig-typo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: dvb: fix Kconfig typo
=46rom: M=E1rton N=E9meth <nm127@freemail.hu>

=46ix typo in "DAB adapters" section in Kconfig.

Signed-off-by: M=E1rton N=E9meth <nm127@freemail.hu>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/Kconfig~dvb-fix-kconfig-typo drivers/media/Kcon=
fig
--- a/drivers/media/Kconfig~dvb-fix-kconfig-typo
+++ a/drivers/media/Kconfig
@@ -117,7 +117,7 @@ source "drivers/media/dvb/Kconfig"
 config DAB
 	boolean "DAB adapters"
 	---help---
-	  Allow selecting support for for Digital Audio Broadcasting (DAB)
+	  Allow selecting support for Digital Audio Broadcasting (DAB)
 	  Receiver adapters.
=20
 if DAB
_

Patches currently in -mm which might be from nm127@freemail.hu are

dvb-fix-kconfig-typo.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
