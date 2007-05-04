From: akpm@linux-foundation.org
Subject: + char-cyclades-mark-cyy_init_card-as-__devinit-not-__init.patch added to -mm tree
Date: Thu, 03 May 2007 23:45:31 -0700
Message-ID: <200705040645.l446jVDs030877@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965730AbXEDGpe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 02:45:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: cyclades, mark cyy_init_card as __devinit, not __init
has been added to the -mm tree.  Its filename is
     char-cyclades-mark-cyy_init_card-as-__devinit-not-__init.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: cyclades, mark cyy_init_card as __devinit, not __init
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-mark-cyy_init_card-as-__devinit-not-__init drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-mark-cyy_init_card-as-__devinit-not-__init
+++ a/drivers/char/cyclades.c
@@ -4651,8 +4651,8 @@ static void __devinit cy_init_card(struc
 
 /* initialize chips on Cyclom-Y card -- return number of valid
    chips (which is number of ports/4) */
-static unsigned short __init
-cyy_init_card(void __iomem * true_base_addr, int index)
+static unsigned short __devinit cyy_init_card(void __iomem *true_base_addr,
+		int index)
 {
 	unsigned int chip_number;
 	void __iomem *base_addr;
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
