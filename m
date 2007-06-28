From: akpm@linux-foundation.org
Subject: + mtd-add-module-license-to-mtdbdi.patch added to -mm tree
Date: Thu, 28 Jun 2007 13:32:36 -0700
Message-ID: <200706282032.l5SKWaoF000975@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46017 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755669AbXF1Udb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jun 2007 16:33:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, dwmw2@infradead.org


The patch titled
     mtd: add module license to mtdbdi
has been added to the -mm tree.  Its filename is
     mtd-add-module-license-to-mtdbdi.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mtd: add module license to mtdbdi
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

This seems to be a known issue [1] about Photron PNC-2000 module called
pnc2000.  To reproduce this just 'modprobe pnc2000'.  The patch attached at
least makes the kernel to be not tainted when mtdbdi gets loaded.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdbdi.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/mtd/mtdbdi.c~mtd-add-module-license-to-mtdbdi drivers/mtd/mtdbdi.c
--- a/drivers/mtd/mtdbdi.c~mtd-add-module-license-to-mtdbdi
+++ a/drivers/mtd/mtdbdi.c
@@ -46,3 +46,5 @@ struct backing_dev_info mtd_bdi_rw_mappa
 			   BDI_CAP_WRITE_MAP),
 };
 EXPORT_SYMBOL_GPL(mtd_bdi_rw_mappable);
+
+MODULE_LICENSE("GPL v2");
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

powerpc-tlb_32c-build-fix.patch
mtd-add-module-license-to-mtdbdi.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used-fix.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used-fix-fix.patch
arm26-remove-broken-and-unused-macro.patch
drivers-edac-new-intel-5000-mc-driver-fix.patch
driver-edac-i5000-define-typo.patch
