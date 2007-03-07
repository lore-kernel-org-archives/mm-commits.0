From: akpm@linux-foundation.org
Subject: - fix-acpi-documentation-in-kernel-parameterstxt.patch removed from -mm tree
Date: Wed, 07 Mar 2007 15:58:44 -0800
Message-ID: <200703072358.l27Nwi00013652@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39699 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992733AbXCGX6s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 18:58:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, mm-commits@vger.kernel.org


The patch titled
     Fix ACPI documentation in kernel-parameters.txt
has been removed from the -mm tree.  Its filename was
     fix-acpi-documentation-in-kernel-parameterstxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix ACPI documentation in kernel-parameters.txt
From: Bernhard Walle <bwalle@suse.de>

Add hint that acpi=off doesn't work on IA64.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN Documentation/kernel-parameters.txt~fix-acpi-documentation-in-kernel-parameterstxt Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~fix-acpi-documentation-in-kernel-parameterstxt
+++ a/Documentation/kernel-parameters.txt
@@ -125,7 +125,8 @@ and is between 256 and 4096 characters. 
 			See header of drivers/scsi/53c7xx.c.
 			See also Documentation/scsi/ncr53c7xx.txt.
 
-	acpi=		[HW,ACPI] Advanced Configuration and Power Interface
+	acpi=		[HW,ACPI,X86-64,i386]
+			Advanced Configuration and Power Interface
 			Format: { force | off | ht | strict | noirq }
 			force -- enable ACPI if default was off
 			off -- disable ACPI if default was on
_

Patches currently in -mm which might be from bwalle@suse.de are

git-acpi.patch
git-r8169.patch
