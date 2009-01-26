From: akpm@linux-foundation.org
Subject: [merged] pcih-fix-struct-pci_platform_pm_ops-kernel-doc.patch removed from -mm tree
Date: Mon, 26 Jan 2009 11:04:20 -0800
Message-ID: <200901261904.n0QJ4KLd029760@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42080 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754060AbZAZTE4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jan 2009 14:04:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     pci.h: fix struct pci_platform_pm_ops kernel-doc
has been removed from the -mm tree.  Its filename was
     pcih-fix-struct-pci_platform_pm_ops-kernel-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci.h: fix struct pci_platform_pm_ops kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix struct pci_platform_pm_ops kernel-doc notation:

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci.h |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/pci/pci.h~pcih-fix-struct-pci_platform_pm_ops-kernel-doc drivers/pci/pci.h
--- a/drivers/pci/pci.h~pcih-fix-struct-pci_platform_pm_ops-kernel-doc
+++ a/drivers/pci/pci.h
@@ -16,21 +16,21 @@ extern int pci_mmap_fits(struct pci_dev 
 #endif
 
 /**
- * Firmware PM callbacks
+ * struct pci_platform_pm_ops - Firmware PM callbacks
  *
- * @is_manageable - returns 'true' if given device is power manageable by the
- *                  platform firmware
+ * @is_manageable: returns 'true' if given device is power manageable by the
+ *                 platform firmware
  *
- * @set_state - invokes the platform firmware to set the device's power state
+ * @set_state: invokes the platform firmware to set the device's power state
  *
- * @choose_state - returns PCI power state of given device preferred by the
- *                 platform; to be used during system-wide transitions from a
- *                 sleeping state to the working state and vice versa
+ * @choose_state: returns PCI power state of given device preferred by the
+ *                platform; to be used during system-wide transitions from a
+ *                sleeping state to the working state and vice versa
  *
- * @can_wakeup - returns 'true' if given device is capable of waking up the
- *               system from a sleeping state
+ * @can_wakeup: returns 'true' if given device is capable of waking up the
+ *              system from a sleeping state
  *
- * @sleep_wake - enables/disables the system wake up capability of given device
+ * @sleep_wake: enables/disables the system wake up capability of given device
  *
  * If given platform is generally capable of power managing PCI devices, all of
  * these callbacks are mandatory.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

oom-documentation-update.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
sunrpc-fix-rdma-dependency.patch
esp-fix-section-mismatch-warning.patch
max3100-spi-uart-driver.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch

