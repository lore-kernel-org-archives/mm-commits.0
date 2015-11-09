From: akpm@linux-foundation.org
Subject: [merged] fs-jffs2-wbufc-remove-stray-semicolon.patch removed from -mm tree
Date: Mon, 09 Nov 2015 11:45:44 -0800
Message-ID: <5640f7e8.owG4pryK9DkY2Yv5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57275 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbbKITpo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:45:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dwmw2@infradead.org, fengguang.wu@intel.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/jffs2/wbuf.c: remove stray semicolon
has been removed from the -mm tree.  Its filename was
     fs-jffs2-wbufc-remove-stray-semicolon.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/jffs2/wbuf.c: remove stray semicolon

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/wbuf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/jffs2/wbuf.c~fs-jffs2-wbufc-remove-stray-semicolon fs/jffs2/wbuf.c
--- a/fs/jffs2/wbuf.c~fs-jffs2-wbufc-remove-stray-semicolon
+++ a/fs/jffs2/wbuf.c
@@ -1264,7 +1264,7 @@ int jffs2_dataflash_setup(struct jffs2_s
 	if ((c->flash_size % c->sector_size) != 0) {
 		c->flash_size = (c->flash_size / c->sector_size) * c->sector_size;
 		pr_warn("flash size adjusted to %dKiB\n", c->flash_size);
-	};
+	}
 
 	c->wbuf_ofs = 0xFFFFFFFF;
 	c->wbuf = kmalloc(c->wbuf_pagesize, GFP_KERNEL);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-arm-fix.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
remove-abs64-fix-fix.patch
remove-abs64-fix-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

