From: akpm@linux-foundation.org
Subject: [merged] drivers-media-dvb-frontends-stv0900_privh-remove-broken-unused-macro.patch removed from -mm tree
Date: Thu, 30 Apr 2009 11:44:16 -0700
Message-ID: <200904301844.n3UIiGr6002348@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763679AbZD3Sqo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Apr 2009 14:46:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/media/dvb/frontends/stv0900_priv.h: remove broken, unused macro
has been removed from the -mm tree.  Its filename was
     drivers-media-dvb-frontends-stv0900_privh-remove-broken-unused-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
