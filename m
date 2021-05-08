Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 896F1C43460
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CB0561421
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbhEHWkd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:40:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhEHWkd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:40:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E49361415;
        Sat,  8 May 2021 22:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513571;
        bh=X8hTZQoSokk6kWjSKQxROk/cYLYZTK859Ty7RG1kLzU=;
        h=Date:From:To:Subject:From;
        b=JgRPlnLA0o738wRsgypIf9hV5S8Rl6o9lb2h+dv2LD42RZxVrwDORGhMR/PAOLboj
         QO01zXiVetCTEQLV6YiF0lzTnd2jb+dXNd9RvhvG8DWl59BVvi64WAd5MRRDXZLi8x
         eg8yMzELAxHHgXZVHKYrnJDf5TqxZ/eKT0j6hB+U=
Date:   Sat, 08 May 2021 15:39:31 -0700
From:   akpm@linux-foundation.org
To:     joseph.qi@linux.alibaba.com, mm-commits@vger.kernel.org,
        unixbhaskar@gmail.com
Subject:  [merged] ocfs2-fix-a-typo.patch removed from -mm tree
Message-ID: <20210508223931.N4LzTKuWG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix a typo
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-a-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: ocfs2: fix a typo

s/cluter/cluster/

Link: https://lkml.kernel.org/r/20210324072931.5056-1-unixbhaskar@gmail.com
Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stackglue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/stackglue.c~ocfs2-fix-a-typo
+++ a/fs/ocfs2/stackglue.c
@@ -731,7 +731,7 @@ static void __exit ocfs2_stack_glue_exit
 }
 
 MODULE_AUTHOR("Oracle");
-MODULE_DESCRIPTION("ocfs2 cluter stack glue layer");
+MODULE_DESCRIPTION("ocfs2 cluster stack glue layer");
 MODULE_LICENSE("GPL");
 module_init(ocfs2_stack_glue_init);
 module_exit(ocfs2_stack_glue_exit);
_

Patches currently in -mm which might be from unixbhaskar@gmail.com are


