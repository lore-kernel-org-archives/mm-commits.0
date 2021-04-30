Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71704C43460
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:54:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 519C861456
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:54:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbhD3Fy5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:54:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:46280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229508AbhD3Fy5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:54:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3885A6144F;
        Fri, 30 Apr 2021 05:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762049;
        bh=kxVVx+1eJZMs4n2sRd9jKtJOqwj158AFHapGmrIqQME=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bkEK78pkNfu/iuxUdKQT3U/iDcX7r/0W/QIIWyL0Q8rGYh7l1IKFRpRIUKqZqChrg
         qUQJiSxCwBkiLtRHtJQ79300dQxyU0XuOfEDkgIofHYQXSUR+Ydd6eMtvPYrgkD4sn
         Db7kqmX4nzzyhGRUOOe4AvM4BQ912kZqRtylCOzA=
Date:   Thu, 29 Apr 2021 22:54:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joseph.qi@linux.alibaba.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, unixbhaskar@gmail.com
Subject:  [patch 018/178] ocfs2: fix a typo
Message-ID: <20210430055408.C5WETvoux%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
