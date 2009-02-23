From: akpm@linux-foundation.org
Subject: + 8250_pnpc-add-another-serial-wacom-tablet.patch added to -mm tree
Date: Sun, 22 Feb 2009 23:40:38 -0800
Message-ID: <200902230740.n1N7ecCC030719@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752647AbZBWHlX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Feb 2009 02:41:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dkukawka@suse.de, alan@lxorguk.ukuu.org.uk, bjorn.helgaas@hp.com


The patch titled
     8250_pnp.c: add another serial Wacom tablet
has been added to the -mm tree.  Its filename is
     8250_pnpc-add-another-serial-wacom-tablet.patch

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

