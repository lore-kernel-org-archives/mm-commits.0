From: akpm@linux-foundation.org
Subject: [merged] sections-fix-section-conflicts-in-drivers-char.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:12:48 -0700
Message-ID: <20121005201248.9CCF91E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:34453 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab2JEUMt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:12:49 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so172121yhl.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:12:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sections: fix section conflicts in drivers/char
has been removed from the -mm tree.  Its filename was
     sections-fix-section-conflicts-in-drivers-char.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: sections: fix section conflicts in drivers/char

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mbcs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/mbcs.c~sections-fix-section-conflicts-in-drivers-char drivers/char/mbcs.c
--- a/drivers/char/mbcs.c~sections-fix-section-conflicts-in-drivers-char
+++ a/drivers/char/mbcs.c
@@ -799,7 +799,7 @@ static int mbcs_remove(struct cx_dev *de
 	return 0;
 }
 
-static const struct cx_device_id __devinitdata mbcs_id_table[] = {
+static const struct cx_device_id __devinitconst mbcs_id_table[] = {
 	{
 	 .part_num = MBCS_PART_NUM,
 	 .mfg_num = MBCS_MFG_NUM,
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

