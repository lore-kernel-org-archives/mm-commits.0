From: akpm@linux-foundation.org
Subject: - libata-correct-kernel-parameter-in-documentation.patch removed from -mm tree
Date: Mon, 01 Oct 2007 00:14:10 -0700
Message-ID: <200710010714.l917EAkx004512@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41542 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752149AbXJAHO1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2007 03:14:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     libata: correct kernel parameter in documentation
has been removed from the -mm tree.  Its filename was
     libata-correct-kernel-parameter-in-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata: correct kernel parameter in documentation
From: Dave Jones <davej@redhat.com>

'noacpi' isn't a standalone parameter, give it its prefix.

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN Documentation/kernel-parameters.txt~libata-correct-kernel-parameter-in-documentation Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~libata-correct-kernel-parameter-in-documentation
+++ a/Documentation/kernel-parameters.txt
@@ -868,6 +868,10 @@ and is between 256 and 4096 characters. 
 	lasi=		[HW,SCSI] PARISC LASI driver for the 53c700 chip
 			Format: addr:<io>,irq:<irq>
 
+	libata.noacpi	[LIBATA] Disables use of ACPI in libata suspend/resume
+			when set.
+			Format: <int>
+
 	load_ramdisk=	[RAM] List of ramdisks to load from floppy
 			See Documentation/ramdisk.txt.
 
@@ -1090,10 +1094,6 @@ and is between 256 and 4096 characters. 
 			emulation library even if a 387 maths coprocessor
 			is present.
 
-	noacpi		[LIBATA] Disables use of ACPI in libata suspend/resume
-			when set.
-			Format: <int>
-
 	noaliencache	[MM, NUMA, SLAB] Disables the allocation of alien
 			caches in the slab allocator.  Saves per-node memory,
 			but will impact performance.
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
add-dev-oldmem-to-devicestxt-documentation.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
slow-down-printk-during-boot-fix-3.patch
slow-down-printk-during-boot-fix-4.patch
git-cpufreq.patch
cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core.patch
cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch
git-libata-all.patch
