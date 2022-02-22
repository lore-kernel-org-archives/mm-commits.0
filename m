Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AAF0C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 02:36:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239250AbiBVChL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 21:37:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbiBVChL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 21:37:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238A924F06
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 18:36:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFD8E614F3
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 02:36:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB70C340E9;
        Tue, 22 Feb 2022 02:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645497406;
        bh=mIfjP95mdH1aDhMCa12/BeOZIfXFbe1XVRwGB4w4ahg=;
        h=Date:To:From:Subject:From;
        b=kuLwEG3rc+zGQHEnXFd6TiIO7LBXeEEwG0dNTsXyEVTxNSF23U9UZjcv8Wn7jWP1e
         QMJuBkJOs0RdqJkQ9zOnTHNnh/bS47yvNXH4jCJdR73T71StKmzKRWiG2V4loWoGD6
         jfocX1LYKULE3rD/nAbjtmtVzjZenktmvhngpYns=
Date:   Mon, 21 Feb 2022 18:36:45 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] numa-balancing-optimize-page-placement-for-memory-tiering-system-fix.patch removed from -mm tree
Message-Id: <20220222023646.0BB70C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: numa-balancing-optimize-page-placement-for-memory-tiering-system-fix
has been removed from the -mm tree.  Its filename was
     numa-balancing-optimize-page-placement-for-memory-tiering-system-fix.patch

This patch was dropped because it was folded into numa-balancing-optimize-page-placement-for-memory-tiering-system.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: numa-balancing-optimize-page-placement-for-memory-tiering-system-fix

Cc: "Huang, Ying" <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/Documentation/admin-guide/sysctl/kernel.rst~numa-balancing-optimize-page-placement-for-memory-tiering-system-fix
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -595,14 +595,14 @@ Documentation/admin-guide/kernel-paramet
 numa_balancing
 ==============
 
-Enables/disables and configure automatic page fault based NUMA memory
-balancing.  Memory is moved automatically to nodes that access it
-often.  The value to set can be the result to OR the following,
+Enables/disables and configures automatic page fault based NUMA memory
+balancing.  Memory is moved automatically to nodes that access it often. 
+The value to set can be the result of ORing the following,
 
 = =================================
-0x0 NUMA_BALANCING_DISABLED
-0x1 NUMA_BALANCING_NORMAL
-0x2 NUMA_BALANCING_MEMORY_TIERING
+0 NUMA_BALANCING_DISABLED
+1 NUMA_BALANCING_NORMAL
+2 NUMA_BALANCING_MEMORY_TIERING
 = =================================
 
 Or NUMA_BALANCING_NORMAL to optimize page placement among different
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-munlock-mlock_page-munlock_page-batch-by-pagevec-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
numa-balancing-optimize-page-placement-for-memory-tiering-system.patch
numa-balancing-optimize-page-placement-for-memory-tiering-system-fix-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
mm-dont-include-linux-memremaph-in-linux-mmh-fix.patch
mm-dont-include-linux-memremaph-in-linux-mmh-fix-2-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

