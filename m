From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
Date: Sun, 07 Jun 2020 23:09:46 -0700
Message-ID: <20200608060946.YxSO5Zi3k%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgFHGJr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 02:09:47 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/drivers/pci/quirks.c~linux-next-rejects
+++ a/drivers/pci/quirks.c
@@ -5615,15 +5615,3 @@ static void apex_pci_fixup_class(struct
 DECLARE_PCI_FIXUP_CLASS_HEADER(0x1ac1, 0x089a,
 			       PCI_CLASS_NOT_DEFINED, 8, apex_pci_fixup_class);
 
-/*
- * Device [12d8:0x400e] and [12d8:0x400f]
- * These devices advertise PME# support in all power states but don't
- * reliably assert it.
- */
-static void pci_fixup_no_pme(struct pci_dev *dev)
-{
-	pci_info(dev, "PME# is unreliable, disabling it\n");
-	dev->pme_support = 0;
-}
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_PERICOM, 0x400e, pci_fixup_no_pme);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_PERICOM, 0x400f, pci_fixup_no_pme);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
lib-test-get_count_order-long-in-test_bitopsc-fix.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-git-rejects.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix-fix.patch
mmap-locking-api-rename-mmap_sem-to-mmap_lock-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix-fix.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
maccess-unify-the-probe-kernel-arch-hooks-fix.patch
bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better.patch
maccess-always-use-strict-semantics-for-probe_kernel_read-fix.patch
x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
