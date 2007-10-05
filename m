From: akpm@linux-foundation.org
Subject: + add-manufacturer-and-card-id-of-teltonica-pcmcia-modems.patch added to -mm tree
Date: Fri, 05 Oct 2007 16:03:23 -0700
Message-ID: <200710052303.l95N3N9A029506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36630 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756126AbXJEXEA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 19:04:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: attila@kinali.ch, alan@redhat.com


The patch titled
     Add manufacturer and card id of teltonica pcmcia modems
has been added to the -mm tree.  Its filename is
     add-manufacturer-and-card-id-of-teltonica-pcmcia-modems.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add manufacturer and card id of teltonica pcmcia modems
From: Attila Kinali <attila@kinali.ch>

Add the manufacturer and card id of teltonica pcmcia modems to serial_cs.c

Signed-off-by: Attila Kinali <attila@kinali.ch>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

add-manufacturer-and-card-id-of-teltonica-pcmcia-modems.patch
