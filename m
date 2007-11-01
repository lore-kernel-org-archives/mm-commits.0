From: akpm@linux-foundation.org
Subject: + 8250_pnp-add-support-for-lg-c1-express-dual-machines.patch added to -mm tree
Date: Thu, 01 Nov 2007 15:50:17 -0700
Message-ID: <200711012250.lA1MoHrC019522@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54786 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753290AbXKAWuo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 18:50:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dnj@Allotrope.com.au, bjorn.helgaas@hp.com, rmk@arm.linux.org.uk


The patch titled
     8250_pnp: add support for "LG C1 EXPRESS DUAL" machines
has been added to the -mm tree.  Its filename is
     8250_pnp-add-support-for-lg-c1-express-dual-machines.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: 8250_pnp: add support for "LG C1 EXPRESS DUAL" machines
From: "Damian Jurd" <dnj@Allotrope.com.au>

The following is an extra entry to enable the touch screen on the new LG
C1 EXPRESS DUAL machine.

Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pnp.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/serial/8250_pnp.c~8250_pnp-add-support-for-lg-c1-express-dual-machines drivers/serial/8250_pnp.c
--- a/drivers/serial/8250_pnp.c~8250_pnp-add-support-for-lg-c1-express-dual-machines
+++ a/drivers/serial/8250_pnp.c
@@ -345,6 +345,11 @@ static const struct pnp_device_id pnp_de
 	/* Fujitsu Wacom Tablet PC devices */
 	{	"FUJ02E5",		0	},
 	{	"FUJ02E6",		0	},
+	/*
+	 * LG C1 EXPRESS DUAL (C1-PB11A3) touch screen (actually a FUJ02E6 in
+	 * disguise)
+	 */
+	{	"LTS0001",		0       },
 	/* Rockwell's (PORALiNK) 33600 INT PNP */
 	{	"WCI0003",		0	},
 	/* Unkown PnP modems */
_

Patches currently in -mm which might be from dnj@Allotrope.com.au are

8250_pnp-add-support-for-lg-c1-express-dual-machines.patch
