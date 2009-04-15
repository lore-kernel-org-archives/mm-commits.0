From: akpm@linux-foundation.org
Subject: + drivers-media-dvb-frontends-stv0900_privh-remove-broken-unused-macro.patch added to -mm tree
Date: Wed, 15 Apr 2009 14:42:29 -0700
Message-ID: <200904152142.n3FLgTC0017580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753084AbZDOVo5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Apr 2009 17:44:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, mchehab@infradead.org


The patch titled
     drivers/media/dvb/frontends/stv0900_priv.h: remove broken, unused macro
has been added to the -mm tree.  Its filename is
     drivers-media-dvb-frontends-stv0900_privh-remove-broken-unused-macro.patch

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
Subject: drivers/media/dvb/frontends/stv0900_priv.h: remove broken, unused macro
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

It both has unbalanced parentheses and == is not = and it's not used
anywhere anyway.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/frontends/stv0900_priv.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/media/dvb/frontends/stv0900_priv.h~drivers-media-dvb-frontends-stv0900_privh-remove-broken-unused-macro drivers/media/dvb/frontends/stv0900_priv.h
--- a/drivers/media/dvb/frontends/stv0900_priv.h~drivers-media-dvb-frontends-stv0900_privh-remove-broken-unused-macro
+++ a/drivers/media/dvb/frontends/stv0900_priv.h
@@ -60,8 +60,6 @@
 		} \
 	} while (0)
 
-#define dmd_choose(a, b)	(demod = STV0900_DEMOD_2 ? b : a))
