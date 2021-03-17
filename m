Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33047C433E6
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 23:40:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE69564E41
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 23:40:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhCQXjk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Mar 2021 19:39:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229570AbhCQXjI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Mar 2021 19:39:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0275B64EED;
        Wed, 17 Mar 2021 23:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616024348;
        bh=yII87iVQWqvVMX1ccG8uGjKB03IbUX3gd16zKGp7PaY=;
        h=Date:From:To:Subject:From;
        b=Z+/6eeZKlQnSf2tXWULz3juY7asLoJkKpc7Q3bb7XSwLmvkEgvpw+t5Nv8wBkn5Bc
         +/aD5QIYFuXEkk+tpU25GnLceQwILlx8x0CiMiLkYFuJHZmtdMjUEC1bEAlOBBr6Cs
         skEG6/Yh8VjHva19Ibh5Lw+M5N+2BHW1TWbXYR6U=
Date:   Wed, 17 Mar 2021 16:39:07 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        unixbhaskar@gmail.com, willy@infradead.org
Subject:  + mm-typo-fix-in-the-file-utilc.patch added to -mm tree
Message-ID: <20210317233907.DQSNGSQw4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/util.c: fix typo
has been added to the -mm tree.  Its filename is
     mm-typo-fix-in-the-file-utilc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-typo-fix-in-the-file-utilc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-typo-fix-in-the-file-utilc.patch

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
Subject: mm/util.c: fix typo

s/condtion/condition/

Link: https://lkml.kernel.org/r/20210317033439.3429411-1-unixbhaskar@gmail.com
Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/util.c~mm-typo-fix-in-the-file-utilc
+++ a/mm/util.c
@@ -765,7 +765,7 @@ int overcommit_policy_handler(struct ctl
 	 * The deviation of sync_overcommit_as could be big with loose policy
 	 * like OVERCOMMIT_ALWAYS/OVERCOMMIT_GUESS. When changing policy to
 	 * strict OVERCOMMIT_NEVER, we need to reduce the deviation to comply
-	 * with the strict "NEVER", and to avoid possible race condtion (even
+	 * with the strict "NEVER", and to avoid possible race condition (even
 	 * though user usually won't too frequently do the switching to policy
 	 * OVERCOMMIT_NEVER), the switch is done in the following order:
 	 *	1. changing the batch
_

Patches currently in -mm which might be from unixbhaskar@gmail.com are

ia64-kernel-few-typos-fixed-in-the-file-fsyss.patch
ia64-include-asm-minor-typo-fixes-in-the-file-pgtableh.patch
mm-typo-fix-in-the-file-utilc.patch
lib-fix-a-typo-in-the-file-bchc.patch

