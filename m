From: akpm@linux-foundation.org
Subject: [folded-merged] init-mainc-convert-to-pr_foo-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 16:02:49 -0700
Message-ID: <20130429230249.E5A845A418D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:47820 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758424Ab3D2XCv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 19:02:51 -0400
Received: by mail-ye0-f201.google.com with SMTP id m3so140203yen.2
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 16:02:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, richard@nod.at, u.kleine-koenig@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: init-mainc-convert-to-pr_foo-fix
has been removed from the -mm tree.  Its filename was
     init-mainc-convert-to-pr_foo-fix.patch

This patch was dropped because it was folded into init-mainc-convert-to=
-pr_foo.patch

------------------------------------------------------
=46rom: Andrew Morton <akpm@linux-foundation.org>
Subject: init-mainc-convert-to-pr_foo-fix

Cc: Richard Weinberger <richard@nod.at>
Cc: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN init/main.c~init-mainc-convert-to-pr_foo-fix init/main.c
--- a/init/main.c~init-mainc-convert-to-pr_foo-fix
+++ a/init/main.c
@@ -9,6 +9,8 @@
  *  Simplified starting of init:  Michael A. Griffith <grif@acm.org>=20
  */
=20
+#define DEBUG
+
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/proc_fs.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are


--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
