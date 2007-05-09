From: akpm@linux-foundation.org
Subject: - char-cyclades-copyright-and-version-changes.patch removed from -mm tree
Date: Tue, 08 May 2007 19:59:00 -0700
Message-ID: <200705090259.l492x0WW010342@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970175AbXEIC7F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:59:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, copyright and version changes
has been removed from the -mm tree.  Its filename was
     char-cyclades-copyright-and-version-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cyclades, copyright and version changes
From: Jiri Slaby <jirislaby@gmail.com>

- add copyright
- move version one number upper and use MODULE_VERSION

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-copyright-and-version-changes drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-copyright-and-version-changes
+++ a/drivers/char/cyclades.c
@@ -10,15 +10,14 @@
  *
  * Initially written by Randolph Bentson <bentson@grieg.seaslug.org>.
  * Modified and maintained by Marcio Saito <marcio@cyclades.com>.
- * Currently maintained by Cyclades team <async@cyclades.com>.
  *
- * For Technical support and installation problems, please send e-mail
- * to support@cyclades.com.
+ * Copyright (C) 2007 Jiri Slaby <jirislaby@gmail.com>
  *
  * Much of the design and some of the code came from serial.c
  * which was copyright (C) 1991, 1992  Linus Torvalds.  It was
  * extensively rewritten by Theodore Ts'o, 8/16/92 -- 9/14/92,
  * and then fixed as suggested by Michael K. Johnson 12/12/92.
+ * Converted to pci probing and cleaned up by Jiri Slaby.
  *
  * This version supports shared IRQ's (only for PCI boards).
  *
@@ -591,7 +590,7 @@
  *
  */
 
-#define CY_VERSION	"2.4"
+#define CY_VERSION	"2.5"
 
 /* If you need to install more boards than NR_CARDS, change the constant
    in the definition below. No other change is necessary to support up to
@@ -5240,3 +5239,4 @@ module_init(cy_init);
 module_exit(cy_cleanup_module);
 
 MODULE_LICENSE("GPL");
+MODULE_VERSION(CY_VERSION);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events-fix.patch
shrink_slab-handle-bad-shrinkers.patch
