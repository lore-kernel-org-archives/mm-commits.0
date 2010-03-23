From: akpm@linux-foundation.org
Subject: + serial-8250_pnp-add-fujitsu-wacom-device.patch added to -mm tree
Date: Mon, 22 Mar 2010 23:40:54 -0400
Message-ID: <201003230641.o2N6fjED018809@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754138Ab0CWGmS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Mar 2010 02:42:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pingc@wacom.com, greg@kroah.com, stable@kernel.org


The patch titled
     serial: 8250_pnp: add Fujitsu Wacom device
has been added to the -mm tree.  Its filename is
     serial-8250_pnp-add-fujitsu-wacom-device.patch

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
Subject: serial: 8250_pnp: add Fujitsu Wacom device
From: Ping Cheng <pingc@wacom.com>

Add Fujitsu Wacom 1FGT Tablet PC device

Signed-off-by: Ping Cheng <pingc@wacom.com>
Cc: Greg KH <greg@kroah.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pnp.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/serial/8250_pnp.c~serial-8250_pnp-add-fujitsu-wacom-device drivers/serial/8250_pnp.c
--- a/drivers/serial/8250_pnp.c~serial-8250_pnp-add-fujitsu-wacom-device
+++ a/drivers/serial/8250_pnp.c
@@ -348,6 +348,8 @@ static const struct pnp_device_id pnp_de
 	{	"FUJ02E6",		0	},
 	/* Fujitsu Wacom 2FGT Tablet PC device */
 	{	"FUJ02E7",		0	},
+	/* Fujitsu Wacom 1FGT Tablet PC device */
+	{	"FUJ02E9",		0	},
 	/*
 	 * LG C1 EXPRESS DUAL (C1-PB11A3) touch screen (actually a FUJ02E6 in
 	 * disguise)
_

Patches currently in -mm which might be from pingc@wacom.com are

linux-next.patch
serial-8250_pnp-add-fujitsu-wacom-device.patch

