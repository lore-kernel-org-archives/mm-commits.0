From: akpm@linux-foundation.org
Subject: - char-mxser-obsolete-old-nonexperimental-new.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:51:47 -0800
Message-ID: <200702112251.l1BMplbD015963@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60165 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932765AbXBKWvt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:51:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: mxser, obsolete old, nonexperimental new
has been removed from the -mm tree.  Its filename was
     char-mxser-obsolete-old-nonexperimental-new.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: mxser, obsolete old, nonexperimental new
From: Jiri Slaby <jirislaby@gmail.com>

Mark v 1.x as obsolete and v 2.x as non-experimental in Kconfig.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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

origin.patch
char-use-more-pci_device-macro.patch
char-cyclades-use-pci_device_id.patch
maintainers-remove-two-dead-e-mail.patch
char-specialix-isr-have-2-params.patch
char-timers-cleanup.patch
fbdev-driver-for-s3-trio-virge-update-2-fix.patch
video-fb-add-true-ref_count-atomicity.patch
video-fb-kzalloc-changes.patch
shrink_slab-handle-bad-shrinkers.patch
