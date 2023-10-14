Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F6DECDB465
	for <mm-commits@archiver.kernel.org>; Sat, 14 Oct 2023 23:13:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjJNXNb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Oct 2023 19:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjJNXNb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 Oct 2023 19:13:31 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEF6B7
        for <mm-commits@vger.kernel.org>; Sat, 14 Oct 2023 16:13:29 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A184DC433C7;
        Sat, 14 Oct 2023 23:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697325209;
        bh=TZzZjc2tkgDVUz61OhqgiPo5EBNJqeWn9awG8nFtm4c=;
        h=Date:To:From:Subject:From;
        b=ip/EIYWUrUFTPsIRUSAVBzX/IuFIZgfrzrELT9lR7+hTqyjhKE683PxC0MeEVK8J0
         pIMWlljN8522Iadu7JClDBInhtGY/cFVbWeY3IVl/5aLBGNuxU5rs7aa+zfItbY1Lo
         i+wFHIA3TA538QXoBHaLcqbgeNT4YDGgJyCKI7Kw=
Date:   Sat, 14 Oct 2023 16:13:26 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        yuanhengzhang1214@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-a-typo-in-a-comment.patch added to mm-nonmm-unstable branch
Message-Id: <20231014231328.A184DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix a typo in a comment
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-a-typo-in-a-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-a-typo-in-a-comment.patch

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

ocfs2-fix-a-typo-in-a-comment.patch

