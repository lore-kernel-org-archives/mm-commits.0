Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E51C433ED
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4042D613CB
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbhEEBCZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:02:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:45556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231608AbhEEBCZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:02:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1C2E613BA;
        Wed,  5 May 2021 01:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620176490;
        bh=TKk1jRJ7cD8fTEoGbpDcOrR791jtgh2QhwQUuwJzAas=;
        h=Date:From:To:Subject:From;
        b=d77VFl1Q24ntDVYVp+PFy40jhoh6yB8XzzGWqx/LQUPGrSPYTgkBwDD3MIg+FvYgO
         L5RZfqa3q8NWZe2GWgKIvt5iQOWqeBuAbj9PGDPLdawBe6FPtNDBCtrf5QET1hTWfG
         /KOIsOtcx0AgZxLq/SGv8lSy8FNSO/t6r+04iJnY=
Date:   Tue, 04 May 2021 18:01:29 -0700
From:   akpm@linux-foundation.org
To:     daizhiyuan@phytium.com.cn, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 mm-mempolicy-minor-coding-style-tweaks.patch removed from -mm tree
Message-ID: <20210505010129.Hqq4cUPCa%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: minor coding style tweaks
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-minor-coding-style-tweaks.patch

This patch was dropped because it was folded into mm-mempool-minor-coding-style-tweaks.patch

------------------------------------------------------
From: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Subject: mm/mempolicy: minor coding style tweaks

Add whitespace to fix coding style issues, improve code reading.

Link: https://lkml.kernel.org/r/1613972228-25501-1-git-send-email-daizhiyuan@phytium.com.cn
Signed-off-by: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-minor-coding-style-tweaks
+++ a/mm/mempolicy.c
@@ -330,7 +330,7 @@ static void mpol_rebind_nodemask(struct
 	else if (pol->flags & MPOL_F_RELATIVE_NODES)
 		mpol_relative_nodemask(&tmp, &pol->w.user_nodemask, nodes);
 	else {
-		nodes_remap(tmp, pol->v.nodes,pol->w.cpuset_mems_allowed,
+		nodes_remap(tmp, pol->v.nodes, pol->w.cpuset_mems_allowed,
 								*nodes);
 		pol->w.cpuset_mems_allowed = *nodes;
 	}
@@ -1161,7 +1161,7 @@ int do_migrate_pages(struct mm_struct *m
 
 	tmp = *from;
 	while (!nodes_empty(tmp)) {
-		int s,d;
+		int s, d;
 		int source = NUMA_NO_NODE;
 		int dest = 0;
 
_

Patches currently in -mm which might be from daizhiyuan@phytium.com.cn are

mm-memremap-fixes-improper-spdx-comment-style.patch
mm-interval_tree-add-comments-to-improve-code-reading.patch
mm-dmapool-switch-from-strlcpy-to-strscpy.patch
mm-kasan-switch-from-strlcpy-to-strscpy.patch
mm-zswap-switch-from-strlcpy-to-strscpy.patch
mm-mempool-minor-coding-style-tweaks.patch

