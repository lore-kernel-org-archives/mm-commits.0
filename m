Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F380C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 25 May 2022 17:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343506AbiEYRtE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 May 2022 13:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343521AbiEYRtD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 May 2022 13:49:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C29322285
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 10:49:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D762B81E8F
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 17:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF81C34113;
        Wed, 25 May 2022 17:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653500939;
        bh=uEIXM3SdoY0UZ3vuxeqCBYPvgsJzy+wrBe3Yk6F5KW8=;
        h=Date:To:From:Subject:From;
        b=tKiD5njgeyn1GzC+DSaIbDfpcU/RhRy6Z6q+MQZc6iEAIaFZrG8duKZqo0rk07ExR
         hBOW+y/B8/bm9XYDaIrJ8jlAWZfj98j7zzqw2DxCKxRDkVGPjGFZVuu7/iEn5pJsat
         db0YYPureqPuOTbVZm6znpMpaHSqdjchnZs4gLdM=
Date:   Wed, 25 May 2022 10:48:58 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        Julia.Lawall@inria.fr, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ksm-fix-typo-in-comment.patch removed from -mm tree
Message-Id: <20220525174859.3FF81C34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ksm: fix typo in comment
has been removed from the -mm tree.  Its filename was
     ksm-fix-typo-in-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Julia Lawall <Julia.Lawall@inria.fr>
Subject: ksm: fix typo in comment
Date: Sat, 21 May 2022 13:11:44 +0200

Spelling mistake (triple letters) in comment.  Detected with the help of
Coccinelle.

Link: https://lkml.kernel.org/r/20220521111145.81697-94-Julia.Lawall@inria.fr
Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/ksm.c~ksm-fix-typo-in-comment
+++ a/mm/ksm.c
@@ -1590,7 +1590,7 @@ again:
 		 * the rbtree instead as a regular stable_node (in
 		 * order to collapse the stable_node chain if a single
 		 * stable_node dup was found in it). In such case the
-		 * stable_node is overwritten by the calleee to point
+		 * stable_node is overwritten by the callee to point
 		 * to the stable_node_dup that was collapsed in the
 		 * stable rbtree and stable_node will be equal to
 		 * stable_node_dup like if the chain never existed.
_

Patches currently in -mm which might be from Julia.Lawall@inria.fr are


