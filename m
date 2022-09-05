Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A206FECAAD3
	for <mm-commits@archiver.kernel.org>; Mon,  5 Sep 2022 20:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbiIEUcD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Sep 2022 16:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbiIEUcB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Sep 2022 16:32:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C92BB8
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 13:32:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F36A5B811FE
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 20:31:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A88C433D6;
        Mon,  5 Sep 2022 20:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662409918;
        bh=YBv9UCefhQVek5UQMOlFynuTYiD0JdwvAfb7RzVOt2M=;
        h=Date:To:From:Subject:From;
        b=wFUlwpoeNXErbSanP5JVUfLPTn7TkH5Y2AQ+yvAu13Q6UNQ7gqmkOVXVztfRyeymu
         tdWN6V+Fyfjs1uaKzZLbDWZCexvE9mPwZosdTRlH5VYgZZOGIUESRTchuHllG8FuC/
         vUUUWvePyIJxFDgH/G7XY6893ZWVNdkloeAHbK9E=
Date:   Mon, 05 Sep 2022 13:31:57 -0700
To:     mm-commits@vger.kernel.org, kernel-bot@kylinos.cn,
        joseph.qi@linux.alibaba.com, yijiangshan@kylinos.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-ocfs2-suballoch-fix-spelling-typo-in-comment.patch added to mm-nonmm-unstable branch
Message-Id: <20220905203158.96A88C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ocfs2/suballoc.h: fix spelling typo in comment
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-ocfs2-suballoch-fix-spelling-typo-in-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-ocfs2-suballoch-fix-spelling-typo-in-comment.patch

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
Subject: fs/ocfs2/suballoc.h: fix spelling typo in comment
Date: Mon, 5 Sep 2022 14:16:56 +0800

Fix spelling typo in comment.

Link: https://lkml.kernel.org/r/20220905061656.1829179-1-13667453960@163.com
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Reported-by: k2ci <kernel-bot@kylinos.cn>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/suballoc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/suballoc.h~fs-ocfs2-suballoch-fix-spelling-typo-in-comment
+++ a/fs/ocfs2/suballoc.h
@@ -106,7 +106,7 @@ int ocfs2_claim_clusters(handle_t *handl
 			 u32 *cluster_start,
 			 u32 *num_clusters);
 /*
- * Use this variant of ocfs2_claim_clusters to specify a maxiumum
+ * Use this variant of ocfs2_claim_clusters to specify a maximum
  * number of clusters smaller than the allocation reserved.
  */
 int __ocfs2_claim_clusters(handle_t *handle,
_

Patches currently in -mm which might be from yijiangshan@kylinos.cn are

fs-ocfs2-suballoch-fix-spelling-typo-in-comment.patch

