From: akpm@linux-foundation.org
Subject: + remove-leftover-documentation-of-acpi_generic_hotkey.patch added to -mm tree
Date: Tue, 26 Jun 2007 22:04:08 -0700
Message-ID: <200706270504.l5R548FM010301@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40019 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756255AbXF0FEQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jun 2007 01:04:16 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l5R54EVt009525
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 26 Jun 2007 22:04:15 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@linux-foundation.org


The patch titled
     acpi: remove leftover documentation of acpi_generic_hotkey
has been added to the -mm tree.  Its filename is
     remove-leftover-documentation-of-acpi_generic_hotkey.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

remove-leftover-documentation-of-acpi_generic_hotkey.patch
touchscreen-fujitsu-touchscreen-driver.patch
git-netdev-all.patch
netpoll-tx-lock-deadlock-fix.patch
git-r8169.patch
pci-x-pci-express-read-control-interfaces-myrinet.patch
pci-x-pci-express-read-control-interfaces-mthca.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
pci-x-pci-express-read-control-interfaces-qla2xxx.patch
pci-x-pci-express-read-control-interfaces-qla2xxx-fix.patch
s2io-fix-__ucmpdi2-undefined.patch
