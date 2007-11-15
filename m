From: akpm@linux-foundation.org
Subject: + pata_sisc-add-packard-bell-easynote-k5305-to-laptops.patch added to -mm tree
Date: Thu, 15 Nov 2007 15:27:46 -0800
Message-ID: <200711152327.lAFNRkhJ021378@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50359 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755071AbXKOX2G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 18:28:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nix.or.die@googlemail.com, alan@redhat.com, htejun@gmail.com, jeff@garzik.org


The patch titled
     pata_sis.c: add Packard Bell EasyNote K5305 to laptops
has been added to the -mm tree.  Its filename is
     pata_sisc-add-packard-bell-easynote-k5305-to-laptops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_sis.c: add Packard Bell EasyNote K5305 to laptops
From: Gabriel C <nix.or.die@googlemail.com>

With newer kernels HDD in my old laptop is limited to UDMA 33.  With this
patch I get UDMA 100 again.

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
Acked-by: Alan Cox <alan@redhat.com>
Applied-to-secret-tree-by: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_sis.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/ata/pata_sis.c~pata_sisc-add-packard-bell-easynote-k5305-to-laptops drivers/ata/pata_sis.c
--- a/drivers/ata/pata_sis.c~pata_sisc-add-packard-bell-easynote-k5305-to-laptops
+++ a/drivers/ata/pata_sis.c
@@ -55,6 +55,7 @@ static const struct sis_laptop sis_lapto
 	/* devid, subvendor, subdev */
 	{ 0x5513, 0x1043, 0x1107 },	/* ASUS A6K */
 	{ 0x5513, 0x1734, 0x105F },	/* FSC Amilo A1630 */
+	{ 0x5513, 0x1071, 0x8640 },     /* EasyNote K5305 */
 	/* end marker */
 	{ 0, }
 };
_

Patches currently in -mm which might be from nix.or.die@googlemail.com are

git-kvm.patch
pata_sisc-add-packard-bell-easynote-k5305-to-laptops.patch
tlan-list-is-subscribers-only.patch
