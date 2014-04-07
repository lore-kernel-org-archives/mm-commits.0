From: akpm@linux-foundation.org
Subject: [folded-merged] zram-propagate-error-to-user-fix-2.patch removed
 from -mm tree
Date: Mon, 07 Apr 2014 15:15:06 -0700
Message-ID: <5343236a.J2PdbLTVaOccvpai%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbaDGWPH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2014 18:15:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sfr@canb.auug.org.au, minchan@kernel.org, fengguang.wu@intel.com

Subject: [folded-merged] zram-propagate-error-to-user-fix-2.patch removed from -mm tree
To: fengguang.wu@intel.com,minchan@kernel.org,sfr@canb.auug.org.au,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 15:15:06 -0700


The patch titled
     Subject: zram: fix coccinelle warnings
has been removed from the -mm tree.  Its filename was
     zram-propagate-error-to-user-fix-2.patch

This patch was dropped because it was folded into zram-propagate-error-to-user.patch

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

origin.patch
tools-vm-page-typesc-page-cache-sniffing-feature.patch
memcg-get_mem_cgroup_from_mm.patch
zram-propagate-error-to-user.patch
slub-use-raw_cpu_inc-for-incrementing-statistics.patch
slub-use-raw_cpu_inc-for-incrementing-statistics-fix.patch

