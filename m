From: akpm@linux-foundation.org
Subject: [merged] maintainers-fix-email-address.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:48:27 -0700
Message-ID: <200904141948.n3EJmRAZ019059@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752530AbZDNTuc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:50:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, andreas.herrmann3@amd.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: fix Andreas's email address
has been removed from the -mm tree.  Its filename was
     maintainers-fix-email-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: fix Andreas's email address
From: Randy Dunlap <randy.dunlap@oracle.com>

Correct typo in email address.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-fix-email-address MAINTAINERS
--- a/MAINTAINERS~maintainers-fix-email-address
+++ a/MAINTAINERS
@@ -461,7 +461,7 @@ F:	arch/x86/include/asm/amd_iommu*.h
 
 AMD MICROCODE UPDATE SUPPORT
 P:	Andreas Herrmann
-M:	andeas.herrmann3@amd.com
+M:      andreas.herrmann3@amd.com
 L:	amd64-microcode@amd64.org
 S:	Supported
 F:	arch/x86/kernel/microcode_amd.c
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pci-docbooks-add-fix-pci-kernel-doc.patch
qla2x-fix-printk-format-warnings.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch
linuxpps-core-support.patch
reiser4-export-remove_from_page_cache-fix.patch

