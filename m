Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2235C25B48
	for <mm-commits@archiver.kernel.org>; Thu, 26 Oct 2023 20:11:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbjJZULe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Oct 2023 16:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbjJZULd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Oct 2023 16:11:33 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BC21AC
        for <mm-commits@vger.kernel.org>; Thu, 26 Oct 2023 13:11:31 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E170CC433B7;
        Thu, 26 Oct 2023 20:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698351091;
        bh=EdkZedz770ua5EBXiuQ+OuX2UydwmkZqaAi1oh6LpZs=;
        h=Date:To:From:Subject:From;
        b=RdS8rxWxXxI4NB7iwkgJ8/6xZy6AwSqvukiZK4rFHXGZ68c75PD4dobOy4CQxt8sX
         3wFMwuVwb3imMX0p7vdHHOq7acD3GFtT6FGy7y02yjp/Dy2VJ3fl9PhVTs1fHA18ba
         +7aQvrU/c5kJVouDa2wA5tVmclBXnbDfZubcOclI=
Date:   Thu, 26 Oct 2023 13:11:29 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        yangqixiao@inspur.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-maple_tree-fix-word-spelling-error.patch added to mm-unstable branch
Message-Id: <20231026201130.E170CC433B7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: maple_tree: fix word spelling error
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-maple_tree-fix-word-spelling-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-maple_tree-fix-word-spelling-error.patch

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
From: Tom Yang <yangqixiao@inspur.com>
Subject: Documentation: maple_tree: fix word spelling error
Date: Mon, 23 Oct 2023 17:57:37 +0800

The "first" is spelled "fist".

Link: https://lkml.kernel.org/r/20231023095737.21823-1-yangqixiao@inspur.com
Signed-off-by: Tom Yang <yangqixiao@inspur.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/maple_tree.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/core-api/maple_tree.rst~documentation-maple_tree-fix-word-spelling-error
+++ a/Documentation/core-api/maple_tree.rst
@@ -175,7 +175,7 @@ will return the previous entry which occ
 mas_find() will find the first entry which exists at or above index on
 the first call, and the next entry from every subsequent calls.
 
-mas_find_rev() will find the fist entry which exists at or below the last on
+mas_find_rev() will find the first entry which exists at or below the last on
 the first call, and the previous entry from every subsequent calls.
 
 If the user needs to yield the lock during an operation, then the maple state
_

Patches currently in -mm which might be from yangqixiao@inspur.com are

documentation-maple_tree-fix-word-spelling-error.patch

