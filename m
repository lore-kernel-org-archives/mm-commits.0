From: akpm@linux-foundation.org
Subject: - char-cs5535_gpio-add-module_device_table.patch removed from -mm tree
Date: Tue, 08 May 2007 19:47:28 -0700
Message-ID: <200705090247.l492lS6K008978@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58039 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031868AbXEICrf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:47:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, bgardner@wabtec.com, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     Char: cs5535_gpio, add MODULE_DEVICE_TABLE
has been removed from the -mm tree.  Its filename was
     char-cs5535_gpio-add-module_device_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cs5535_gpio, add MODULE_DEVICE_TABLE
From: Jiri Slaby <jirislaby@gmail.com>

cs5535_gpio, add MODULE_DEVICE_TABLE

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Ben Gardner <bgardner@wabtec.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cs5535_gpio.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/char/cs5535_gpio.c~char-cs5535_gpio-add-module_device_table drivers/char/cs5535_gpio.c
--- a/drivers/char/cs5535_gpio.c~char-cs5535_gpio-add-module_device_table
+++ a/drivers/char/cs5535_gpio.c
@@ -44,6 +44,7 @@ static struct pci_device_id divil_pci[] 
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA) },
 	{ } /* NULL entry */
 };
+MODULE_DEVICE_TABLE(pci, divil_pci);
 
 static struct cdev cs5535_gpio_cdev;
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events-fix.patch
shrink_slab-handle-bad-shrinkers.patch
