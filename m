From: akpm@linux-foundation.org
Subject: - add-fujitsu-siemens-tablet-pc-devices-to-8250_pnpc.patch removed from -mm tree
Date: Sun, 25 Mar 2007 17:05:43 -0800
Message-ID: <200703260105.l2Q15hvr008728@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38550 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933276AbXCZBFv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 21:05:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dkukawka@suse.de, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     add Fujitsu Siemens Tablet PC devices to 8250_pnp.c
has been removed from the -mm tree.  Its filename was
     add-fujitsu-siemens-tablet-pc-devices-to-8250_pnpc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: add Fujitsu Siemens Tablet PC devices to 8250_pnp.c
From: Danny Kukawka <dkukawka@suse.de>

Adds device ids of two Fujitsu Siemens Tablet PCs to pnp_dev_table

Signed-off-by: Danny Kukawka <dkukawka@suse.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pnp.c |    3 +++
 1 file changed, 3 insertions(+)

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
