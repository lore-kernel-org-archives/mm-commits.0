From: akpm@linux-foundation.org
Subject: + char-cyclades-copyright-and-version-changes.patch added to -mm tree
Date: Thu, 03 May 2007 23:45:57 -0700
Message-ID: <200705040645.l446jvjx030916@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767709AbXEDGqB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 02:46:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: cyclades, copyright and version changes
has been added to the -mm tree.  Its filename is
     char-cyclades-copyright-and-version-changes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

serial-serial_core-use-pr_debug.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
char-rocket-add-module_device_table.patch
char-cs5535_gpio-add-module_device_table.patch
drivers-char-use-__set_current_state.patch
misc-add-sensable-phantom-driver.patch
misc-add-sensable-phantom-driver-v3.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
char-cyclades-remove-pause.patch
char-cyclades-cy_readx-writex-cleanup.patch
char-cyclades-timer-cleanup.patch
char-cyclades-remove-volatiles.patch
char-cyclades-remove-useless-casts.patch
char-cyclades-create-cy_init_ze.patch
char-cyclades-use-pci_iomap-unmap.patch
char-cyclades-init-ze-immediately.patch
char-cyclades-create-cy_pci_probe.patch
char-cyclades-move-card-entries-init-into-function.patch
char-cyclades-init-card-struct-immediately.patch
char-cyclades-remove-some-global-vars.patch
char-cyclades-cy_init-error-handling.patch
char-cyclades-tty_register_device-separately-for-each-device.patch
char-cyclades-clear-interrupts-before-releasing.patch
char-cyclades-allow-debug_shirq.patch
char-mxser-schedule-for-removal.patch
char-isicom-use-pr_debug.patch
char-cyclades-use-is_cyc_z-macro.patch
char-cyclades-switch-to-pci-probing.patch
char-cyclades-depends-on-pci-or-isa.patch
char-cyclades-unexport-struct-cyclades_card.patch
char-cyclades-remove-useless-fileds-from-cyclades_card.patch
char-cyclades-irq-is-int.patch
char-cyclades-printk-cleanups.patch
char-cyclades-mark-cyy_init_card-as-__devinit-not-__init.patch
char-cyclades-simplify-variables-initialization.patch
char-cyclades-get-rid-of-phys-addresses.patch
char-cyclades-make-info-card-a-pointer.patch
char-cyclades-remove-sleep_on.patch
char-cyclades-fix-blockmove.patch
char-cyclades-timers-cleanup.patch
char-cyclades-remove-unused-timestamps.patch
char-cyclades-remove-locking-macros.patch
char-cyclades-conditions-cleanup.patch
char-cyclades-fix-tty-device-unregister.patch
char-cyclades-dynamic-ports.patch
char-cyclades-probe-cleanup.patch
char-cyclades-copyright-and-version-changes.patch
shrink_slab-handle-bad-shrinkers.patch
