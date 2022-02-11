Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 621B0C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 11 Feb 2022 21:57:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344999AbiBKV5q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 16:57:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242801AbiBKV5q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 16:57:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1DEC6E
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 13:57:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49E3461155
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 21:57:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2E0C340E9;
        Fri, 11 Feb 2022 21:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644616663;
        bh=T2VeYyBxVSj5+CG7Nou7aH7quX7/k5Cm7m7v+lBstZc=;
        h=Date:To:From:Subject:From;
        b=IQu86FRpUFeuXZxbvJ6zK+X/XkPyklfbZb4JVthrIuFLu+a2gqpFGyNr1iVRev8Bs
         2/Sh/Dt1bVMPxagqNti1eE6b1fQZkCTgzDQtLHzv2X2T9uezAiYYJBT0rjIyoFpx/9
         e6VI1QC7SgNM5+W/foGrWHFuXi6ZEb87ygAgeDzc=
Date:   Fri, 11 Feb 2022 13:57:43 -0800
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + numa-balancing-optimize-page-placement-for-memory-tiering-system-fix-fix-fix.patch added to -mm tree
Message-Id: <20220211215743.9C2E0C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: numa-balancing-optimize-page-placement-for-memory-tiering-system-fix-fix-fix
has been added to the -mm tree.  Its filename is
     numa-balancing-optimize-page-placement-for-memory-tiering-system-fix-fix-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/numa-balancing-optimize-page-placement-for-memory-tiering-system-fix-fix-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/numa-balancing-optimize-page-placement-for-memory-tiering-system-fix-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: numa-balancing-optimize-page-placement-for-memory-tiering-system-fix-fix-fix

fix the following warnings of `make htmldocs`,

Documentation/admin-guide/sysctl/kernel.rst:603: WARNING: Inconsistent literal block quoting.

Link: https://lkml.kernel.org/r/87r18cjwbe.fsf@yhuang6-desk2.ccr.corp.intel.com
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/admin-guide/sysctl/kernel.rst~numa-balancing-optimize-page-placement-for-memory-tiering-system-fix-fix-fix
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -597,7 +597,7 @@ numa_balancing
 
 Enables/disables and configures automatic page fault based NUMA memory
 balancing.  Memory is moved automatically to nodes that access it often. 
-The value to set can be the result of ORing the following::
+The value to set can be the result of ORing the following:
 
 = =================================
 0 NUMA_BALANCING_DISABLED
_

Patches currently in -mm which might be from ying.huang@intel.com are

mmmigrate-fix-establishing-demotion-target.patch
numa-balancing-add-page-promotion-counter.patch
numa-balancing-optimize-page-placement-for-memory-tiering-system.patch
numa-balancing-optimize-page-placement-for-memory-tiering-system-fix-fix-fix.patch
memory-tiering-skip-to-scan-fast-memory.patch

