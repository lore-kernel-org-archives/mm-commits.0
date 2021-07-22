Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B53AC4338F
	for <mm-commits@archiver.kernel.org>; Thu, 22 Jul 2021 21:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3205760EB4
	for <mm-commits@archiver.kernel.org>; Thu, 22 Jul 2021 21:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbhGVUtf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Jul 2021 16:49:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:42018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231336AbhGVUtf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Jul 2021 16:49:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A085160E8F;
        Thu, 22 Jul 2021 21:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626989408;
        bh=6GuqRT+D5+tGWe+MXLuK4Q7oeSoGJaGpyhhtvfPMAyU=;
        h=Date:From:To:Subject:From;
        b=2TC4WHPk0BkwcwqlMsP44X4Ws3TcZMWUymFBHddegPvFgHemCCY8DM0RuMHntRj8g
         QRukdg8tk221Fw/LvuNBG3utAjXQoMrmtvQfAzzFAUdxtH8t8K2U5voFitOhmkuu/K
         epzwX34nKgA/Tz7Cdpr4of2p8P+24ipaSt9YtGVc=
Date:   Thu, 22 Jul 2021 14:30:07 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, andriy.shevchenko@linux.intel.com
Subject:  + once-fix-trivia-typo-not-note.patch added to -mm tree
Message-ID: <20210722213007.LdKIF%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/once.h: fix trivia typo Not -> Note
has been added to the -mm tree.  Its filename is
     once-fix-trivia-typo-not-note.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/once-fix-trivia-typo-not-note.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/once-fix-trivia-typo-not-note.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

once-fix-trivia-typo-not-note.patch

