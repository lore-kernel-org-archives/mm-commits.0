From: akpm@linux-foundation.org
Subject: + pcih-fix-struct-pci_platform_pm_ops-kernel-doc.patch added to -mm tree
Date: Tue, 13 Jan 2009 00:42:03 -0800
Message-ID: <200901130842.n0D8g3L7002716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753608AbZAMImi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 03:42:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, jbarnes@virtuousgeek.org


The patch titled
     pci.h: fix struct pci_platform_pm_ops kernel-doc
has been added to the -mm tree.  Its filename is
     pcih-fix-struct-pci_platform_pm_ops-kernel-doc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

update-of-documentation-vmtxt-and-proctxt.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
kbuild-fix-kbuildtxt-typos.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
sunrpc-fix-rdma-dependency.patch
proc-move-inode-comment-text-file-to-source-file.patch
pci-fix-missing-kernel-doc-and-typos.patch
pcih-fix-struct-pci_platform_pm_ops-kernel-doc.patch
esp-fix-section-mismatch-warning.patch
libfc-uses-select-crc32.patch
sysrq-documentation-remove-the-redundant-updated-date.patch
sysrq-documentation-document-why-the-command-header-only-is-shown.patch
sysrq-add-commentary-on-why-we-use-the-console-loglevel-over-using-kern_emerg.patch
jbd-fix-missing-kernel-doc.patch
resources-fix-parameter-name-and-kernel-doc.patch
max3100-spi-uart-driver.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch

