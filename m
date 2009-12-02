From: akpm@linux-foundation.org
Subject: + serial-8250_pnpc-add-new-wacom-devices.patch added to -mm tree
Date: Wed, 02 Dec 2009 15:18:07 -0800
Message-ID: <200912022318.nB2NI7ZU014860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47817 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752199AbZLBXSL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2009 18:18:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pingc@wacom.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, jkosina@suse.cz


The patch titled
     serial/8250_pnp.c: add new Wacom devices
has been added to the -mm tree.  Its filename is
     serial-8250_pnpc-add-new-wacom-devices.patch

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

