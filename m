Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27D3ACDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:44:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232694AbjJRVoU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232127AbjJRVoS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:44:18 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5D3122
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:44:02 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434E8C433D9;
        Wed, 18 Oct 2023 21:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697665442;
        bh=mysvBmk4sEx7G8lCaVF+DFPfE0moIj1TFYEG2OIXnBk=;
        h=Date:To:From:Subject:From;
        b=QBd4WBHfuygTp2fNlqlZbrYpyxWtu+6iV6uQkpz0W7Kq9wigm7HvNET8wvnrCxOce
         FwTGcFXXWVM1QujzFgm60PySkCnz7foLNIbLJ81kBWd+Zv8H+VqKpEyuC6ff+lzG7R
         X8gMWcDl3cl3KpOU/uxqcPgD0yYRQFELgAhDZrRY=
Date:   Wed, 18 Oct 2023 14:44:01 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        yuanhengzhang1214@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-fix-a-typo-in-a-comment.patch removed from -mm tree
Message-Id: <20231018214402.434E8C433D9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: fix a typo in a comment
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-a-typo-in-a-comment.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yuanheng Zhang <yuanhengzhang1214@gmail.com>
Subject: ocfs2: fix a typo in a comment
Date: Thu, 12 Oct 2023 00:32:16 +0800

Fix spelling typo in comment.

Link: https://lkml.kernel.org/r/20231011163216.29446-1-yuanhengzhang1214@gmail.com
Signed-off-by: Yuanheng Zhang <yuanhengzhang1214@gmail.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/buffer_head_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/buffer_head_io.c~ocfs2-fix-a-typo-in-a-comment
+++ a/fs/ocfs2/buffer_head_io.c
@@ -158,7 +158,7 @@ read_failure:
 			if (new_bh && bh) {
 				/* If middle bh fails, let previous bh
 				 * finish its read and then put it to
-				 * aovoid bh leak
+				 * avoid bh leak
 				 */
 				if (!buffer_jbd(bh))
 					wait_on_buffer(bh);
_

Patches currently in -mm which might be from yuanhengzhang1214@gmail.com are


