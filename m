From: akpm@osdl.org
Subject: - char-mxser_new-alter-license-terms.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:07:06 -0800
Message-ID: <200612082007.kB8K76GB002484@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57821 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426354AbWLHUHK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:07:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: mxser_new, alter license terms
has been removed from the -mm tree.  Its filename was
     char-mxser_new-alter-license-terms.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: mxser_new, alter license terms
From: Jiri Slaby <jirislaby@gmail.com>

- We don't need useless paragraphs in license terms.

- Add me to copyright.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/mxser_new.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff -puN drivers/char/mxser_new.c~char-mxser_new-alter-license-terms drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-alter-license-terms
+++ a/drivers/char/mxser_new.c
@@ -2,31 +2,23 @@
  *          mxser.c  -- MOXA Smartio/Industio family multiport serial driver.
  *
  *      Copyright (C) 1999-2006  Moxa Technologies (support@moxa.com.tw).
+ *	Copyright (C) 2006       Jiri Slaby <jirislaby@gmail.com>
  *
- *      This code is loosely based on the Linux serial driver, written by
- *      Linus Torvalds, Theodore T'so and others.
+ *      This code is loosely based on the 1.8 moxa driver which is based on
+ *	Linux serial driver, written by Linus Torvalds, Theodore T'so and
+ *	others.
  *
  *      This program is free software; you can redistribute it and/or modify
  *      it under the terms of the GNU General Public License as published by
  *      the Free Software Foundation; either version 2 of the License, or
  *      (at your option) any later version.
  *
- *      This program is distributed in the hope that it will be useful,
- *      but WITHOUT ANY WARRANTY; without even the implied warranty of
- *      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *      GNU General Public License for more details.
- *
- *      You should have received a copy of the GNU General Public License
- *      along with this program; if not, write to the Free Software
- *      Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
  *	Fed through a cleanup, indent and remove of non 2.6 code by Alan Cox
  *	<alan@redhat.com>. The original 1.8 code is available on www.moxa.com.
  *	- Fixed x86_64 cleanness
  *	- Fixed sleep with spinlock held in mxser_send_break
  */
 
-
 #include <linux/module.h>
 #include <linux/autoconf.h>
 #include <linux/errno.h>
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-mxser_new-alter-license-terms.patch
char-mxser_new-code-upside-down.patch
char-mxser_new-cmspar-is-defined.patch
char-remove-unneded-termbits-redefinitions-mxser_new.patch
char-mxser_new-eliminate-tty-ldisc-deref.patch
char-mxser_new-testbit-for-bit-testing.patch
char-mxser_new-correct-fail-paths.patch
char-mxser_new-dont-check-tty_unregister-retval.patch
char-mxser_new-compress-isa-finding.patch
char-mxser_new-register-tty-devices-on-the-fly.patch
char-mxser_new-compact-structures-round2.patch
char-mxser_new-reverse-if-else-paths-patch.patch
char-mxser_new-comments-cleanup.patch
char-mxser_new-correct-intr-handler-proto.patch
char-mxser_new-delete-ttys-and-termios.patch
char-mxser_new-pci-probing.patch
char-mxser_new-clean-macros.patch
maintainers-add-me-to-isicom-mxser.patch
mxser_new-correct-tty-driver-name.patch
mxser-workqueue-fixes.patch
char-stallion-use-pr_debug-macro.patch
char-stallion-remove-unneeded-casts.patch
char-stallion-kill-typedefs.patch
char-stallion-move-init-deinit.patch
char-stallion-uninline-functions.patch
char-stallion-mark-functions-as-init.patch
char-stallion-remove-many-prototypes.patch
char-isicom-expand-function.patch
char-isicom-rename-init-function.patch
char-isicom-remove-isa-code.patch
char-isicom-remove-unneeded-memset.patch
char-isicom-move-to-tty_register_device.patch
char-isicom-use-pci_request_region.patch
char-isicom-check-kmalloc-retval.patch
char-isicom-use-completion.patch
char-isicom-simplify-timer.patch
char-isicom-remove-cvs-stuff.patch
char-isicom-fix-tty-index-check.patch
char-sx-convert-to-pci-probing.patch
char-sx-use-kcalloc.patch
char-sx-mark-functions-as-devinit.patch
char-sx-use-eisa-probing.patch
char-sx-ifdef-isa-code.patch
char-sx-lock-boards-struct.patch
char-sx-remove-duplicite-code.patch
char-sx-whitespace-cleanup.patch
char-sx-simplify-timer-logic.patch
char-sx-fix-return-in-module-init.patch
char-sx-use-pci_iomap.patch
char-sx-request-regions.patch
char-stallion-convert-to-pci-probing.patch
char-stallion-prints-cleanup.patch
char-stallion-implement-fail-paths.patch
char-stallion-correct-__init-macros.patch
char-stallion-functions-cleanup.patch
char-stallion-fix-fail-paths.patch
char-stallion-brd-struct-locking.patch
char-stallion-remove-syntactic-sugar.patch
char-stallion-variables-cleanup.patch
char-stallion-use-dynamic-dev.patch
char-istallion-convert-to-pci-probing.patch
char-istallion-remove-the-mess.patch
char-istallion-eliminate-typedefs.patch
char-istallion-variables-cleanup.patch
char-istallion-ifdef-eisa-code.patch
char-istallion-brdnr-locking.patch
char-istallion-free-only-isa.patch
char-istallion-correct-fail-paths.patch
char-istallion-fix-enabling.patch
char-istallion-move-init-and-exit-code.patch
char-istallion-change-init-sequence.patch
char-istallion-dynamic-tty-device.patch
char-istallion-use-mod_timer.patch
char-cyclades-save-indent-levels.patch
char-cyclades-lindent-the-code.patch
char-cyclades-cleanup.patch
char-cyclades-fix-warnings.patch

