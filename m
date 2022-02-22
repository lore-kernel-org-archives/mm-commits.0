Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 999AFC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 02:36:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239263AbiBVChR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 21:37:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239255AbiBVChQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 21:37:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B905425C6B
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 18:36:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 555DA614FD
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 02:36:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D87C340E9;
        Tue, 22 Feb 2022 02:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645497410;
        bh=s/5BPAj0bomfN42A/MOyKIlImCJrJ418zey6TJ3dZAg=;
        h=Date:To:From:Subject:From;
        b=pVXYAqIf1m54+3D+uPyirwhE97L2UwI9vEfYjYQ1GlZAD7t/WLpWyDvX8jMiKouMP
         UZa4zmPRdRtgRvOHZ7VpbiprneEJpgdy9aozYpSqnzdhBmhPqjmWAPAaf7XVw2KSoz
         t0R4Rr/f4v5F22foki1f1narODzSG2hk6YiPR6LE=
Date:   Mon, 21 Feb 2022 18:36:50 -0800
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] numa-balancing-optimize-page-placement-for-memory-tiering-system-fix-fix-fix.patch removed from -mm tree
Message-Id: <20220222023650.A7D87C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: numa-balancing-optimize-page-placement-for-memory-tiering-system-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     numa-balancing-optimize-page-placement-for-memory-tiering-system-fix-fix-fix.patch

This patch was dropped because it was folded into numa-balancing-optimize-page-placement-for-memory-tiering-system.patch

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: numa-balancing-optimize-page-placement-for-memory-tiering-system-fix-fix-fix

fix the following warnings of `make htmldocs`,

Documentation/admin-guide/sysctl/kernel.rst:603: WARNING: Inconsistent literal block quoting.

Link: https://lkml.kernel.org/r/87r18cjwbe.fsf@yhuang6-desk2.ccr.corp.intel.com
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
memory-tiering-skip-to-scan-fast-memory.patch

