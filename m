Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB54C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 22:29:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F45564E33
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 22:29:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbhCOW2t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 18:28:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232970AbhCOW20 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 18:28:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA7B064F0C;
        Mon, 15 Mar 2021 22:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615847305;
        bh=xRT7NArWHnlWCCs/G+PsQ76iSxN/XCYbz+ZM6RzWUto=;
        h=Date:From:To:Subject:From;
        b=dvC1GEf/Jgvr+LK//JVAP16s3E7PJPN0xePgWW0kaebDZwmPBgfGNxxMi1LFnv6dA
         /7pHleW3InxEJThrOQhMJHcjnydxc/qAFnaLG9V5PUgEii90ROH5DvVcqrIRwNT00N
         xqwvac2GIqaXKY3vs4BzlxtfezZLFLsCxbrO7PEY=
Date:   Mon, 15 Mar 2021 15:28:25 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zhouchuangao@vivo.com
Subject:  + proc-sysctl-fix-function-name-error-in-comments.patch
 added to -mm tree
Message-ID: <20210315222825.qlR_fZixf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc/sysctl: fix function name error in comments
has been added to the -mm tree.  Its filename is
     proc-sysctl-fix-function-name-error-in-comments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc-sysctl-fix-function-name-error-in-comments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc-sysctl-fix-function-name-error-in-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: zhouchuangao <zhouchuangao@vivo.com>
Subject: proc/sysctl: fix function name error in comments

The function name should be modified to register_sysctl_paths instead of
register_sysctl_table_path.

Link: https://lkml.kernel.org/r/1615807194-79646-1-git-send-email-zhouchuangao@vivo.com
Signed-off-by: zhouchuangao <zhouchuangao@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/proc_sysctl.c~proc-sysctl-fix-function-name-error-in-comments
+++ a/fs/proc/proc_sysctl.c
@@ -1562,7 +1562,7 @@ err_register_leaves:
 }
 
 /**
- * register_sysctl_table_path - register a sysctl table hierarchy
+ * register_sysctl_paths - register a sysctl table hierarchy
  * @path: The path to the directory the sysctl table is in.
  * @table: the top-level table structure
  *
_

Patches currently in -mm which might be from zhouchuangao@vivo.com are

proc-sysctl-fix-function-name-error-in-comments.patch
umh-fix-some-spelling-mistakes.patch

