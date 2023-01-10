Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BF5FC46467
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 23:15:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbjAJXP0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 18:15:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234454AbjAJXPX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 18:15:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E6D12AC8
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 15:15:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5906C61932
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 23:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84B9C433EF;
        Tue, 10 Jan 2023 23:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673392521;
        bh=YUo/vLpkeOdXEgBJ7Gb7tRdl/dP3lTjhPZ/UN83DYlQ=;
        h=Date:To:From:Subject:From;
        b=doAOvg3YH7xMwXr/77uaA1fb8CsxPUBE7iVf/cYkvLDz5gJMJzmfiS4mh1NKSOXLh
         j+t71guldKyp1+yb32QCRoyh+DHLzxpGBmZxsY37Y6UdrUokqk5RtBLu/FvG1q/hBB
         WuZYW8RQ7mMgVWl0hTrxpDsmDkptPrBH7SLFm99w=
Date:   Tue, 10 Jan 2023 15:15:20 -0800
To:     mm-commits@vger.kernel.org, liam.howlett@oracle.com,
        vernon2gm@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-fix-typo-in-comment.patch added to mm-unstable branch
Message-Id: <20230110231521.A84B9C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: fix typo in comment
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-fix-typo-in-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-fix-typo-in-comment.patch

This patch will later appear in the mm-unstable branch at
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
From: Vernon Yang <vernon2gm@gmail.com>
Subject: mm/mmap: fix typo in comment
Date: Tue, 10 Jan 2023 22:53:53 +0800

Replace "parital" with "partial".

Link: https://lkml.kernel.org/r/20230110145353.1658435-1-vernon2gm@gmail.com
Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap.c~mm-mmap-fix-typo-in-comment
+++ a/mm/mmap.c
@@ -2889,7 +2889,7 @@ out:
 }
 
 /*
- * brk_munmap() - Unmap a parital vma.
+ * brk_munmap() - Unmap a partial vma.
  * @mas: The maple tree state.
  * @vma: The vma to be modified
  * @newbrk: the start of the address to unmap
_

Patches currently in -mm which might be from vernon2gm@gmail.com are

maple_tree-remove-extra-space-and-blank-line.patch
maple_tree-remove-extra-return-statement.patch
maple_tree-use-mt_node_max-instead-of-direct-operations-mt_max.patch
maple_tree-use-macro-ma_root_parent-instead-of-number.patch
maple_tree-remove-the-redundant-code.patch
maple_tree-refine-ma_state-init-from-mas_start.patch
maple_tree-refine-mab_calc_split-function.patch
maple_tree-remove-the-parameter-entry-of-mas_preallocate.patch
mm-mmap-fix-typo-in-comment.patch

