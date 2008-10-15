From: akpm@linux-foundation.org
Subject: - pnp-make-the-resource-type-an-unsigned-long-fix.patch removed from -mm tree
Date: Wed, 15 Oct 2008 16:55:38 -0700
Message-ID: <200810152355.m9FNtct0024313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753792AbYJOXzu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 19:55:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rene.herman@keyaccess.nl, andi@firstfloor.org, bjorn.helgaas@hp.com, hpa@zytor.com, rene.herman@gmail.com, mm-commits@vger.kernel.org


The patch titled
     PNP: resource type is now an unsigned long
has been removed from the -mm tree.  Its filename was
     pnp-make-the-resource-type-an-unsigned-long-fix.patch

This patch was dropped because it was folded into pnp-make-the-resource-type-an-unsigned-long.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PNP: resource type is now an unsigned long
From: Rene Herman <rene.herman@keyaccess.nl>

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/quirks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pnp/quirks.c~pnp-make-the-resource-type-an-unsigned-long-fix drivers/pnp/quirks.c
--- a/drivers/pnp/quirks.c~pnp-make-the-resource-type-an-unsigned-long-fix
+++ a/drivers/pnp/quirks.c
@@ -245,7 +245,7 @@ static void quirk_system_pci_resources(s
 	 */
 	for_each_pci_dev(pdev) {
 		for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
-			unsigned int type;
+			unsigned long type;
 
 			type = pci_resource_flags(pdev, i) &
 					(IORESOURCE_IO | IORESOURCE_MEM);
_

Patches currently in -mm which might be from rene.herman@keyaccess.nl are

origin.patch
pnp-make-the-resource-type-an-unsigned-long.patch
pnp-make-the-resource-type-an-unsigned-long-fix.patch

