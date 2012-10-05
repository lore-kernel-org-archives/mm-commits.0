From: akpm@linux-foundation.org
Subject: [merged] sections-fix-section-conflicts-in-drivers-macintosh.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:12:55 -0700
Message-ID: <20121005201256.17CCB20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:47811 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab2JEUM6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:12:58 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so140952lbo.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:12:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sections: fix section conflicts in drivers/macintosh
has been removed from the -mm tree.  Its filename was
     sections-fix-section-conflicts-in-drivers-macintosh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: sections: fix section conflicts in drivers/macintosh

[akpm@linux-foundation.org: checkpatch fixes]
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/macio_asic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/macintosh/macio_asic.c~sections-fix-section-conflicts-in-drivers-macintosh drivers/macintosh/macio_asic.c
--- a/drivers/macintosh/macio_asic.c~sections-fix-section-conflicts-in-drivers-macintosh
+++ a/drivers/macintosh/macio_asic.c
@@ -748,7 +748,7 @@ static void __devexit macio_pci_remove(s
  * MacIO is matched against any Apple ID, it's probe() function
  * will then decide wether it applies or not
  */
-static const struct pci_device_id __devinitdata pci_ids [] = { {
+static const struct pci_device_id __devinitconst pci_ids[] = { {
 	.vendor		= PCI_VENDOR_ID_APPLE,
 	.device		= PCI_ANY_ID,
 	.subvendor	= PCI_ANY_ID,
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch

