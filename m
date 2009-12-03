From: akpm@linux-foundation.org
Subject: [to-be-updated] serial-8250_pnpc-add-new-wacom-devices.patch removed from -mm tree
Date: Wed, 02 Dec 2009 17:44:00 -0800
Message-ID: <200912030144.nB31i0NA016689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752562AbZLCBoI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2009 20:44:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pingc@wacom.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     serial/8250_pnp.c: add new Wacom devices
has been removed from the -mm tree.  Its filename was
     serial-8250_pnpc-add-new-wacom-devices.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial/8250_pnp.c: add new Wacom devices
From: "Ping Cheng" <pingc@wacom.com>

Add 10 serial Wacom Tablet PC devices.  In fact, The last 3 bytes of
WACF### are all reserved for Wacom serial OEMs.

Signed-off-by: Ping Cheng <pingc@wacom.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pnp.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN drivers/serial/8250_pnp.c~serial-8250_pnpc-add-new-wacom-devices drivers/serial/8250_pnp.c
--- a/drivers/serial/8250_pnp.c~serial-8250_pnpc-add-new-wacom-devices
+++ a/drivers/serial/8250_pnp.c
@@ -337,6 +337,15 @@ static const struct pnp_device_id pnp_de
 	{       "WACF00A",              0       },
 	{       "WACF00B",              0       },
 	{       "WACF00C",              0       },
+	{       "WACF00D",              0       },
+	{       "WACF00E",              0       },
+	{       "WACF00F",              0       },
+	{       "WACF010",              0       },
+	{       "WACF011",              0       },
+	{       "WACF012",              0       },
+	{       "WACF013",              0       },
+	{       "WACF014",              0       },
+	{       "WACF015",              0       },
 	/* Compaq touchscreen */
 	{       "FPI2002",              0 },
 	/* Fujitsu Stylistic touchscreens */
@@ -354,6 +363,8 @@ static const struct pnp_device_id pnp_de
 	{	"FUJ02E5",		0	},
 	/* Fujitsu P-series tablet PC device */
 	{	"FUJ02E6",		0	},
+	/* Fujitsu Wacom Tablet PC device */
+	{	"FUJ02E7",		0	},
 	/*
 	 * LG C1 EXPRESS DUAL (C1-PB11A3) touch screen (actually a FUJ02E6 in
 	 * disguise)
_

Patches currently in -mm which might be from pingc@wacom.com are

serial-8250_pnpc-add-new-wacom-devices.patch

