Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EBE0C4167B
	for <mm-commits@archiver.kernel.org>; Wed,  1 Nov 2023 19:47:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347400AbjKATrr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Nov 2023 15:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348056AbjKATrh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Nov 2023 15:47:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 000D411D
        for <mm-commits@vger.kernel.org>; Wed,  1 Nov 2023 12:47:30 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911ACC433C7;
        Wed,  1 Nov 2023 19:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698868050;
        bh=NcMw91bsCAM0nOJ+Ty771QdRFvSMR81UrcajmfGh0a8=;
        h=Date:To:From:Subject:From;
        b=xZuGdFgBBXKMdVFTX9kfi/kJkEtw+JMQS8HC7SZTzIOAXZ7Pe52eDqQdudNlzztb9
         2cBRHrpXmhP4p7J5VQyZfJzdh0PN/kV8KORHf7mfO3K6IYcJiqhOOhl0yA3SK0QpFL
         Ax/540cC5gZXEnL5jCEt0jFNNx4vJL9ZQQ9WEdSk=
Date:   Wed, 01 Nov 2023 12:47:28 -0700
To:     mm-commits@vger.kernel.org, joseph.qi@linux.alibaba.com,
        chentao@kylinos.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-fix-a-spelling-typo-in-comment.patch removed from -mm tree
Message-Id: <20231101194730.911ACC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: fix a spelling typo in comment
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-a-spelling-typo-in-comment.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kunwu Chan <chentao@kylinos.cn>
Subject: ocfs2: fix a spelling typo in comment
Date: Wed, 25 Oct 2023 15:29:06 +0800

Fix a spelling typo in comment.

Link: https://lkml.kernel.org/r/20231025072906.14285-1-chentao@kylinos.cn
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/buffer_head_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/buffer_head_io.c~ocfs2-fix-a-spelling-typo-in-comment
+++ a/fs/ocfs2/buffer_head_io.c
@@ -345,7 +345,7 @@ read_failure:
 				if (new_bh && bh) {
 					/* If middle bh fails, let previous bh
 					 * finish its read and then put it to
-					 * aovoid bh leak
+					 * avoid bh leak
 					 */
 					if (!buffer_jbd(bh))
 						wait_on_buffer(bh);
_

Patches currently in -mm which might be from chentao@kylinos.cn are


