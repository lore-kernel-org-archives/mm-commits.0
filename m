From: akpm@linux-foundation.org
Subject: - add-dev-oldmem-to-devicestxt-documentation.patch removed from -mm tree
Date: Tue, 02 Oct 2007 15:54:51 -0700
Message-ID: <200710022254.l92MspVc026738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57822 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753121AbXJBWzR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Oct 2007 18:55:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, device@lanana.org, hpa@zytor.com, mm-commits@vger.kernel.org


The patch titled
     Add /dev/oldmem to devices.txt documentation
has been removed from the -mm tree.  Its filename was
     add-dev-oldmem-to-devicestxt-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add /dev/oldmem to devices.txt documentation
From: Dave Jones <davej@redhat.com>

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <device@lanana.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devices.txt |    2 ++
 1 file changed, 2 insertions(+)

diff -puN Documentation/devices.txt~add-dev-oldmem-to-devicestxt-documentation Documentation/devices.txt
--- a/Documentation/devices.txt~add-dev-oldmem-to-devicestxt-documentation
+++ a/Documentation/devices.txt
@@ -94,6 +94,8 @@ Your cooperation is appreciated.
 		  9 = /dev/urandom	Faster, less secure random number gen.
 		 10 = /dev/aio		Asynchronous I/O notification interface
 		 11 = /dev/kmsg		Writes to this come out as printk's
+		 12 = /dev/oldmem	Used by crashdump kernels to access
+					the memory of the kernel that crashed.
 
   1 block	RAM disk
 		  0 = /dev/ram0		First RAM disk
_

Patches currently in -mm which might be from davej@redhat.com are

slow-down-printk-during-boot.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
git-cpufreq.patch
cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core.patch
cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch
git-libata-all.patch
