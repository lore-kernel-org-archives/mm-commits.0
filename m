From: akpm@linux-foundation.org
Subject: [merged] lib-rationalc-needs-moduleh.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:18:12 -0800
Message-ID: <201001112018.o0BKIC1m025472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751087Ab0AKUhc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:37:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: s.hauer@pengutronix.de, os@emlix.com, stable@kernel.org, u.kleine-koenig@pengutronix.de, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     lib/rational.c needs module.h
has been removed from the -mm tree.  Its filename was
     lib-rationalc-needs-moduleh.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: lib/rational.c needs module.h
=46rom: Sascha Hauer <s.hauer@pengutronix.de>

lib/rational.c:62: warning: data definition has no type or storage clas=
s
lib/rational.c:62: warning: type defaults to 'int' in declaration of 'E=
XPORT_SYMBOL'
lib/rational.c:62: warning: parameter names (without types) in function=
 declaration

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Oskar Schirmer <os@emlix.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rational.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/rational.c~lib-rationalc-needs-moduleh lib/rational.c
--- a/lib/rational.c~lib-rationalc-needs-moduleh
+++ a/lib/rational.c
@@ -7,6 +7,7 @@
  */
=20
 #include <linux/rational.h>
+#include <linux/module.h>
=20
 /*
  * calculate best rational approximation for a given fraction
_

Patches currently in -mm which might be from s.hauer@pengutronix.de are

origin.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
