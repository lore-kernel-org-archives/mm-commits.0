Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF057C43217
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB9B8611C1
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345763AbhIIVFf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:05:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345899AbhIIVEj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:04:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66786611C1;
        Thu,  9 Sep 2021 21:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221409;
        bh=OeY77t2SqITp3hDya4yV3ZAefV1faj3Cshq8EEL6/1U=;
        h=Date:From:To:Subject:From;
        b=IBDsz1qujsKeg93hx3hfefz2KfGJp91z8HxRidCVX4D//SZzykbLHw23FwkrH1Q4q
         tnCQsMiZDfDYF5tEDmhvE9AAqkQj5MDuokFVa5+KkM86QIITPI6pj0aapJh7m2gGJV
         roTfNrRK1XEl7Cvy2XMbTiac8jLHMlBozQkuL6Jg=
Date:   Thu, 09 Sep 2021 14:03:29 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org
Subject:  [merged] once-fix-trivia-typo-not-note.patch removed from
 -mm tree
Message-ID: <20210909210329.3GTbks0K1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/once.h: fix trivia typo Not -> Note
has been removed from the -mm tree.  Its filename was
     once-fix-trivia-typo-not-note.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: include/linux/once.h: fix trivia typo Not -> Note

Fix trivia typo Not -> Note in the comment to DO_ONCE().

Link: https://lkml.kernel.org/r/20210722184349.76290-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/once.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/once.h~once-fix-trivia-typo-not-note
+++ a/include/linux/once.h
@@ -16,7 +16,7 @@ void __do_once_done(bool *done, struct s
  * out the condition into a nop. DO_ONCE() guarantees type safety of
  * arguments!
  *
- * Not that the following is not equivalent ...
+ * Note that the following is not equivalent ...
  *
  *   DO_ONCE(func, arg);
  *   DO_ONCE(func, arg);
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


