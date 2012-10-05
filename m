From: akpm@linux-foundation.org
Subject: [merged] sections-fix-section-conflicts-in-drivers-atm.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:12:44 -0700
Message-ID: <20121005201245.135025C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:52293 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab2JEUMq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:12:46 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so138307fae.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:12:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, chas@cmf.nrl.navy.mil, mm-commits@vger.kernel.org


The patch titled
     Subject: sections: fix section conflicts in drivers/atm
has been removed from the -mm tree.  Its filename was
     sections-fix-section-conflicts-in-drivers-atm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: sections: fix section conflicts in drivers/atm

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Chas Williams <chas@cmf.nrl.navy.mil>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/atm/eni.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/atm/eni.c~sections-fix-section-conflicts-in-drivers-atm drivers/atm/eni.c
--- a/drivers/atm/eni.c~sections-fix-section-conflicts-in-drivers-atm
+++ a/drivers/atm/eni.c
@@ -1567,7 +1567,7 @@ tx_complete++;
 /*--------------------------------- entries ---------------------------------*/
 
 
-static const char *media_name[] __devinitdata = {
+static char * const media_name[] __devinitconst = {
     "MMF", "SMF", "MMF", "03?", /*  0- 3 */
     "UTP", "05?", "06?", "07?", /*  4- 7 */
     "TAXI","09?", "10?", "11?", /*  8-11 */
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

