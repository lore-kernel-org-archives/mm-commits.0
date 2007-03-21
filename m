From: akpm@linux-foundation.org
Subject: + char-cs5535_gpio-add-module_device_table.patch added to -mm tree
Date: Wed, 21 Mar 2007 16:21:34 -0700
Message-ID: <200703212321.l2LNLZZ8006746@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58261 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbXCUXVk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2007 19:21:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, bgardner@wabtec.com, david-b@pacbell.net


The patch titled
     Char: cs5535_gpio, add MODULE_DEVICE_TABLE
has been added to the -mm tree.  Its filename is
     char-cs5535_gpio-add-module_device_table.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+)

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

char-rocket-add-module_device_table.patch
char-cs5535_gpio-add-module_device_table.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
shrink_slab-handle-bad-shrinkers.patch
