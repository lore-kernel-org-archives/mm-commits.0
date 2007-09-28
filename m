From: akpm@linux-foundation.org
Subject: + add-dev-oldmem-to-devicestxt-documentation.patch added to -mm tree
Date: Thu, 27 Sep 2007 23:35:41 -0700
Message-ID: <200709280635.l8S6ZfqK014835@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52723 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756774AbXI1GgH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Sep 2007 02:36:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davej@redhat.com, device@lanana.org, hpa@zytor.com


The patch titled
     Add /dev/oldmem to devices.txt documentation
has been added to the -mm tree.  Its filename is
     add-dev-oldmem-to-devicestxt-documentation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

add-dev-oldmem-to-devicestxt-documentation.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
slow-down-printk-during-boot-fix-3.patch
slow-down-printk-during-boot-fix-4.patch
git-cpufreq.patch
cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core.patch
cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch
libata-correct-kernel-parameter-in-documentation.patch
