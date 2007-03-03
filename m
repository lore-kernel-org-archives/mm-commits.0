From: akpm@linux-foundation.org
Subject: + fix-acpi-documentation-in-kernel-parameterstxt.patch added to -mm tree
Date: Fri, 02 Mar 2007 17:02:31 -0800
Message-ID: <200703030102.l2312V7R024461@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50415 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992839AbXCCBCf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 20:02:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de


The patch titled
     Fix ACPI documentation in kernel-parameters.txt
has been added to the -mm tree.  Its filename is
     fix-acpi-documentation-in-kernel-parameterstxt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix ACPI documentation in kernel-parameters.txt
From: Bernhard Walle <bwalle@suse.de>

Add hint that acpi=off doesn't work on IA64.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN Documentation/kernel-parameters.txt~fix-acpi-documentation-in-kernel-parameterstxt Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~fix-acpi-documentation-in-kernel-parameterstxt
+++ a/Documentation/kernel-parameters.txt
@@ -126,7 +126,8 @@ and is between 256 and 4096 characters. 
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

fix-acpi-documentation-in-kernel-parameterstxt.patch
git-r8169.patch
