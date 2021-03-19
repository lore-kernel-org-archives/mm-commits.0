Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B201C433C1
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 22:08:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FFFC61976
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 22:08:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhCSWH4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Mar 2021 18:07:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230273AbhCSWHt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Mar 2021 18:07:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4868C61975;
        Fri, 19 Mar 2021 22:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616191669;
        bh=Yh1yVOqXFlA7FAdun/NuiD38Xf11stR4PlHV+k3/IBU=;
        h=Date:From:To:Subject:From;
        b=b1f3t9QGH5DwWE/ksA2rgTPjhp898biQvJD1clrUEiSNwaf4bwKUjQieptnY6KeoT
         68KbWNnKyowrI1iAn2IcUy7EXPPkXkEGsTKxnCd1ytSpyqSooeX9C2ZLPJ5PneEaki
         p8Y5uEH9CgtzvhLOUdnYOvZDgpjik+NDDtjnlDfg=
Date:   Fri, 19 Mar 2021 15:07:48 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, unixbhaskar@gmail.com
Subject:  + mm-kmemleak-fix-a-typo.patch added to -mm tree
Message-ID: <20210319220748.VAMDaoRkC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kmemleak.c: fix a typo
has been added to the -mm tree.  Its filename is
     mm-kmemleak-fix-a-typo.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-kmemleak-fix-a-typo.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-kmemleak-fix-a-typo.patch

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
Subject: mm/kmemleak.c: fix a typo

s/interruptable/interruptible/

Link: https://lkml.kernel.org/r/20210319214140.23304-1-unixbhaskar@gmail.com
Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kmemleak.c~mm-kmemleak-fix-a-typo
+++ a/mm/kmemleak.c
@@ -1203,7 +1203,7 @@ static void update_refs(struct kmemleak_
 }
 
 /*
- * Memory scanning is a long process and it needs to be interruptable. This
+ * Memory scanning is a long process and it needs to be interruptible. This
  * function checks whether such interrupt condition occurred.
  */
 static int scan_should_stop(void)
_

Patches currently in -mm which might be from unixbhaskar@gmail.com are

ia64-kernel-few-typos-fixed-in-the-file-fsyss.patch
ia64-include-asm-minor-typo-fixes-in-the-file-pgtableh.patch
mm-kmemleak-fix-a-typo.patch
mm-typo-fix-in-the-file-utilc.patch
kernel-fix-a-typo-in-the-file-upc.patch
lib-fix-a-typo-in-the-file-bchc.patch

