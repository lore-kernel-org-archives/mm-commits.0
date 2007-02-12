From: akpm@linux-foundation.org
Subject: - spi-controller-driver-for-omap-microwire-update-fix.patch removed from -mm tree
Date: Sun, 11 Feb 2007 23:22:29 -0800
Message-ID: <200702120722.l1C7MTut024701@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44739 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932926AbXBLHWf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 02:22:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     spi-controller-driver-for-omap-microwire-update-fix
has been removed from the -mm tree.  Its filename was
     spi-controller-driver-for-omap-microwire-update-fix.patch

This patch was dropped because it was folded into spi-controller-driver=
-for-omap-microwire.patch

------------------------------------------------------
Subject: spi-controller-driver-for-omap-microwire-update-fix
=46rom: Andrew Morton <akpm@osdl.org>

Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/omap_uwire.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/spi/omap_uwire.c~spi-controller-driver-for-omap-micro=
wire-update-fix drivers/spi/omap_uwire.c
--- a/drivers/spi/omap_uwire.c~spi-controller-driver-for-omap-microwire=
-update-fix
+++ a/drivers/spi/omap_uwire.c
@@ -6,7 +6,7 @@
  * Ported to 2.6 OMAP uwire interface.
  * Copyright (C) 2004 Texas Instruments.
  *
- * Generalization patches by Juha Yrj=F6l=E4 <juha.yrjola@nokia.com>
+ * Generalization patches by Juha Yrjola <juha.yrjola@nokia.com>
  *
  * Copyright (C) 2005 David Brownell (ported to 2.6 SPI interface)
  * Copyright (C) 2006 Nokia
@@ -403,8 +403,8 @@ static int uwire_setup_transfer(struct s
 	if (div1_idx =3D=3D 4) {
 		pr_debug("%s: lowest clock %ld, need %d\n",
 			spi->dev.bus_id, rate / 10 / 8, hz);
-			status =3D -EDOM;
-			goto done;
+		status =3D -EDOM;
+		goto done;
 	}
=20
 	/* we have to cache this and reset in uwire_chipselect as this is a
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
register_chrdev_region-dont-hand-out-the-local-experimental-majors.patc=
h
register_blkdev-dont-hand-out-the-local-experimental-majors.patch
spi-controller-driver-for-omap-microwire.patch
spi-controller-driver-for-omap-microwire-update-fix.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
omap-gpio-wrappers-tidy.patch
at91-gpio-wrappers-tidy.patch
ecryptfs-public-key-packet-management-slab-fix.patch
ecryptfs-generalize-metadata-read-write-fix.patch
dynamic-kernel-command-line-ia64-fix.patch
kvm-add-a-global-list-of-all-virtual-machines-tidy.patch
cyber2010-framebuffer-on-arm-netwinder-fix-tidy.patch
mark-struct-file_operations-const-2-fix.patch
mark-struct-file_operations-const-4-fix.patch
