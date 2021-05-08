Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF4CBC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:52:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8326960E0B
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:52:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhEHWxB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:53:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229647AbhEHWw6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:52:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86E4D60E0B;
        Sat,  8 May 2021 22:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514316;
        bh=qUNoq/Y12bfzPc1BXzc3uBJDf5FfnSqMRyhn699JUwQ=;
        h=Date:From:To:Subject:From;
        b=ZbgwWcOvAwEV2mI8kEZT/ltAlTNU28Vq1bTdNBIk0bPq4w8MVb0Zz4U+uso9RVjrh
         Mmda8sqnUnsTKXP7TKWdpmdRfOH/7EWlenk2O1Ic5XSZgS8pq9bHw8GNw+tETO2XXx
         VOycy8jdd2SXvccHdegBzbvvpjpoRfE1f3I14g0I=
Date:   Sat, 08 May 2021 15:51:56 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zhouchuangao@vivo.com
Subject:  [merged]
 proc-sysctl-fix-function-name-error-in-comments.patch removed from -mm tree
Message-ID: <20210508225156.C5T7sIbbU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc/sysctl: fix function name error in comments
has been removed from the -mm tree.  Its filename was
     proc-sysctl-fix-function-name-error-in-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1563,7 +1563,7 @@ err_register_leaves:
 }
 
 /**
- * register_sysctl_table_path - register a sysctl table hierarchy
+ * register_sysctl_paths - register a sysctl table hierarchy
  * @path: The path to the directory the sysctl table is in.
  * @table: the top-level table structure
  *
_

Patches currently in -mm which might be from zhouchuangao@vivo.com are


