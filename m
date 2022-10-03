Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 359F7C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiJCVa1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiJCV3y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:29:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B826457BC0
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:22:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F404CCE0E5D
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:22:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B264EC433C1;
        Mon,  3 Oct 2022 21:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664832158;
        bh=UrFLsxsuyUyWwI20s5ieZYwf+cSNOL3O5E1iNQH+2WQ=;
        h=Date:To:From:Subject:From;
        b=igv+iYb9vnbtRAGHCcY9xTR23mj3Vxz9J7wCY88W/eNs619G/SkBHOtQrMOCTUU73
         fKp3Z/LHMSEEzF//DS39c6Uf7PAT+HD9nLucNxUIgUuxyOZL/6SQjmgqofjyKlq3XI
         Mmpnd01iFyz4cIxkzTf9uhCL5wP0kT2bBuVA1oN0=
Date:   Mon, 03 Oct 2022 14:22:38 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        wangjianli@cdjrlc.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-ocfs2-fix-repeated-words-in-comments.patch removed from -mm tree
Message-Id: <20221003212238.B264EC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs/ocfs2: fix repeated words in comments
has been removed from the -mm tree.  Its filename was
     fs-ocfs2-fix-repeated-words-in-comments.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


