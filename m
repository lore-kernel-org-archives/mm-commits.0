From: akpm@linux-foundation.org
Subject: + add-fujitsu-siemens-tablet-pc-devices-to-8250_pnpc.patch added to -mm tree
Date: Thu, 22 Mar 2007 13:50:20 -0700
Message-ID: <200703222050.l2MKoRJW030052@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51138 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934238AbXCVUun (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 16:50:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dkukawka@suse.de, rmk@arm.linux.org.uk


The patch titled
     add Fujitsu Siemens Tablet PC devices to 8250_pnp.c
has been added to the -mm tree.  Its filename is
     add-fujitsu-siemens-tablet-pc-devices-to-8250_pnpc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add Fujitsu Siemens Tablet PC devices to 8250_pnp.c
From: Danny Kukawka <dkukawka@suse.de>

Adds device ids of two Fujitsu Siemens Tablet PCs to pnp_dev_table

Signed-off-by: Danny Kukawka <dkukawka@suse.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pnp.c |    3 +++
 1 files changed, 3 insertions(+)

diff -puN drivers/serial/8250_pnp.c~add-fujitsu-siemens-tablet-pc-devices-to-8250_pnpc drivers/serial/8250_pnp.c
--- a/drivers/serial/8250_pnp.c~add-fujitsu-siemens-tablet-pc-devices-to-8250_pnpc
+++ a/drivers/serial/8250_pnp.c
@@ -340,6 +340,9 @@ static const struct pnp_device_id pnp_de
 	{       "FUJ02B8",              0 },
 	{       "FUJ02B9",              0 },
 	{       "FUJ02BC",              0 },
+	/* Fujitsu Wacom Tablet PC devices */
+	{	"FUJ02E5",		0	},
+	{	"FUJ02E6",		0	},
 	/* Rockwell's (PORALiNK) 33600 INT PNP */
 	{	"WCI0003",		0	},
 	/* Unkown PnP modems */
_

Patches currently in -mm which might be from dkukawka@suse.de are

add-fujitsu-siemens-tablet-pc-devices-to-8250_pnpc.patch
