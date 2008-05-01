From: akpm@linux-foundation.org
Subject: - char-moxa-update-credits.patch removed from -mm tree
Date: Thu, 01 May 2008 02:29:32 -0700
Message-ID: <200805010929.m419TWeN030688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52445 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756795AbYEAJ3g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:29:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, update credits
has been removed from the -mm tree.  Its filename was
     char-moxa-update-credits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: moxa, update credits
From: Jiri Slaby <jirislaby@gmail.com>

- update version
- update maintainers
- copyright the stuff

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS         |    2 +-
 drivers/char/moxa.c |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~char-moxa-update-credits MAINTAINERS
--- a/MAINTAINERS~char-moxa-update-credits
+++ a/MAINTAINERS
@@ -2759,7 +2759,7 @@ M:	rubini@ipvvis.unipv.it
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
-MOXA SMARTIO/INDUSTIO SERIAL CARD (MXSER 2.0)
+MOXA SMARTIO/INDUSTIO/INTELLIO SERIAL CARD
 P:	Jiri Slaby
 M:	jirislaby@gmail.com
 L:	linux-kernel@vger.kernel.org
diff -puN drivers/char/moxa.c~char-moxa-update-credits drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-update-credits
+++ a/drivers/char/moxa.c
@@ -2,7 +2,8 @@
 /*
  *           moxa.c  -- MOXA Intellio family multiport serial driver.
  *
- *      Copyright (C) 1999-2000  Moxa Technologies (support@moxa.com.tw).
+ *      Copyright (C) 1999-2000  Moxa Technologies (support@moxa.com).
+ *      Copyright (c) 2007 Jiri Slaby <jirislaby@gmail.com>
  *
  *      This code is loosely based on the Linux serial driver, written by
  *      Linus Torvalds, Theodore T'so and others.
@@ -49,7 +50,7 @@
 
 #include "moxa.h"
 
-#define MOXA_VERSION		"5.1k"
+#define MOXA_VERSION		"6.0k"
 
 #define MOXA_FW_HDRLEN		32
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

