Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2C98C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 19:32:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C99B61A17
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 19:32:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237869AbhCXTbd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Mar 2021 15:31:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237855AbhCXTbc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Mar 2021 15:31:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C64A61A17;
        Wed, 24 Mar 2021 19:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616614291;
        bh=rouS8/Vqd4NzBFTZcsYzxEOv/+DpFXKReRV8MnmzIS8=;
        h=Date:From:To:Subject:From;
        b=LQTIt+vv9rnTputy40DZEufJoc9EfBcGh/67mktCS/1njK1JE61idU+smRaV7qri4
         0gBGuXoqDyw6q8tHzOkX4M4CZptJZ1hRFeqFW3UHrdhDNQcIwayP6Mp8jqhLePl3Km
         s5yi7tSB9RDax1q3gwJtuXR6q5VGi7d7dPfA6XIg=
Date:   Wed, 24 Mar 2021 12:31:31 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, joseph.qi@linux.alibaba.com,
        unixbhaskar@gmail.com
Subject:  + ocfs2-fix-a-typo.patch added to -mm tree
Message-ID: <20210324193131.0xNeb%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix a typo
has been added to the -mm tree.  Its filename is
     ocfs2-fix-a-typo.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-a-typo.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-a-typo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ia64-kernel-few-typos-fixed-in-the-file-fsyss.patch
ia64-include-asm-minor-typo-fixes-in-the-file-pgtableh.patch
ocfs2-fix-a-typo.patch
mm-kmemleak-fix-a-typo.patch
mm-typo-fix-in-the-file-utilc.patch
lib-fix-a-typo-in-the-file-bchc.patch
mm-few-spelling-fixes.patch
kernel-fix-a-typo-in-the-file-upc.patch
ipc-semc-couple-of-spelling-fixes.patch

