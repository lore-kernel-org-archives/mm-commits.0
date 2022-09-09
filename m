Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0AC6ECAAA1
	for <mm-commits@archiver.kernel.org>; Fri,  9 Sep 2022 22:31:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiIIWbv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Sep 2022 18:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiIIWbt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2022 18:31:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD1399B4C
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 15:31:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4510B82680
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 22:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51189C433C1;
        Fri,  9 Sep 2022 22:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662762706;
        bh=HlmdyNX4ZIyHokNLn+ZwwXFgtTbKdnICPOOCC8xhtqE=;
        h=Date:To:From:Subject:From;
        b=nJqV8NL9+fMGhuP6IS9ZN8+a9oAP/dOuRlIrdh+vZuSS/uemwVovkPCOsi84n9KSn
         pKhy5EfhbIEjdn4VVJYsmjJrPwSp+h29dELPSXYnGhZYDcbMIBKzrFhqlSr0osXE30
         1dRDn7mt0AX58WxPdAYJGk9q00zauoFNZkRT1LDM=
Date:   Fri, 09 Sep 2022 15:31:45 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        wangjianli@cdjrlc.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-ocfs2-fix-repeated-words-in-comments.patch added to mm-nonmm-unstable branch
Message-Id: <20220909223146.51189C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ocfs2: fix repeated words in comments
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-ocfs2-fix-repeated-words-in-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-ocfs2-fix-repeated-words-in-comments.patch

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
From: wangjianli <wangjianli@cdjrlc.com>
Subject: fs/ocfs2: fix repeated words in comments
Date: Thu, 8 Sep 2022 21:00:36 +0800

Delete the redundant word 'to'.

Link: https://lkml.kernel.org/r/20220908130036.31149-1-wangjianli@cdjrlc.com
Signed-off-by: wangjianli <wangjianli@cdjrlc.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/refcounttree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/refcounttree.c~fs-ocfs2-fix-repeated-words-in-comments
+++ a/fs/ocfs2/refcounttree.c
@@ -2614,7 +2614,7 @@ static inline unsigned int ocfs2_cow_ali
 }
 
 /*
- * Calculate out the start and number of virtual clusters we need to to CoW.
+ * Calculate out the start and number of virtual clusters we need to CoW.
  *
  * cpos is vitual start cluster position we want to do CoW in a
  * file and write_len is the cluster length.
_

Patches currently in -mm which might be from wangjianli@cdjrlc.com are

fs-ocfs2-fix-repeated-words-in-comments.patch

