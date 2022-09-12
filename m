Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55887ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiILDbb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiILD3i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:29:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501702871D
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3C236117A
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 379E8C433D7;
        Mon, 12 Sep 2022 03:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953359;
        bh=4yic0DgCTMdzvwV7SLqKdY59UuI5iWUCzfbwIQsFJXg=;
        h=Date:To:From:Subject:From;
        b=tD9WoY8RhHHNZpYuBwFre1pVX2Jf0gLyFGARdBNBLMGriQHvIsbDg325zYvH4QyZz
         KY6gm6byxZoWujCU39m4LYf6gfhRwkdqPgN5eHfI3HhzBr7My54M8Ml07MxVrBt4nM
         3XiS24KaY/iVG4U/oyA2draCCN8q55gYaVehNW1s=
Date:   Sun, 11 Sep 2022 20:29:18 -0700
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn,
        quic_mojha@quicinc.com, cgel.zte@gmail.com, xu.panda@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-fix-a-typo-in-comment.patch removed from -mm tree
Message-Id: <20220912032919.379E8C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memcontrol: fix a typo in comment
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-a-typo-in-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: xupanda <xu.panda@zte.com.cn>
Subject: mm: memcontrol: fix a typo in comment
Date: Mon, 15 Aug 2022 06:51:04 +0000

Fix a spelling mistake in comment.

Link: https://lkml.kernel.org/r/20220815065102.74347-1-xu.panda@zte.com.cn
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: xupanda <xu.panda@zte.com.cn>
Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-fix-a-typo-in-comment
+++ a/mm/memcontrol.c
@@ -1143,7 +1143,7 @@ static void invalidate_reclaim_iterators
 	} while ((memcg = parent_mem_cgroup(memcg)));
 
 	/*
-	 * When cgruop1 non-hierarchy mode is used,
+	 * When cgroup1 non-hierarchy mode is used,
 	 * parent_mem_cgroup() does not walk all the way up to the
 	 * cgroup root (root_mem_cgroup). So we have to handle
 	 * dead_memcg from cgroup root separately.
_

Patches currently in -mm which might be from xu.panda@zte.com.cn are


