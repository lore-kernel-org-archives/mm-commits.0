From: akpm@linux-foundation.org
Subject: + char-moxa-update-credits.patch added to -mm tree
Date: Wed, 27 Feb 2008 15:13:39 -0800
Message-ID: <200802272313.m1RNDd4B003316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755218AbYB0XSe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 18:18:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: moxa, update credits
has been added to the -mm tree.  Its filename is
     char-moxa-update-credits.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -2686,7 +2686,7 @@ M:	rubini@ipvvis.unipv.it
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

git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
wdev-ath5k-typecheck-on-nondebug.patch
misc-phantom-add-compat-ioctl.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
misc-phantom-fix-poll.patch
mxser-prepare-for-bkl-pushdown.patch
tty-bkl-pushdown-fix.patch
tty-bkl-pushdown-fix1.patch
char-moxa-remove-static-isa-support.patch
char-moxa-cleanup-module-param-passed-isa-init.patch
char-moxa-pci-io-space-fixup.patch
char-moxa-fix-tiocg-ssoftcar-param.patch
char-moxa-add-firmware-loading.patch
char-moxa-merge-c2xx-and-c320-firmware-loading.patch
char-moxa-remove-port-port.patch
char-moxa-remove-unused-port-entries.patch
char-moxa-centralize-board-readiness.patch
char-moxa-timer-cleanup.patch
char-moxa-ioctl-cleanup.patch
char-moxa-merge-2-poll-functions.patch
char-moxa-cleanup-rx-tx.patch
char-moxa-serialise-timer.patch
char-moxa-rework-open-close.patch
char-moxa-little-cleanup.patch
char-moxa-remove-useless-tty-functions.patch
char-moxa-introduce-moxa_is_320-macro.patch
char-moxa-notify-about-board-readiness.patch
char-moxa-update-credits.patch
char-moxa-add-firmware-loading-fix.patch
mxser-convert-large-macros-to-functions.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
