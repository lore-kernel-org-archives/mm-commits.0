Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B800C4167B
	for <mm-commits@archiver.kernel.org>; Wed,  1 Nov 2023 19:39:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345944AbjKATjS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Nov 2023 15:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345929AbjKATjM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Nov 2023 15:39:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20198119
        for <mm-commits@vger.kernel.org>; Wed,  1 Nov 2023 12:39:07 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B576EC433AD;
        Wed,  1 Nov 2023 19:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698867546;
        bh=aS012g/2L1vnepcca7n2Gh2o9tYR6+rvX8tb5NF3U/Y=;
        h=Date:To:From:Subject:From;
        b=aykOZPBGCSWqxS1Oap2FKgFz5vz9iMZOydIke1kliu+ZtIDqMcbgQM3vg6JzLBlVX
         KscUOjwcmy80f/45q/wctaKKQCzwatF5U3MOR9/EQ6RiKnB3+MUfWEXSPwujU1fte8
         Rwh974rvyn3QITboIlPDkhEW3iwVk+aWY8RKVW9I=
Date:   Wed, 01 Nov 2023 12:39:04 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        yangqixiao@inspur.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-maple_tree-fix-word-spelling-error.patch removed from -mm tree
Message-Id: <20231101193906.B576EC433AD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Documentation: maple_tree: fix word spelling error
has been removed from the -mm tree.  Its filename was
     documentation-maple_tree-fix-word-spelling-error.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


