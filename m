From: akpm@osdl.org
Subject: + char-mxser-obsolete-old-nonexperimental-new.patch added to -mm tree
Date: Thu, 28 Dec 2006 15:22:50 -0800
Message-ID: <200612282322.kBSNMo9w015991@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41038 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924AbWL1XWx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Dec 2006 18:22:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: mxser, obsolete old, nonexperimental new
has been added to the -mm tree.  Its filename is
     char-mxser-obsolete-old-nonexperimental-new.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: mxser, obsolete old, nonexperimental new
From: Jiri Slaby <jirislaby@gmail.com>

Mark v 1.x as obsolete and v 2.x as non-experimental in Kconfig.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/Kconfig~char-mxser-obsolete-old-nonexperimental-new drivers/char/Kconfig
--- a/drivers/char/Kconfig~char-mxser-obsolete-old-nonexperimental-new
+++ a/drivers/char/Kconfig
@@ -191,7 +191,7 @@ config MOXA_INTELLIO
 	  module will be called moxa.
 
 config MOXA_SMARTIO
-	tristate "Moxa SmartIO support"
+	tristate "Moxa SmartIO support (OBSOLETE)"
 	depends on SERIAL_NONSTANDARD
 	help
 	  Say Y here if you have a Moxa SmartIO multiport serial card.
@@ -202,7 +202,7 @@ config MOXA_SMARTIO
 	  here.
 
 config MOXA_SMARTIO_NEW
-	tristate "Moxa SmartIO support v. 2.0 (EXPERIMENTAL)"
+	tristate "Moxa SmartIO support v. 2.0"
 	depends on SERIAL_NONSTANDARD && (PCI || EISA || ISA)
 	help
 	  Say Y here if you have a Moxa SmartIO multiport serial card and/or
_

Patches currently in -mm which might be from jirislaby@gmail.com are

add-gitignore-file-for-relocs-in-arch-i386-fix.patch
char-mxser-fix-oops-when-removing-opened.patch
char-isicom-eliminate-spinlock-recursion.patch
git-input.patch
char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-isicom-remove-tty_hangwakeup-bottomhalves.patch
mxser-remove-ambiguous-redefinition-of-init_work.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
char-isicom-fix-locking-in-isr.patch
char-isicom-augment-card_reset.patch
char-isicom-check-card-state-in-isr.patch
char-isicom-support-higher-rates.patch
char-isicom-correct-probing-removing.patch
char-tty_wakeup-cleanup.patch
char-mxser_new-mark-init-functions.patch
char-mxser_new-remove-useless-spinlock.patch
char-serial167-cleanup.patch
char-n_r3964-cleanup.patch
char-mxser_new-remove-unused-stuff.patch
char-mxser-obsolete-old-nonexperimental-new.patch
char-mxser_new-remove-tty_wakeup-bottomhalf.patch
char-mxser_new-clean-request_irq-call.patch
shrink_slab-handle-bad-shrinkers.patch

