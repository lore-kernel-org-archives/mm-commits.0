From: akpm@linux-foundation.org
Subject: - add-support-for-pcmcia-card-sierra-wireless-ac850.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:29:46 -0700
Message-ID: <200710162029.l9GKTkBZ014339@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60910 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934704AbXJPUaF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:30:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric@inl.fr, linux@dominikbrodowski.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Add support for PCMCIA card Sierra WIreless AC850
has been removed from the -mm tree.  Its filename was
     add-support-for-pcmcia-card-sierra-wireless-ac850.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add support for PCMCIA card Sierra WIreless AC850
From: Eric Leblond <eric@inl.fr>

Add support for Sierra Wireless AC850 which has the same Ids as the
AC710/750 but has a different firmware.

Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_cs.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/serial/serial_cs.c~add-support-for-pcmcia-card-sierra-wireless-ac850 drivers/serial/serial_cs.c
--- a/drivers/serial/serial_cs.c~add-support-for-pcmcia-card-sierra-wireless-ac850
+++ a/drivers/serial/serial_cs.c
@@ -911,6 +911,7 @@ static struct pcmcia_device_id serial_id
 	PCMCIA_MFC_DEVICE_CIS_MANF_CARD(1, 0x0175, 0x0000, "DP83903.cis"),
 	PCMCIA_MFC_DEVICE_CIS_MANF_CARD(1, 0x0101, 0x0035, "3CXEM556.cis"),
 	PCMCIA_MFC_DEVICE_CIS_MANF_CARD(1, 0x0101, 0x003d, "3CXEM556.cis"),
+	PCMCIA_DEVICE_CIS_PROD_ID12("Sierra Wireless", "AC850", 0xd85f6206, 0x42a2c018, "SW_8xx_SER.cis"),  /* Sierra Wireless AC850 3G Network Adapter R1 */
 	PCMCIA_DEVICE_CIS_MANF_CARD(0x0192, 0x0710, "SW_7xx_SER.cis"),	/* Sierra Wireless AC710/AC750 GPRS Network Adapter R1 */
 	PCMCIA_DEVICE_CIS_MANF_CARD(0x0192, 0xa555, "SW_555_SER.cis"),  /* Sierra Aircard 555 CDMA 1xrtt Modem -- pre update */
 	PCMCIA_DEVICE_CIS_MANF_CARD(0x013f, 0xa555, "SW_555_SER.cis"),  /* Sierra Aircard 555 CDMA 1xrtt Modem -- post update */
_

Patches currently in -mm which might be from eric@inl.fr are

origin.patch
