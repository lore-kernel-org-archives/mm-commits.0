From: akpm@linux-foundation.org
Subject: [obsolete] e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch removed from -mm tree
Date: Wed, 10 Jun 2009 12:55:09 -0700
Message-ID: <200906101955.n5AJt9of008326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759442AbZFJTzN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jun 2009 15:55:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, auke-jan.h.kok@intel.com, mm-commits@vger.kernel.org


The patch titled
     e1000e: make E1000E default to the same kconfig setting as E1000
has been removed from the -mm tree.  Its filename was
     e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: e1000e: make E1000E default to the same kconfig setting as E1000
From: Randy Dunlap <randy.dunlap@oracle.com>

Make E1000E default to the same kconfig setting as E1000.  So people's
machines don't stop working when they use oldconfig.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Auke Kok <auke-jan.h.kok@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/Kconfig~e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000 drivers/net/Kconfig
--- a/drivers/net/Kconfig~e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000
+++ a/drivers/net/Kconfig
@@ -2008,6 +2008,7 @@ config E1000
 config E1000E
 	tristate "Intel(R) PRO/1000 PCI-Express Gigabit Ethernet support"
 	depends on PCI && (!SPARC32 || BROKEN)
+	default E1000
 	---help---
 	  This driver supports the PCI-Express Intel(R) PRO/1000 gigabit
 	  ethernet family of adapters. For PCI or PCI-X e1000 adapters,
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
qla2x-fix-printk-format-warnings.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
hexdump-remove-the-trailing-space.patch
kmap_types-make-most-arches-use-generic-header-file.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
lis3-use-input_polled_device-fix.patch
lis3-use-input_polled_device-fix-2.patch
cgroups-make-messages-more-readable.patch
rapidio-fix-kerneldoc-for-rio_mem_ops.patch
linuxpps-core-support.patch
reiser4-export-remove_from_page_cache-fix.patch

