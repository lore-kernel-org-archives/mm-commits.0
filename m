From: akpm@linux-foundation.org
Subject: - remove-leftover-documentation-of-acpi_generic_hotkey.patch removed from -mm tree
Date: Fri, 29 Jun 2007 13:41:14 -0700
Message-ID: <200706292041.l5TKfE9A022559@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55287 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751529AbXF2UpD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jun 2007 16:45:03 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l5TKiXTO009428
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 29 Jun 2007 13:44:35 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     acpi: remove leftover documentation of acpi_generic_hotkey
has been removed from the -mm tree.  Its filename was
     remove-leftover-documentation-of-acpi_generic_hotkey.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: acpi: remove leftover documentation of acpi_generic_hotkey
From: Stephen Hemminger <shemminger@linux-foundation.org>

This looks like left over text in the kernel parameters documentation.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    5 -----
 1 file changed, 5 deletions(-)

diff -puN Documentation/kernel-parameters.txt~remove-leftover-documentation-of-acpi_generic_hotkey Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~remove-leftover-documentation-of-acpi_generic_hotkey
+++ a/Documentation/kernel-parameters.txt
@@ -223,11 +223,6 @@ and is between 256 and 4096 characters. 
 
 	acpi_fake_ecdt	[HW,ACPI] Workaround failure due to BIOS lacking ECDT
 
-	acpi_generic_hotkey [HW,ACPI]
-			Allow consolidated generic hotkey driver to
-			override platform specific driver.
-			See also Documentation/acpi-hotkey.txt.
-
 	acpi_pm_good	[IA-32,X86-64]
 			Override the pmtimer bug detection: force the kernel
 			to assume that this machine's pmtimer latches its value
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

origin.patch
touchscreen-fujitsu-touchscreen-driver.patch
git-netdev-all.patch
git-net.patch
git-r8169.patch
pci-x-pci-express-read-control-interfaces-myrinet.patch
pci-x-pci-express-read-control-interfaces-mthca.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
pci-x-pci-express-read-control-interfaces-qla2xxx.patch
pci-x-pci-express-read-control-interfaces-qla2xxx-fix.patch
