From: akpm@linux-foundation.org
Subject: [folded-merged] init-mainc-convert-to-pr_foo-fix-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 16:02:52 -0700
Message-ID: <20130429230252.A79655A418D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:33897 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758424Ab3D2XCx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 19:02:53 -0400
Received: by mail-qe0-f73.google.com with SMTP id 9so486542qea.0
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 16:02:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, richard@nod.at, u.kleine-koenig@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: init-mainc-convert-to-pr_foo-fix-fix
has been removed from the -mm tree.  Its filename was
     init-mainc-convert-to-pr_foo-fix-fix.patch

This patch was dropped because it was folded into init-mainc-convert-to=
-pr_foo.patch

------------------------------------------------------
=46rom: Andrew Morton <akpm@linux-foundation.org>
Subject: init-mainc-convert-to-pr_foo-fix-fix

Cc: Richard Weinberger <richard@nod.at>
Cc: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/main.c~init-mainc-convert-to-pr_foo-fix-fix init/main.c
--- a/init/main.c~init-mainc-convert-to-pr_foo-fix-fix
+++ a/init/main.c
@@ -9,7 +9,7 @@
  *  Simplified starting of init:  Michael A. Griffith <grif@acm.org>=20
  */
=20
-#define DEBUG
+#define DEBUG		/* Enable initcall_debug */
=20
 #include <linux/types.h>
 #include <linux/module.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are


--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
