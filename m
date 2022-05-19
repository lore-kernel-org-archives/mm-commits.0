Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CB28C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 21:01:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244480AbiESVBA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 17:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244972AbiESVAw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 17:00:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BC5563FC
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 14:00:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE84C61CEE
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 21:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BC7C385B8;
        Thu, 19 May 2022 21:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652994046;
        bh=Son0hr6vENzqYSxt8qpbPTxvLu4fsXezcFRDZ2IJUME=;
        h=Date:To:From:Subject:From;
        b=YSZYkZ2z/FXG+hQuW1tHyxtXYbxyHf5W1TGaY9kA11pGlnODy9GYZBRC/zOUG90If
         6YNpWSsy4SvxAMDbU5n3ZLIgEW96QUU94X42EQJEfB4bmZlRFVyZLMPi1sTRNp6SpJ
         VAoYhbVhLti5i9wBaOM17hgwU4lf6uGbx2+e02R8=
Date:   Thu, 19 May 2022 14:00:45 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] documentation-filesystems-proc-update-meminfo-section-fix-2.patch removed from -mm tree
Message-Id: <20220519210046.08BC7C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Re: Documentation: filesystems: proc: update meminfo section
has been removed from the -mm tree.  Its filename was
     documentation-filesystems-proc-update-meminfo-section-fix-2.patch

This patch was dropped because it was folded into documentation-filesystems-proc-update-meminfo-section.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: Documentation: filesystems: proc: update meminfo section

change `Unevictable' wording, per David

Link: https://lkml.kernel.org/r/YnwFraZlVWQoCjz3@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/filesystems/proc.rst~documentation-filesystems-proc-update-meminfo-section-fix-2
+++ a/Documentation/filesystems/proc.rst
@@ -1035,8 +1035,8 @@ Inactive
               Memory which has been less recently used.  It is more
               eligible to be reclaimed for other purposes
 Unevictable
-              Memory that cannot be reclaimed, such as mlocked pages,
-              ramfs backing pages, secret memfd pages etc.
+              Memory allocated for userspace which cannot be reclaimed, such
+              as mlocked pages, ramfs backing pages, secret memfd pages etc.
 Mlocked
               Memory locked with mlock().
 HighTotal, HighFree
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

documentation-filesystems-proc-update-meminfo-section.patch
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

