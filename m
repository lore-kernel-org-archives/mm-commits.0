From: akpm@linux-foundation.org
Subject: [merged] drivers-input-misc-winbond-circ-needs-leds_triggers.patch removed from -mm tree
Date: Tue, 03 Nov 2009 11:57:47 -0800
Message-ID: <200911031957.nA3Jvl3C027041@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751006AbZKCT5z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 14:57:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@hardeman.nu, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     drivers/input/misc/winbond-cir.c needs LEDS_TRIGGERS
has been removed from the -mm tree.  Its filename was
     drivers-input-misc-winbond-circ-needs-leds_triggers.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: drivers/input/misc/winbond-cir.c needs LEDS_TRIGGERS
=46rom: David H=E4rdeman <david@hardeman.nu>

drivers/input/misc/winbond-cir.c depends on LEDS_TRIGGERS

Add an appropriate select to drivers/input/misc/Kconfig

Signed-off-by: David H=E4rdeman <david@hardeman.nu>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/input/misc/Kconfig~drivers-input-misc-winbond-circ-ne=
eds-leds_triggers drivers/input/misc/Kconfig
--- a/drivers/input/misc/Kconfig~drivers-input-misc-winbond-circ-needs-=
leds_triggers
+++ a/drivers/input/misc/Kconfig
@@ -227,6 +227,7 @@ config INPUT_WINBOND_CIR
 	depends on X86 && PNP
 	select NEW_LEDS
 	select LEDS_CLASS
+	select LEDS_TRIGGERS
 	select BITREVERSE
 	help
 	  Say Y here if you want to use the IR remote functionality found
_

Patches currently in -mm which might be from david@hardeman.nu are

origin.patch
acpi-reintroduce-acpi_device_ops-shutdown-method.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
