Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE817C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377805AbiATVXD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:23:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377803AbiATVXC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:23:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2646C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:23:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4388561892
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97AEDC340E0;
        Thu, 20 Jan 2022 21:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713781;
        bh=zHWLIL2nN9vN963ZfrQruTYFeBp/9UGn0IwAXkTdOos=;
        h=Date:From:To:Subject:From;
        b=ewUS2eTEftX9GQVtAIfISzBX9QsSO8T/HWnp9r3KZ4ZAIuzUK2+5fzkgWUKh+uFYF
         u9wksdHe3H0x6kkUSVo8/hx5R8icO7oRl21cNXpqyXETk/q8zdI3d+x1aH9aq7Dtb3
         chCO9qDVzVHfyI7bWK7D6wHlUDYYQqLRs7nPDckA=
Date:   Thu, 20 Jan 2022 13:23:01 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wangborong@cdjrlc.com
Subject:  [merged] ia64-fix-typo-in-a-comment.patch removed from
 -mm tree
Message-ID: <20220120212301.HQAQp-1i9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: fix typo in a comment
has been removed from the -mm tree.  Its filename was
     ia64-fix-typo-in-a-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jason Wang <wangborong@cdjrlc.com>
Subject: ia64: fix typo in a comment

The double `the' in a comment is repeated, thus it should be removed.

Link: https://lkml.kernel.org/r/20211113030316.22650-1-wangborong@cdjrlc.com
Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/uncached.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/ia64/kernel/uncached.c~ia64-fix-typo-in-a-comment
+++ a/arch/ia64/kernel/uncached.c
@@ -171,7 +171,7 @@ failed:
  * @n_pages: number of contiguous pages to allocate
  *
  * Allocate the specified number of contiguous uncached pages on the
- * the requested node. If not enough contiguous uncached pages are available
+ * requested node. If not enough contiguous uncached pages are available
  * on the requested node, roundrobin starting with the next higher node.
  */
 unsigned long uncached_alloc_page(int starting_nid, int n_pages)
_

Patches currently in -mm which might be from wangborong@cdjrlc.com are


