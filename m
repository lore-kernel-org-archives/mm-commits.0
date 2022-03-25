Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C06CC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:41:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233916AbiCYWnZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233913AbiCYWnQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D34208C20
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:41:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42172B82A1C
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:41:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9696C340ED;
        Fri, 25 Mar 2022 22:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248098;
        bh=u2x0HvAv9lUuE+fdWzk9q65UYpPx6EBI1iskoofqb3Y=;
        h=Date:To:From:Subject:From;
        b=kwNwEbtKaOQ3EuZMK7d6Y2QXK8pCn/oe5FUAGzT+A23SPj9OFmhTZydgVAW2YM8kL
         U5yFXcLGkZOmKUAFRz5lfzLdZaU708Whg+fkKEuWbsrkUzKQmIT0RpI3cOIaoUBfdk
         bm1tulAerZg6E1qVjA+4RKIDHQePtDXJzye2QKIY=
Date:   Fri, 25 Mar 2022 15:41:38 -0700
To:     mm-commits@vger.kernel.org, zhangyinan2019@email.szu.edu.cn,
        weizhenliang@huawei.com, sfr@canb.auug.org.au,
        caoyixuan2019@email.szu.edu.cn, yejiajian2018@email.szu.edu.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] tools-vm-page_owner_sortc-fix-comments.patch removed from -mm tree
Message-Id: <20220325224138.D9696C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner_sort.c: fix comments
has been removed from the -mm tree.  Its filename was
     tools-vm-page_owner_sortc-fix-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Subject: tools/vm/page_owner_sort.c: fix comments

Two adjustments are made:

1. Correct a grammatical error: replace the "what" in "Do the job what
   you want to debug" with "that".

2. Replace "has not been" with "has been" in the description of the -f
   option: According to Commit b1c9ba071e7d ("tools/vm/page_owner_sort.c:
   fix the instructions for use"), the description of the "-f" option is
   "Filter out the information of blocks whose memory has been released."

Link: https://lkml.kernel.org/r/20220301151438.166118-1-yejiajian2018@email.szu.edu.cn
Signed-off-by: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Cc: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Zhenliang Wei <weizhenliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_owner.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/vm/page_owner.rst~tools-vm-page_owner_sortc-fix-comments
+++ a/Documentation/vm/page_owner.rst
@@ -78,7 +78,7 @@ Usage
 
 2) Enable page owner: add "page_owner=on" to boot cmdline.
 
-3) Do the job what you want to debug
+3) Do the job that you want to debug.
 
 4) Analyze information from page owner::
 
@@ -126,4 +126,4 @@ Usage
 		-c		Cull by comparing stacktrace instead of total block.
 
 	Filter:
-		-f		Filter out the information of blocks whose memory has not been released.
+		-f		Filter out the information of blocks whose memory has been released.
_

Patches currently in -mm which might be from yejiajian2018@email.szu.edu.cn are


