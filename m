From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch removed
 from -mm tree
Date: Wed, 06 Sep 2017 15:57:07 -0700
Message-ID: <59b07d43.g+T+7cIg5pwHiRn8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45716 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752454AbdIFW5J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 18:57:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, liuj97@gmail.com, mhocko@suse.com, qiuxishi@huawei.com, richard.weiyang@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch

This patch was dropped because it was folded into mm-memory_hotplug-just-build-zonelist-for-new-added-node.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix

tweak comment text

Cc: Jiang Liu <liuj97@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix
+++ a/mm/page_alloc.c
@@ -5278,8 +5278,9 @@ static int __build_all_zonelists(void *d
 	memset(node_load, 0, sizeof(node_load));
 #endif
 
-	/* This node is hotadded and no memory preset yet.
-	 * So just build zonelists is fine, no need to touch other nodes.
+	/*
+	 * This node is hotadded and no memory is yet present.   So just
+	 * building zonelists is fine - no need to touch other nodes.
 	 */
 	if (self && !node_online(self->node_id))
 		build_zonelists(self);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory_hotplug-just-build-zonelist-for-new-added-node.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
mm-page_owner-make-init_pages_in_zone-faster-fix-checkpatch-fixes.patch
zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch
userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix.patch
mm-swap-add-swap-readahead-hit-statistics-fix.patch
swap-choose-swap-device-according-to-numa-node-v2-fix.patch
mmfork-introduce-madv_wipeonfork-fix.patch

