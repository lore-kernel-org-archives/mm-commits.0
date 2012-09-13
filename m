From: akpm@linux-foundation.org
Subject: + sections-fix-section-conflicts-in-drivers-macintosh.patch added to -mm tree
Date: Thu, 13 Sep 2012 16:37:20 -0700
Message-ID: <20120913233721.27F831E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:63220 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759055Ab2IMXhW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Sep 2012 19:37:22 -0400
Received: by vcbfy27 with SMTP id fy27so253945vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 16:37:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, benh@kernel.crashing.org


The patch titled
     Subject: sections: fix section conflicts in drivers/macintosh
has been added to the -mm tree.  Its filename is
     sections-fix-section-conflicts-in-drivers-macintosh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: sections: fix section conflicts in drivers/macintosh

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
+static const struct pci_device_id __devinitconst pci_ids [] = { {
 	.vendor		= PCI_VENDOR_ID_APPLE,
 	.device		= PCI_ANY_ID,
 	.subvendor	= PCI_ANY_ID,
_

Patches currently in -mm which might be from ak@linux.intel.com are

compilerh-add-__visible.patch
linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch
sections-disable-const-sections-for-pa-risc-v2.patch
sections-fix-section-conflicts-in-arch-arm.patch
sections-fix-section-conflicts-in-arch-frv.patch
sections-fix-section-conflicts-in-arch-h8300.patch
sections-fix-section-conflicts-in-arch-ia64.patch
sections-fix-section-conflicts-in-arch-mips.patch
sections-fix-section-conflicts-in-arch-powerpc.patch
sections-fix-section-conflicts-in-arch-score.patch
sections-fix-section-conflicts-in-arch-sh.patch
sections-fix-section-conflicts-in-arch-x86.patch
sections-fix-section-conflicts-in-drivers-atm.patch
sections-fix-section-conflicts-in-drivers-char.patch
sections-fix-section-conflicts-in-drivers-cpufreq.patch
sections-fix-section-conflicts-in-drivers-ide.patch
sections-fix-section-conflicts-in-drivers-macintosh.patch
sections-fix-section-conflicts-in-drivers-mfd.patch
sections-fix-section-conflicts-in-drivers-mmc.patch
sections-fix-section-conflicts-in-drivers-net.patch
sections-fix-section-conflicts-in-drivers-net-hamradio.patch
sections-fix-section-conflicts-in-drivers-net-wan.patch
sections-fix-section-conflicts-in-drivers-platform-x86.patch
sections-fix-section-conflicts-in-drivers-scsi.patch
sections-fix-section-conflicts-in-drivers-video.patch
sections-fix-section-conflicts-in-mm-percpuc.patch
sections-fix-section-conflicts-in-net-can.patch
sections-fix-section-conflicts-in-net.patch
sections-fix-section-conflicts-in-sound.patch
sectons-fix-const-sections-for-crc32-table.patch
compat_ioctl-remove-unused-local-typedef.patch

