Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D794C43334
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379685AbiFQCMq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238214AbiFQCMa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:12:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BDE164BF9
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:12:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AB2A61C50
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72BC1C3411A;
        Fri, 17 Jun 2022 02:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655431946;
        bh=T2Y9xeSMo46sRwXwpHIlqJKYy2XABGxO7Gn/pAQVKoM=;
        h=Date:To:From:Subject:From;
        b=lCCBHv59c9AxvgID1nYaUmwDQ031rVDHr9/LTBoIrllVSaNSaPO9N5hwFZdJrJlrT
         EUOQiSAqwwF+IjZQkenAe8uma7lT2KtqZsTHqHPOC+3Nwcd/M4j9/wEnrCM8nkNKl6
         RtbwkpzSb9r9qQL28DRGVFfcANBhAoUxUElg99qQ=
Date:   Thu, 16 Jun 2022 19:12:25 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        roman.gushchin@linux.dev, yang.yang29@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memcontrol-reference-to-tools-cgroup-memcg_slabinfopy.patch removed from -mm tree
Message-Id: <20220617021226.72BC1C3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memcontrol: reference to tools/cgroup/memcg_slabinfo.py
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-reference-to-tools-cgroup-memcg_slabinfopy.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Yang <yang.yang29@zte.com.cn>
Subject: mm: memcontrol: reference to tools/cgroup/memcg_slabinfo.py
Date: Fri, 10 Jun 2022 02:44:52 +0000

There is no slabinfo.py in tools/cgroup, but has memcg_slabinfo.py instead.

Link: https://lkml.kernel.org/r/20220610024451.744135-1-yang.yang29@zte.com.cn
Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-reference-to-tools-cgroup-memcg_slabinfopy
+++ a/mm/memcontrol.c
@@ -4859,7 +4859,7 @@ static int mem_cgroup_slab_show(struct s
 {
 	/*
 	 * Deprecated.
-	 * Please, take a look at tools/cgroup/slabinfo.py .
+	 * Please, take a look at tools/cgroup/memcg_slabinfo.py .
 	 */
 	return 0;
 }
_

Patches currently in -mm which might be from yang.yang29@zte.com.cn are


