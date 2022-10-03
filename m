Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 421CEC433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiJCVaQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiJCV3u (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:29:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473FD57556
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:22:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8A92611D2
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3E1C433C1;
        Mon,  3 Oct 2022 21:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664832150;
        bh=g/0VTaPG5gm6u736cnEeMCfFkWTHOsUm5ay2HgL7DRE=;
        h=Date:To:From:Subject:From;
        b=fweMF7iQo8PNJxoVu3CmtrwTGeGxuRiXik02UWz523+GNaVLyXn6vT1I3Sys3WlA0
         O/b7/RteYFq1qD7mf+weruSZXVPVVKt2bXXTgb+0N0jZdnFWE/RRRawzzVVe1cTuOO
         5GhnnE15F32J45pcBcdv9yM5Bm1wD3cjH+rRtsT0=
Date:   Mon, 03 Oct 2022 14:22:29 -0700
To:     mm-commits@vger.kernel.org, kernel-bot@kylinos.cn,
        joseph.qi@linux.alibaba.com, yijiangshan@kylinos.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-ocfs2-suballoch-fix-spelling-typo-in-comment.patch removed from -mm tree
Message-Id: <20221003212230.3D3E1C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs/ocfs2/suballoc.h: fix spelling typo in comment
has been removed from the -mm tree.  Its filename was
     fs-ocfs2-suballoch-fix-spelling-typo-in-comment.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


