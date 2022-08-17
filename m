Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95DB6C25B08
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 19:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241365AbiHQTKF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 15:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241362AbiHQTKE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 15:10:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB9B9AFB6
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 12:10:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CDDF6142E
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 19:10:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0679C433C1;
        Wed, 17 Aug 2022 19:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660763399;
        bh=Hhn98RZNoGNYrycm6x+OgInM7Ya+NQNHxz6Y/77xZqQ=;
        h=Date:To:From:Subject:From;
        b=VKTvBO1PcCcRX1rGQdqwnmfo9Kk41eRR7k8O+xm37js539rJHoDKdWY0ds+cBzyGf
         KCFJOn5M9kwndRC4n8GNDuZqnJ/rk7zAh87tXePrA6iYKAofjwNtOGtShVP7DVL8n6
         UYlzqoT+TD826EXfYUx3RUtLImr80T0byl5N+HbQ=
Date:   Wed, 17 Aug 2022 12:09:59 -0700
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn,
        quic_mojha@quicinc.com, cgel.zte@gmail.com, xu.panda@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-fix-a-typo-in-comment.patch added to mm-unstable branch
Message-Id: <20220817190959.D0679C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix a typo in comment
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-fix-a-typo-in-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-fix-a-typo-in-comment.patch

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
From: xupanda <xu.panda@zte.com.cn>
Subject: mm: memcontrol: fix a typo in comment
Date: Mon, 15 Aug 2022 06:51:04 +0000

Fix a spelling mistake in comment.

Link: https://lkml.kernel.org/r/20220815065102.74347-1-xu.panda@zte.com.cn
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: xupanda <xu.panda@zte.com.cn>
Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-fix-a-typo-in-comment
+++ a/mm/memcontrol.c
@@ -1143,7 +1143,7 @@ static void invalidate_reclaim_iterators
 	} while ((memcg = parent_mem_cgroup(memcg)));
 
 	/*
-	 * When cgruop1 non-hierarchy mode is used,
+	 * When cgroup1 non-hierarchy mode is used,
 	 * parent_mem_cgroup() does not walk all the way up to the
 	 * cgroup root (root_mem_cgroup). So we have to handle
 	 * dead_memcg from cgroup root separately.
_

Patches currently in -mm which might be from xu.panda@zte.com.cn are

mm-memcontrol-fix-a-typo-in-comment.patch

