From: akpm@linux-foundation.org
Subject: [merged] sections-fix-section-conflicts-in-drivers-mfd.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:12:59 -0700
Message-ID: <20121005201259.A2766100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:48550 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab2JEUNA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:13:00 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so236590qcq.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:13:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, sameo@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sections: fix section conflicts in drivers/mfd
has been removed from the -mm tree.  Its filename was
     sections-fix-section-conflicts-in-drivers-mfd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 	{ 0x56, 0x7 },
 	{ 0x5d, 0x7e },
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

