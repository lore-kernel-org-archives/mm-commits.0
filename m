From: akpm@linux-foundation.org
Subject: + sections-fix-section-conflicts-in-drivers-mfd.patch added to -mm tree
Date: Thu, 13 Sep 2012 16:37:23 -0700
Message-ID: <20120913233724.686EE5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:64663 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759059Ab2IMXh1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Sep 2012 19:37:27 -0400
Received: by wibhr14 with SMTP id hr14so222403wib.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 16:37:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, sameo@linux.intel.com


The patch titled
     Subject: sections: fix section conflicts in drivers/mfd
has been added to the -mm tree.  Its filename is
     sections-fix-section-conflicts-in-drivers-mfd.patch

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
Subject: sections: fix section conflicts in drivers/mfd

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/wm8994-core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/mfd/wm8994-core.c~sections-fix-section-conflicts-in-drivers-mfd drivers/mfd/wm8994-core.c
--- a/drivers/mfd/wm8994-core.c~sections-fix-section-conflicts-in-drivers-mfd
+++ a/drivers/mfd/wm8994-core.c
@@ -374,21 +374,21 @@ static int wm8994_ldo_in_use(struct wm89
 }
 #endif
 
-static const __devinitdata struct reg_default wm8994_revc_patch[] = {
+static const __devinitconst struct reg_default wm8994_revc_patch[] = {
 	{ 0x102, 0x3 },
 	{ 0x56, 0x3 },
 	{ 0x817, 0x0 },
 	{ 0x102, 0x0 },
 };
 
-static const __devinitdata struct reg_default wm8958_reva_patch[] = {
+static const __devinitconst struct reg_default wm8958_reva_patch[] = {
 	{ 0x102, 0x3 },
 	{ 0xcb, 0x81 },
 	{ 0x817, 0x0 },
 	{ 0x102, 0x0 },
 };
 
-static const __devinitdata struct reg_default wm1811_reva_patch[] = {
+static const __devinitconst struct reg_default wm1811_reva_patch[] = {
 	{ 0x102, 0x3 },
 	{ 0x56, 0xc07 },
 	{ 0x5d, 0x7e },
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

