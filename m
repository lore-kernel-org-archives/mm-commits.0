From: akpm@linux-foundation.org
Subject: [alternative-merged] 8250_pnpc-add-another-serial-wacom-tablet.patch removed from -mm tree
Date: Mon, 23 Feb 2009 00:09:17 -0800
Message-ID: <200902230809.n1N89Hvo032343@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753681AbZBWIJb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Feb 2009 03:09:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dkukawka@suse.de, alan@lxorguk.ukuu.org.uk, bjorn.helgaas@hp.com, mm-commits@vger.kernel.org


The patch titled
     8250_pnp.c: add another serial Wacom tablet
has been removed from the -mm tree.  Its filename was
     8250_pnpc-add-another-serial-wacom-tablet.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: 8250_pnp.c: add another serial Wacom tablet
From: Danny Kukawka <dkukawka@suse.de>

Add another serial Wacom tablet with pnp_id: WACF009.

Signed-off-by: Danny Kukawka <dkukawka@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pnp.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/serial/8250_pnp.c~8250_pnpc-add-another-serial-wacom-tablet drivers/serial/8250_pnp.c
--- a/drivers/serial/8250_pnp.c~8250_pnpc-add-another-serial-wacom-tablet
+++ a/drivers/serial/8250_pnp.c
@@ -333,6 +333,7 @@ static const struct pnp_device_id pnp_de
 	{       "WACF006",              0       },
 	{       "WACF007",              0       },
 	{       "WACF008",              0       },
+	{       "WACF009",              0       },
 	/* Compaq touchscreen */
 	{       "FPI2002",              0 },
 	/* Fujitsu Stylistic touchscreens */
_

Patches currently in -mm which might be from dkukawka@suse.de are

8250_pnpc-add-another-serial-wacom-tablet.patch
linux-next.patch

