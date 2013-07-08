From: akpm@linux-foundation.org
Subject: [folded-merged] lib-add-lz4-compressor-module-fix.patch removed
 from -mm tree
Date: Mon, 08 Jul 2013 15:34:52 -0700
Message-ID: <51db3e8c.wvGPt5wI+yV+mMTJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53116 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab3GHWex (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 18:34:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, chanho.min@lge.com, akpm@linux-foundation.org

Subject: [folded-merged] lib-add-lz4-compressor-module-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,chanho.min@lge.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 15:34:52 -0700


The patch titled
     Subject: lib-add-lz4-compressor-module-fix
has been removed from the -mm tree.  Its filename was
     lib-add-lz4-compressor-module-fix.patch

This patch was dropped because it was folded into lib-add-lz4-compressor-module.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-add-lz4-compressor-module-fix

make lz4_compresshcctx() static

Cc: Chanho Min <chanho.min@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lz4/lz4hc_compress.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/lz4/lz4hc_compress.c~lib-add-lz4-compressor-module-fix lib/lz4/lz4hc_compress.c
--- a/lib/lz4/lz4hc_compress.c~lib-add-lz4-compressor-module-fix
+++ a/lib/lz4/lz4hc_compress.c
@@ -314,7 +314,7 @@ static inline int lz4_encodesequence(con
 	return 0;
 }
 
-int lz4_compresshcctx(struct lz4hc_data *ctx,
+static int lz4_compresshcctx(struct lz4hc_data *ctx,
 		const char *source,
 		char *dest,
 		int isize)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid.patch
memcg-use-css_get-put-when-charging-uncharging-kmem.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation.patch
partitions-add-aix-lvm-partition-support-files.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode.patch
lib-add-lz4-compressor-module.patch
crypto-add-lz4-cryptographic-api-fix.patch

