Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2E2EC63797
	for <mm-commits@archiver.kernel.org>; Thu, 12 Jan 2023 00:15:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235509AbjALAPf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Jan 2023 19:15:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235452AbjALAPa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2023 19:15:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E8BD111
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 16:15:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D756661781
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 00:15:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D26C433D2;
        Thu, 12 Jan 2023 00:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673482520;
        bh=FGRiLOnEex+awHk3yH3SJvwzIVs6/IV2o2XY38sW8Hg=;
        h=Date:To:From:Subject:From;
        b=AXVPKhoFtOxaKWEZVNlk7vsmgH2C7mgyOJIDD4HWLaU6ax4nyl5bIC/grPCUQYMRs
         i8ekII4CxoByx6kfWHjiVCOPqKrDlKsuaMyG3cxAIUwCbc4SLBiDWtEGMVaV+Je0uz
         9sMjhwxWagj32wG2XcQnvoMJJLDdJEu6of+x6ou4=
Date:   Wed, 11 Jan 2023 16:15:19 -0800
To:     mm-commits@vger.kernel.org, ncardwell@google.com,
        edumazet@google.com, davem@davemloft.net, rdunlap@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-win_minmax-use-notation-for-regular-comments.patch removed from -mm tree
Message-Id: <20230112001520.30D26C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/win_minmax: use /* notation for regular comments
has been removed from the -mm tree.  Its filename was
     lib-win_minmax-use-notation-for-regular-comments.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib/win_minmax: use /* notation for regular comments
Date: Mon, 2 Jan 2023 13:16:14 -0800

Don't use kernel-doc "/**" notation for non-kernel-doc comments.
Prevents a kernel-doc warning:

lib/win_minmax.c:31: warning: expecting prototype for lib/minmax.c(). Prototype was for minmax_subwin_update() instead

Link: https://lkml.kernel.org/r/20230102211614.26343-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/win_minmax.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/win_minmax.c~lib-win_minmax-use-notation-for-regular-comments
+++ a/lib/win_minmax.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/**
+/*
  * lib/minmax.c: windowed min/max tracker
  *
  * Kathleen Nichols' algorithm for tracking the minimum (or maximum)
_

Patches currently in -mm which might be from rdunlap@infradead.org are

freevxfs-fix-kernel-doc-warnings.patch
ntfs-fix-multiple-kernel-doc-warnings.patch
userns-fix-a-structs-kernel-doc-notation.patch

