From: akpm@linux-foundation.org
Subject: + add-support-for-wacom-wacf007-and-wacf008-to-serial-pnp-driver.patch added to -mm tree
Date: Mon, 15 Oct 2007 13:01:46 -0700
Message-ID: <200710152001.l9FK1kNp022344@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53806 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765637AbXJOUCZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 16:02:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mbroemme@plusserver.de, pazke@orbita1.ru


The patch titled
     Add support for Wacom WACF007 and WACF008 to serial pnp driver
has been added to the -mm tree.  Its filename is
     add-support-for-wacom-wacf007-and-wacf008-to-serial-pnp-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add support for Wacom WACF007 and WACF008 to serial pnp driver
From: Maik Broemme <mbroemme@plusserver.de>

Notebook manufacturer seems to built a newer Wacom pen enabled tablet to
recent tablet pcs which are not recognized by the serial pnp driver.

Attached is a patch which makes the newer Wacom WACF007 and WACF008 tablets
useable with the serial driver.  The device is fully compatible with it.

Signed-off-by: Maik Broemme <mbroemme@plusserver.de>
Cc: Andrey Panin <pazke@orbita1.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pnp.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/serial/8250_pnp.c~add-support-for-wacom-wacf007-and-wacf008-to-serial-pnp-driver drivers/serial/8250_pnp.c
--- a/drivers/serial/8250_pnp.c~add-support-for-wacom-wacf007-and-wacf008-to-serial-pnp-driver
+++ a/drivers/serial/8250_pnp.c
@@ -327,6 +327,8 @@ static const struct pnp_device_id pnp_de
 	{	"WACF004",		0	},
 	{	"WACF005",		0	},
 	{       "WACF006",              0       },
+	{       "WACF007",              0       },
+	{       "WACF008",              0       },
 	/* Compaq touchscreen */
 	{       "FPI2002",              0 },
 	/* Fujitsu Stylistic touchscreens */
_

Patches currently in -mm which might be from mbroemme@plusserver.de are

add-support-for-wacom-wacf007-and-wacf008-to-serial-pnp-driver.patch
