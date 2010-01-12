From: akpm@linux-foundation.org
Subject: + serial-8250_pnp-add-a-new-fujitsu-wacom-tablet-pc-device.patch added to -mm tree
Date: Tue, 12 Jan 2010 14:14:05 -0800
Message-ID: <201001122214.o0CME5Bb030841@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34090 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751402Ab0ALWOU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jan 2010 17:14:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pinglinux@gmail.com, alan@lxorguk.ukuu.org.uk, dtor@mail.ru, pingc@wacom.com


The patch titled
     serial/8250_pnp: add a new Fujitsu Wacom Tablet PC device
has been added to the -mm tree.  Its filename is
     serial-8250_pnp-add-a-new-fujitsu-wacom-tablet-pc-device.patch

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
Subject: serial/8250_pnp: add a new Fujitsu Wacom Tablet PC device
From: Ping <pinglinux@gmail.com>

This is a new two finger touch Fujitsu Wacom Tablet PC

Signed-off-by: Ping Cheng <pingc@wacom.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pnp.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/serial/8250_pnp.c~serial-8250_pnp-add-a-new-fujitsu-wacom-tablet-pc-device drivers/serial/8250_pnp.c
--- a/drivers/serial/8250_pnp.c~serial-8250_pnp-add-a-new-fujitsu-wacom-tablet-pc-device
+++ a/drivers/serial/8250_pnp.c
@@ -346,6 +346,8 @@ static const struct pnp_device_id pnp_de
 	{	"FUJ02E5",		0	},
 	/* Fujitsu P-series tablet PC device */
 	{	"FUJ02E6",		0	},
+	/* Fujitsu Wacom 2FGT Tablet PC device */
+	{	"FUJ02E7",		0	},
 	/*
 	 * LG C1 EXPRESS DUAL (C1-PB11A3) touch screen (actually a FUJ02E6 in
 	 * disguise)
_

Patches currently in -mm which might be from pinglinux@gmail.com are

serial-8250_pnp-add-a-new-fujitsu-wacom-tablet-pc-device.patch
serial-8250_pnp-use-wildcard-for-serial-wacom-tablets.patch

