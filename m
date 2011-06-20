From: akpm@linux-foundation.org
Subject: + drivers-ata-pata_marvellc-add-support-for-88se91a0-88se91a4.patch added to -mm tree
Date: Mon, 20 Jun 2011 16:29:28 -0700
Message-ID: <201106202329.p5KNTSLY029777@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755285Ab1FTX3k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jun 2011 19:29:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: czajernia@gmail.com, jeff@garzik.org, tj@kernel.org


The patch titled
     drivers/ata/pata_marvell.c: add support for 88SE91A0, 88SE91A4
has been added to the -mm tree.  Its filename is
     drivers-ata-pata_marvellc-add-support-for-88se91a0-88se91a4.patch

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
Subject: drivers/ata/pata_marvell.c: add support for 88SE91A0, 88SE91A4
From: Pawel Drewniak <czajernia@gmail.com>

Enable support for Marvell IDE PATA controllers found on the Asus P8P67LE
motherboard.

I received a report from two users of this motherboard that the patch works.

Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_marvell.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/ata/pata_marvell.c~drivers-ata-pata_marvellc-add-support-for-88se91a0-88se91a4 drivers/ata/pata_marvell.c
--- a/drivers/ata/pata_marvell.c~drivers-ata-pata_marvellc-add-support-for-88se91a0-88se91a4
+++ a/drivers/ata/pata_marvell.c
@@ -161,6 +161,8 @@ static const struct pci_device_id marvel
 	{ PCI_DEVICE(0x11AB, 0x6121), },
 	{ PCI_DEVICE(0x11AB, 0x6123), },
 	{ PCI_DEVICE(0x11AB, 0x6145), },
+	{ PCI_DEVICE(0x1B4B, 0x91A0), },
+	{ PCI_DEVICE(0x1B4B, 0x91A4), },
 	{ }	/* terminate list */
 };
 
_

Patches currently in -mm which might be from czajernia@gmail.com are

drivers-ata-pata_marvellc-add-support-for-88se91a0-88se91a4.patch

