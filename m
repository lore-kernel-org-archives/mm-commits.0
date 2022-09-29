Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6BCFC04A95
	for <mm-commits@archiver.kernel.org>; Thu, 29 Sep 2022 04:09:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbiI2EI7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Sep 2022 00:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbiI2EI4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2022 00:08:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C137412757D
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 21:08:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C2DEB821DA
        for <mm-commits@vger.kernel.org>; Thu, 29 Sep 2022 04:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19F9C433D6;
        Thu, 29 Sep 2022 04:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664424533;
        bh=eWBANxGyl/TPIB0mSjK8uv8Q8sCsWgFHJeFs/ytDDBw=;
        h=Date:To:From:Subject:From;
        b=pR4fy4UfO09skEzH8aL6ej/6eOXbUnBint5nlXt7sRFnPx1Q0nNOpUpdxHmVgALjr
         TDJU7PE7aExAHPiIq1vMI6UCfAGj0176v9PYzCZuzAx65eq5Z8SxoVKxWNFAChb3tb
         wVEywtrVHLLMSwRFqg5hfTwAAqb29GZ57y25CJwM=
Date:   Wed, 28 Sep 2022 21:08:51 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-remove-obsolete-gfpflags_normal_context-fix.patch removed from -mm tree
Message-Id: <20220929040852.F19F9C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-page_alloc-remove-obsolete-gfpflags_normal_context-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-obsolete-gfpflags_normal_context-fix.patch

This patch was dropped because it was folded into mm-page_alloc-remove-obsolete-gfpflags_normal_context.patch

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm-page_alloc-remove-obsolete-gfpflags_normal_context-fix
Date: Mon, 19 Sep 2022 17:30:51 +0800

fix htmldocs

Link: https://lkml.kernel.org/r/1bc55727-9b66-0e9e-c306-f10c4716ea89@huawei.com
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/mm-api.rst |    3 ---
 1 file changed, 3 deletions(-)

--- a/Documentation/core-api/mm-api.rst~mm-page_alloc-remove-obsolete-gfpflags_normal_context-fix
+++ a/Documentation/core-api/mm-api.rst
@@ -19,9 +19,6 @@ User Space Memory Access
 Memory Allocation Controls
 ==========================
 
-.. kernel-doc:: include/linux/gfp.h
-   :internal:
-
 .. kernel-doc:: include/linux/gfp_types.h
    :doc: Page mobility and placement hints
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

writeback-remove-unused-macro-dirty_full_scope.patch
mm-page_alloc-ensure-kswapd-doesnt-accidentally-go-to-sleep.patch
mm-page_alloc-make-zone_pcp_update-static.patch
mm-remove-obsolete-macro-nr_pcp_order_mask-and-nr_pcp_order_width.patch
mm-page_alloc-remove-obsolete-comment-in-zone_statistics.patch
mm-page_alloc-add-__init-annotations-to-init_mem_debugging_and_hardening.patch
mm-page_alloc-fix-freeing-static-percpu-memory.patch
mm-remove-obsolete-pgdat_is_empty.patch
mm-page_alloc-add-missing-is_migrate_isolate-check-in-set_page_guard.patch
mm-page_alloc-use-local-variable-zone_idx-directly.patch
mm-memory_hotplug-remove-obsolete-generic_free_nodedata.patch
mm-page_alloc-make-boot_nodestats-static.patch
mm-page_alloc-use-helper-macro-sz_1km.patch
mm-page_alloc-init-local-variable-buddy_pfn.patch
mm-page_alloc-use-costly_order-in-warn_on_once_gfp.patch
mm-page_alloc-remove-obsolete-gfpflags_normal_context.patch
mm-page_alloc-fix-obsolete-comment-in-deferred_pfn_valid.patch

