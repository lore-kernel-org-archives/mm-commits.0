From: akpm@linux-foundation.org
Subject: - add-manufacturer-and-card-id-of-teltonica-pcmcia-modems.patch removed from -mm tree
Date: Wed, 10 Oct 2007 14:10:08 -0700
Message-ID: <200710102110.l9ALA8Up025904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34208 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756449AbXJJVKk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Oct 2007 17:10:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: attila@kinali.ch, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Add manufacturer and card id of teltonica pcmcia modems
has been removed from the -mm tree.  Its filename was
     add-manufacturer-and-card-id-of-teltonica-pcmcia-modems.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add manufacturer and card id of teltonica pcmcia modems
From: Attila Kinali <attila@kinali.ch>

Add the manufacturer and card id of teltonica pcmcia modems to serial_cs.c

Signed-off-by: Attila Kinali <attila@kinali.ch>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_cs.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/serial/serial_cs.c~add-manufacturer-and-card-id-of-teltonica-pcmcia-modems drivers/serial/serial_cs.c
--- a/drivers/serial/serial_cs.c~add-manufacturer-and-card-id-of-teltonica-pcmcia-modems
+++ a/drivers/serial/serial_cs.c
@@ -943,6 +943,7 @@ static struct pcmcia_device_id serial_id
 	PCMCIA_MFC_DEVICE_PROD_ID12(1,"Elan","Serial Port: SL432",0x3beb8cf2,0x1cce7ac4),
 	PCMCIA_MFC_DEVICE_PROD_ID12(2,"Elan","Serial Port: SL432",0x3beb8cf2,0x1cce7ac4),
 	PCMCIA_MFC_DEVICE_PROD_ID12(3,"Elan","Serial Port: SL432",0x3beb8cf2,0x1cce7ac4),
+	PCMCIA_DEVICE_MANF_CARD(0x0279, 0x950b),
 	/* too generic */
 	/* PCMCIA_MFC_DEVICE_MANF_CARD(0, 0x0160, 0x0002), */
 	/* PCMCIA_MFC_DEVICE_MANF_CARD(1, 0x0160, 0x0002), */
_

Patches currently in -mm which might be from attila@kinali.ch are
