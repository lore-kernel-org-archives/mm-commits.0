From: akpm@linux-foundation.org
Subject: + serial-add-pnp-id-gvc0303-for-archtek-3334brv-isa-modem.patch added to -mm tree
Date: Mon, 25 Feb 2008 10:37:44 -0800
Message-ID: <200802251838.m1PIcZ7M013624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757263AbYBYSjd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Feb 2008 13:39:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, alan@lxorguk.ukuu.org.uk, thomas.lehmann@alumni.tu-berlin.de


The patch titled
     serial: add PNP ID GVC0303 for Archtek 3334BRV ISA modem
has been added to the -mm tree.  Its filename is
     serial-add-pnp-id-gvc0303-for-archtek-3334brv-isa-modem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: add PNP ID GVC0303 for Archtek 3334BRV ISA modem
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Thomas Lehmann <thomas.lehmann@alumni.tu-berlin.de> verified that this
entry works.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pnp.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/serial/8250_pnp.c~serial-add-pnp-id-gvc0303-for-archtek-3334brv-isa-modem drivers/serial/8250_pnp.c
--- a/drivers/serial/8250_pnp.c~serial-add-pnp-id-gvc0303-for-archtek-3334brv-isa-modem
+++ a/drivers/serial/8250_pnp.c
@@ -91,6 +91,8 @@ static const struct pnp_device_id pnp_de
 	/* Archtek America Corp. */
 	/* Archtek SmartLink Modem 3334BT Plug & Play */
 	{	"GVC000F",		0	},
+	/* Archtek SmartLink Modem 3334BRV 33.6K Data Fax Voice */
+	{	"GVC0303",		0	},
 	/* Hayes */
 	/* Hayes Optima 288 V.34-V.FC + FAX + Voice Plug & Play */
 	{	"HAY0001",		0	},
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

serial-add-pnp-id-gvc0303-for-archtek-3334brv-isa-modem.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup-update.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch
pci-simplify-quirk-debug-output.patch
simplify-initcall_debug-output.patch
pnp-skip-dev-protocol-null-checks.patch
pnp-simplify-quirk-debug-output.patch
