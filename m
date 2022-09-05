Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C14EDECAAA1
	for <mm-commits@archiver.kernel.org>; Mon,  5 Sep 2022 22:01:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbiIEWBJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Sep 2022 18:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232270AbiIEWBC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Sep 2022 18:01:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04DD33361
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 15:00:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA77060C5E
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 22:00:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44818C433D6;
        Mon,  5 Sep 2022 22:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662415252;
        bh=gZpOqhMsXVcW/x4dvs8zlLSNCgNp+RnT6fgLPBiljq8=;
        h=Date:To:From:Subject:From;
        b=ohI0Php9rHLW58hesfkEDD+bW/QA0VTMiXNvjW5XgrAaXf+q5CIKQkWDjk55sIFGw
         sJ02Pxszf0BkIYAuDNqBgxY6y32Jx/BEj/g4gaZMp/8yyFXG3Fm/djrvFI7RkznJvg
         v3Y4qWEytMH5JrjO3XoPjyl7u/ZrVLJdaLiLOzuk=
Date:   Mon, 05 Sep 2022 15:00:51 -0700
To:     mm-commits@vger.kernel.org, kernel-bot@kylinos.cn,
        yijiangshan@kylinos.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + inith-fix-spelling-typo-in-comment.patch added to mm-nonmm-unstable branch
Message-Id: <20220905220052.44818C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init.h: fix spelling typo in comment
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     inith-fix-spelling-typo-in-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/inith-fix-spelling-typo-in-comment.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jiangshan Yi <yijiangshan@kylinos.cn>
Subject: init.h: fix spelling typo in comment
Date: Mon, 5 Sep 2022 10:10:34 +0800

Fix spelling typo in comment.

Link: https://lkml.kernel.org/r/20220905021034.947701-1-13667453960@163.com
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Reported-by: k2ci <kernel-bot@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/init.h~inith-fix-spelling-typo-in-comment
+++ a/include/linux/init.h
@@ -134,7 +134,7 @@ static inline initcall_t initcall_from_e
 
 extern initcall_entry_t __con_initcall_start[], __con_initcall_end[];
 
-/* Used for contructor calls. */
+/* Used for constructor calls. */
 typedef void (*ctor_fn_t)(void);
 
 struct file_system_type;
_

Patches currently in -mm which might be from yijiangshan@kylinos.cn are

fs-ocfs2-suballoch-fix-spelling-typo-in-comment.patch
inith-fix-spelling-typo-in-comment.patch

