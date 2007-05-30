From: akpm@linux-foundation.org
Subject: + char-kconfig-mxser_new-remove-experimental-comment.patch added to -mm tree
Date: Tue, 29 May 2007 20:09:11 -0700
Message-ID: <200705300309.l4U39A2d018119@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751134AbXE3DJR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 23:09:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: Kconfig, mxser_new: remove experimental comment
has been added to the -mm tree.  Its filename is
     char-kconfig-mxser_new-remove-experimental-comment.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: Kconfig, mxser_new: remove experimental comment
From: Jiri Slaby <jirislaby@gmail.com>

Kconfig, mxser_new: remove experimental comment

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/char/Kconfig~char-kconfig-mxser_new-remove-experimental-comment drivers/char/Kconfig
--- a/drivers/char/Kconfig~char-kconfig-mxser_new-remove-experimental-comment
+++ a/drivers/char/Kconfig
@@ -213,8 +213,6 @@ config MOXA_SMARTIO_NEW
 	  This is upgraded (1.9.1) driver from original Moxa drivers with
 	  changes finally resulting in PCI probing.
 
-	  Use at your own risk.
-
 	  This driver can also be built as a module. The module will be called
 	  mxser_new. If you want to do that, say M here.
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

rocketc-fix-unchecked-mutex_lock_interruptible.patch
char-n_hdlc-allow-restartsys-retval-of-tty-write.patch
char-mxser_new-fix-sparse-warning.patch
char-tty_ioctl-use-wait_event_interruptible_timeout.patch
char-tty_ioctl-little-whitespace-cleanup.patch
char-genrtc-use-wait_event_interruptible.patch
char-n_r3964-use-wait_event_interruptible.patch
char-ip2-use-msleep-for-sleeping.patch
char-cyclades-add-firmware-loading.patch
char-cyclades-fix-sparse-warning.patch
char-isicom-cleanup-locking.patch
char-isicom-del_timer-at-exit.patch
char-isicom-proper-variables-types.patch
char-moxa-eliminate-busy-waiting.patch
char-specialix-remove-busy-waiting.patch
char-riscom8-eliminate-busy-loop.patch
char-vt-use-kzalloc.patch
char-vt-use-array_size.patch
char-kconfig-mxser_new-remove-experimental-comment.patch
shrink_slab-handle-bad-shrinkers.patch
