From: akpm@linux-foundation.org
Subject: + mmc-add-ricoh-e822-pci-id.patch added to -mm tree
Date: Wed, 04 Aug 2010 16:06:26 -0700
Message-ID: <201008042306.o74N6Qq6015576@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41974 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755468Ab0HDXGi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Aug 2010 19:06:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: CyberCastle@gmail.com, gregg@lebovitz.net, maximlevitsky@gmail.com, sgruszka@redhat.com


The patch titled
     mmc: add ricoh e822 pci id
has been added to the -mm tree.  Its filename is
     mmc-add-ricoh-e822-pci-id.patch

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
Subject: mmc: add ricoh e822 pci id
From: <CyberCastle@gmail.com>

Signed-off-by: <CyberCastle@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Tested-by: Gregg Lebovitz <gregg@lebovitz.net>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci-pci.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/mmc/host/sdhci-pci.c~mmc-add-ricoh-e822-pci-id drivers/mmc/host/sdhci-pci.c
--- a/drivers/mmc/host/sdhci-pci.c~mmc-add-ricoh-e822-pci-id
+++ a/drivers/mmc/host/sdhci-pci.c
@@ -415,6 +415,14 @@ static const struct pci_device_id pci_id
 	},
 
 	{
+		.vendor         = PCI_VENDOR_ID_RICOH,
+		.device         = 0xe822,
+		.subvendor      = PCI_ANY_ID,
+		.subdevice      = PCI_ANY_ID,
+		.driver_data    = (kernel_ulong_t)&sdhci_ricoh_mmc,
+	},
+
+	{
 		.vendor		= PCI_VENDOR_ID_ENE,
 		.device		= PCI_DEVICE_ID_ENE_CB712_SD,
 		.subvendor	= PCI_ANY_ID,
_

Patches currently in -mm which might be from CyberCastle@gmail.com are

mmc-add-ricoh-e822-pci-id.patch

