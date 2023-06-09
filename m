Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3911C7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:32:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232947AbjFIXcA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232966AbjFIXbM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:31:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E606F3C15
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C67EF63EB7
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288EBC433EF;
        Fri,  9 Jun 2023 23:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353344;
        bh=R6utrnd4GZJv9SzLwVoFGRUH75eaOPlYvDIPIrK3OHA=;
        h=Date:To:From:Subject:From;
        b=kqc7loQ4cNIYoy341tCPGJw84njzQNtYwj/VasXpgW6Eq6WrtLggD+7cRWYhurhUa
         6wV5eNqTfFQLiXGFpBVzuc8W5TtEb/sNxfqrC//czIIrRiDlArm7O4tAwd9AKEzuGK
         7KlRcOnnTVI3GKYlCsIvVgtb6FUnNC26NK40sLUM=
Date:   Fri, 09 Jun 2023 16:29:03 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        haifeng.xu@shopee.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-fix-typo-in-comment.patch removed from -mm tree
Message-Id: <20230609232904.288EBC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memcontrol: fix typo in comment
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-typo-in-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-mm_initc-drop-nid-parameter-from-check_for_memory.patch
mm-memory_hotplug-remove-reset_node_managed_pages-in-hotadd_init_pgdat.patch
mm-mm_initc-remove-reset_node_present_pages.patch
fork-optimize-memcg_charge_kernel_stack-a-bit.patch

