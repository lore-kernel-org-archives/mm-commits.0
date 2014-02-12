From: akpm@linux-foundation.org
Subject: [folded-merged]
 jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc-fix.patch removed from
 -mm tree
Date: Wed, 12 Feb 2014 12:42:30 -0800
Message-ID: <52fbdcb6.OeSXgEtqziId2c06%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52606 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbaBLUmb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Feb 2014 15:42:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, lizefan@huawei.com, dwmw2@infradead.org, akpm@linux-foundation.org

Subject: [folded-merged] jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,dwmw2@infradead.org,lizefan@huawei.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 12 Feb 2014 12:42:30 -0800


The patch titled
     Subject: jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc-fix
has been removed from the -mm tree.  Its filename was
     jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc-fix.patch

This patch was dropped because it was folded into jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc-fix

Cc: <stable@vger.kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/nodemgmt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/jffs2/nodemgmt.c~jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc-fix fs/jffs2/nodemgmt.c
--- a/fs/jffs2/nodemgmt.c~jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc-fix
+++ a/fs/jffs2/nodemgmt.c
@@ -211,7 +211,7 @@ out:
 int jffs2_reserve_space_gc(struct jffs2_sb_info *c, uint32_t minsize,
 			   uint32_t *len, uint32_t sumsize)
 {
-	int ret = -EAGAIN;
+	int ret;
 	minsize = PAD(minsize);
 
 	jffs2_dbg(1, "%s(): Requested 0x%x bytes\n", __func__, minsize);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch
include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-spi-spic-fix-max-warning.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

