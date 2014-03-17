From: akpm@linux-foundation.org
Subject: + zram-propagate-error-to-user-fix-2.patch added to -mm tree
Date: Mon, 17 Mar 2014 13:48:44 -0700
Message-ID: <53275fac.5WmdtfTvC0KInKoM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48023 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaCQUsp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Mar 2014 16:48:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sfr@canb.auug.org.au, minchan@kernel.org, fengguang.wu@intel.com

Subject: + zram-propagate-error-to-user-fix-2.patch added to -mm tree
To: fengguang.wu@intel.com,minchan@kernel.org,sfr@canb.auug.org.au
From: akpm@linux-foundation.org
Date: Mon, 17 Mar 2014 13:48:44 -0700


The patch titled
     Subject: zram: fix coccinelle warnings
has been added to the -mm tree.  Its filename is
     zram-propagate-error-to-user-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-propagate-error-to-user-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-propagate-error-to-user-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: zram: fix coccinelle warnings

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/zram/zcomp.c~zram-propagate-error-to-user-fix-2 drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-propagate-error-to-user-fix-2
+++ a/drivers/block/zram/zcomp.c
@@ -234,7 +234,7 @@ static void zcomp_strm_single_release(st
 static bool zcomp_strm_single_set_max_streams(struct zcomp *comp, int num_strm)
 {
 	/* zcomp_strm_single support only max_comp_streams == 1 */
-	return 0;
+	return false;
 }
 
 static void zcomp_strm_single_destroy(struct zcomp *comp)
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

pagewalk-remove-argument-hmask-from-hugetlb_entry-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-readaheadc-fix-readahead-failure-for-memoryless-numa-nodes-and-limit-readahead-pages.patch
tools-vm-page-typesc-page-cache-sniffing-feature.patch
zram-propagate-error-to-user-fix-2.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch
debugging-keep-track-of-page-owners.patch

