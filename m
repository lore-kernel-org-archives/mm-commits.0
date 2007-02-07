From: akpm@linux-foundation.org
Subject: + pci-add-systems-for-automatic-breadth-first-device-sorting-update.patch added to -mm tree
Date: Tue, 06 Feb 2007 16:26:42 -0800
Message-ID: <200702070026.l170QhU2001790@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56501 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030440AbXBGA05 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 19:26:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andy@greyhouse.net, Matt_Domsch@dell.com, greg@kroah.com


The patch titled
     PCI: Add systems for automatic breadth-first device sorting (update)
has been added to the -mm tree.  Its filename is
     pci-add-systems-for-automatic-breadth-first-device-sorting-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PCI: Add systems for automatic breadth-first device sorting (update)
From: Andy Gospodarek <andy@greyhouse.net>

A problem with this patch was pointed out to me today.  A cut-and-paste
error was made creating these entries and one of the entries for the
BL45p was incorrect.

Cc: Greg KH <greg@kroah.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/pci/common.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/pci/common.c~pci-add-systems-for-automatic-breadth-first-device-sorting-update arch/i386/pci/common.c
--- a/arch/i386/pci/common.c~pci-add-systems-for-automatic-breadth-first-device-sorting-update
+++ a/arch/i386/pci/common.c
@@ -244,7 +244,7 @@ static struct dmi_system_id __devinitdat
 		.ident = "HP ProLiant BL45p G2",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL45p G1"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL45p G2"),
 		},
 	},
 	{
_

Patches currently in -mm which might be from andy@greyhouse.net are

pci-add-systems-for-automatic-breadth-first-device-sorting.patch
pci-add-systems-for-automatic-breadth-first-device-sorting-update.patch
