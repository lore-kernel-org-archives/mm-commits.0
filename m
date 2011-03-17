From: akpm@linux-foundation.org
Subject: + drivers-misc-pch_phubc-add-module_device_table.patch added to -mm tree
Date: Thu, 17 Mar 2011 14:24:42 -0700
Message-ID: <201103172124.p2HLOgBn011267@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755673Ab1CQVYw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Mar 2011 17:24:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, gregkh@suse.de, masa-korg@dsn.okisemi.com


The patch titled
     drivers/misc/pch_phub.c: add MODULE_DEVICE_TABLE
has been added to the -mm tree.  Its filename is
     drivers-misc-pch_phubc-add-module_device_table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/misc/pch_phub.c: add MODULE_DEVICE_TABLE
From: Axel Lin <axel.lin@gmail.com>

The device table is required to load modules based on modaliases.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/pch_phub.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/misc/pch_phub.c~drivers-misc-pch_phubc-add-module_device_table drivers/misc/pch_phub.c
--- a/drivers/misc/pch_phub.c~drivers-misc-pch_phubc-add-module_device_table
+++ a/drivers/misc/pch_phub.c
@@ -731,6 +731,7 @@ static struct pci_device_id pch_phub_pci
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ROHM_ML7213_PHUB), 2,  },
 	{ }
 };
+MODULE_DEVICE_TABLE(pci, pch_phub_pcidev_id);
 
 static struct pci_driver pch_phub_driver = {
 	.name = "pch_phub",
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch
drivers-video-backlight-jornada720_c-make-needlessly-global-symbols-static.patch
drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv.patch
drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv-fix.patch
drivers-misc-atmel_tclibc-fix-a-memory-leak.patch
drivers-misc-pch_phubc-add-module_device_table.patch

