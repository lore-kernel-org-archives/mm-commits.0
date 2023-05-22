Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 852C2C7EE29
	for <mm-commits@archiver.kernel.org>; Mon, 22 May 2023 20:38:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234088AbjEVUh7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 May 2023 16:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234554AbjEVUh7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 May 2023 16:37:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202AAE71
        for <mm-commits@vger.kernel.org>; Mon, 22 May 2023 13:37:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B4AC62BC9
        for <mm-commits@vger.kernel.org>; Mon, 22 May 2023 20:37:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD472C433EF;
        Mon, 22 May 2023 20:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684787848;
        bh=yEaEqpPjIdrptWvNR3XJ/3vkkRJN4TwkNjIW9wSNd7A=;
        h=Date:To:From:Subject:From;
        b=iiM010Nv6ikuF+sTnRcC/mXw0RaPN/Ghf80gJLJbho8/DVAMrU5sDHIl5n7kSw5A+
         wFZKolxhj+AgNdnfsdac/elvQUgAX8scT0J0k61liwSVm4CVWcrllW4UBGKwXEmneG
         xd0Va7kbMyz2EiMs6WSn5q3lYGRJ/yNpgUA9aq3A=
Date:   Mon, 22 May 2023 13:37:28 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        haifeng.xu@shopee.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-fix-typo-in-comment.patch added to mm-unstable branch
Message-Id: <20230522203728.CD472C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol: fix typo in comment
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-fix-typo-in-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-fix-typo-in-comment.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: mm/memcontrol: fix typo in comment
Date: Mon, 22 May 2023 09:52:32 +0000

Replace 'then' with 'than'.

Link: https://lkml.kernel.org/r/20230522095233.4246-1-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-fix-typo-in-comment
+++ a/mm/memcontrol.c
@@ -6862,7 +6862,7 @@ static unsigned long effective_protectio
 	protected = min(usage, setting);
 	/*
 	 * If all cgroups at this level combined claim and use more
-	 * protection then what the parent affords them, distribute
+	 * protection than what the parent affords them, distribute
 	 * shares in proportion to utilization.
 	 *
 	 * We are using actual utilization rather than the statically
_

Patches currently in -mm which might be from haifeng.xu@shopee.com are

memcg-oom-remove-unnecessary-check-in-mem_cgroup_oom_synchronize.patch
memcg-oom-remove-explicit-wakeup-in-mem_cgroup_oom_synchronize.patch
mm-oom-do-not-check-0-mask-in-out_of_memory.patch
mm-memcontrol-fix-typo-in-comment.patch
selftests-cgroup-fix-unexpected-failure-on-test_memcg_low.patch
fork-optimize-memcg_charge_kernel_stack-a-bit.patch

