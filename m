Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9008DC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 21:00:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234662AbiESVAs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 17:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244745AbiESVAr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 17:00:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22F6C75
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 14:00:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F82761D09
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 21:00:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94D4C385B8;
        Thu, 19 May 2022 21:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652994044;
        bh=voTF0kOF0/FMjr3Y2+lLm0TaRBP/AFDqojGDvqY96Sk=;
        h=Date:To:From:Subject:From;
        b=DstUNa1fcMnw9TNVDCKaxmNLP/Ee1ZtQ22DpVhXv0z7S0SjR9Zgn4v8WHBH7MuTJv
         0uSKtS8Q8X/wyQUxVN0v9w+ch2cwGXWHM0KhN8UokVgepf1Qn2G8gW0H9FDaxVaqhy
         w7Nve6X/IWeU4MXYkpLi9kAc5eyNpU5MHwLZcWNw=
Date:   Thu, 19 May 2022 14:00:44 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] documentation-filesystems-proc-update-meminfo-section-fix.patch removed from -mm tree
Message-Id: <20220519210044.D94D4C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: documentation-filesystems-proc-update-meminfo-section-fix
has been removed from the -mm tree.  Its filename was
     documentation-filesystems-proc-update-meminfo-section-fix.patch

This patch was dropped because it was folded into documentation-filesystems-proc-update-meminfo-section.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: documentation-filesystems-proc-update-meminfo-section-fix

fix htmldocs warnings

Link: https://lkml.kernel.org/r/Ynve8dg4zJyhH2gW@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/Documentation/filesystems/proc.rst~documentation-filesystems-proc-update-meminfo-section-fix
+++ a/Documentation/filesystems/proc.rst
@@ -1146,16 +1146,9 @@ CmaTotal
               Memory reserved for the Contiguous Memory Allocator (CMA)
 CmaFree
               Free remaining memory in the CMA reserves
-HugePages_Total
-HugePages_Free
-HugePages_Rsvd
-HugePages_Surp
-Hugepagesize
-Hugetlb
+HugePages_Total, HugePages_Free, HugePages_Rsvd, HugePages_Surp, Hugepagesize, Hugetlb
               See Documentation/admin-guide/mm/hugetlbpage.rst.
-DirectMap4k
-DirectMap2M
-DirectMap1G
+DirectMap4k, DirectMap2M, DirectMap1G
               Breakdown of page table sizes used in the kernel's
               identity mapping of RAM
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

documentation-filesystems-proc-update-meminfo-section.patch
documentation-filesystems-proc-update-meminfo-section-fix-2.patch
mm-kconfig-move-swap-and-slab-config-options-to-the-mm-section.patch
mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus.patch
mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus-fix.patch
mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus-fix-fix.patch
mm-kconfig-simplify-zswap-configuration.patch
mm-zswap-add-basic-meminfo-and-vmstat-coverage.patch
zswap-memcg-accounting.patch
zswap-memcg-accounting-fix.patch
zswap-memcg-accounting-fix-2.patch
revert-mm-vmscan-never-demote-for-memcg-reclaim.patch

