From: akpm@linux-foundation.org
Subject: - drivers-acpi-pci_linkc-lower-printk-severity.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:35:21 -0700
Message-ID: <200707230935.l6N9ZLSi016478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55530 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758097AbXGWJpL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:45:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: da-x@monatomic.org, mm-commits@vger.kernel.org


The patch titled
     drivers/acpi/pci_link.c: lower printk severity
has been removed from the -mm tree.  Its filename was
     drivers-acpi-pci_linkc-lower-printk-severity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/acpi/pci_link.c: lower printk severity
From: Dan Aloni <da-x@monatomic.org>

Signed-off-by: Dan Aloni <da-x@monatomic.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/pci_link.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/pci_link.c~drivers-acpi-pci_linkc-lower-printk-severity drivers/acpi/pci_link.c
--- a/drivers/acpi/pci_link.c~drivers-acpi-pci_linkc-lower-printk-severity
+++ a/drivers/acpi/pci_link.c
@@ -733,7 +733,7 @@ static int acpi_pci_link_add(struct acpi
 	/* query and set link->irq.active */
 	acpi_pci_link_get_current(link);
 
-	printk(PREFIX "%s [%s] (IRQs", acpi_device_name(device),
+	printk(KERN_INFO PREFIX "%s [%s] (IRQs", acpi_device_name(device),
 	       acpi_device_bid(device));
 	for (i = 0; i < link->irq.possible_count; i++) {
 		if (link->irq.active == link->irq.possible[i]) {
_

Patches currently in -mm which might be from da-x@monatomic.org are
