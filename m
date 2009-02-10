From: akpm@linux-foundation.org
Subject: + pci-fix-romc-kernel-doc-warning.patch added to -mm tree
Date: Tue, 10 Feb 2009 13:31:33 -0800
Message-ID: <200902102131.n1ALVXgV016620@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756361AbZBJVbk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Feb 2009 16:31:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, jbarnes@virtuousgeek.org


The patch titled
     PCI: fix rom.c kernel-doc warning
has been added to the -mm tree.  Its filename is
     pci-fix-romc-kernel-doc-warning.patch

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
Subject: PCI: fix rom.c kernel-doc warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix PCI kernel-doc warning:

Warning(linux-2.6.29-rc4-git1/drivers/pci/rom.c:67): No description found for parameter 'pdev'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/rom.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/pci/rom.c~pci-fix-romc-kernel-doc-warning drivers/pci/rom.c
--- a/drivers/pci/rom.c~pci-fix-romc-kernel-doc-warning
+++ a/drivers/pci/rom.c
@@ -55,6 +55,7 @@ void pci_disable_rom(struct pci_dev *pde
 
 /**
  * pci_get_rom_size - obtain the actual size of the ROM image
+ * @pdev: target PCI device
  * @rom: kernel virtual pointer to image of ROM
  * @size: size of PCI window
  *  return: size of actual ROM image
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

kernel-doc-preferred-ending-marker-and-examples.patch
kernel-doc-fix-syscall-wrapper-processing.patch
linux-next.patch
uv-fix-header-struct-usage.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
input-ad7879-touchscreen-driver-dont-use-bus_id.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pci-fix-romc-kernel-doc-warning.patch
esp-fix-section-mismatch-warning.patch
cciss-pci-power-management-reset-for-kexec.patch
cciss-pci-power-management-reset-for-kexec-cleanup.patch
vfs-update-fsh-to-use-inline-functions-when-no-file-locking-set.patch
vfs-further-changes-from-macro-to-inline-function-in-fsh.patch
max3100-spi-uart-driver.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems.patch
atyfb-fix-header-file-trailing-whitespace.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
documentation-ignore-byproducts-from-latex.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
linuxpps-core-support.patch

