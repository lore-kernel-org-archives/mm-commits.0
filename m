Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82E52C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 19:09:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3986364D8F
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 19:09:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235928AbhBXTI5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 14:08:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:39552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235927AbhBXTIw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 14:08:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F17D764F0D;
        Wed, 24 Feb 2021 18:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614193185;
        bh=qdfFews1xRbYaYRq9HpuKT7ZcWxhHMovRAWC9zgst20=;
        h=Date:From:To:Subject:From;
        b=LSLpz0h8qjsesNVr8Mkt60kmUpXZ1zwo0p2cvgNiaW+CZCsOpSRdpROGN1lkPZeEb
         QrQ6jGaZLp5wrC2UZn9mflM1YBfXUQBYhqARBdxI1Bm5CHbxnce5Q2zIqvPmBwCX86
         i4+DXJJF/YNftxALI+YxztYyczaowf9w6f60ynfI=
Date:   Wed, 24 Feb 2021 10:59:42 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usag?=
 =?US-ASCII?Q?e-checkpatch-fixes.patch?= removed from -mm tree
Message-ID: <20210224185942.-QJtl8yIB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes

fix typo in comment

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes
+++ a/include/linux/memcontrol.h
@@ -113,7 +113,7 @@ struct mem_cgroup_per_node {
 
 	/*
 	 * Legacy local VM stats. This should be struct lruvec_stat and
-	 * cannot be optimized to struct batched_lruvec_stat. Becasue
+	 * cannot be optimized to struct batched_lruvec_stat. Because
 	 * the threshold of the lruvec_stat_cpu can be as big as
 	 * MEMCG_CHARGE_BATCH * PAGE_SIZE. It can fit into s32. But this
 	 * filed has no upper limit.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage.patch
mm-memcg-add-swapcache-stat-for-memcg-v2-fix.patch
kasan-add-match-all-tag-tests-fix-fix.patch
mm.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-memory_hotplug-prevalidate-the-address-range-being-added-with-platform-fix.patch
bdi-use-might_alloc-fix.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
lib-stackdepot-add-support-to-disable-stack-depot-fix.patch
seq_file-document-how-per-entry-resources-are-managed-fix.patch
initramfs-panic-with-memory-information-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

