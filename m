Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 181F7C19F2D
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239832AbiG3BJn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239744AbiG3BI5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C9782FA1
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8AF7619EE
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1770FC433D7;
        Sat, 30 Jul 2022 01:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143334;
        bh=cMjyajn+o7ObWEvj2CkkPZP9x5O0OkzCt9WPjvqS+eU=;
        h=Date:To:From:Subject:From;
        b=qH8nJEU2uXQ0zjfcMo045zo3HmNdjIcEOnBejSMkzuJR5REnVDM2OBoPhIuI2UXm0
         E0FtX9JNxQFjLdLGBLYRYD7CuCrnSLF18FO+pTMyxKM0purYQf3lcgHReA0gxE6dF8
         A76f4qMhdg4CNS65CUrWkAH4qdRUadGCIo7Rk49M=
Date:   Fri, 29 Jul 2022 18:08:53 -0700
To:     mm-commits@vger.kernel.org, sophia.gabriellla@outlook.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kconfig-fix-typo.patch removed from -mm tree
Message-Id: <20220730010854.1770FC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: Kconfig: fix typo
has been removed from the -mm tree.  Its filename was
     mm-kconfig-fix-typo.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sophia Gabriella <sophia.gabriellla@outlook.com>
Subject: mm: Kconfig: fix typo
Date: Thu, 28 Jul 2022 16:51:39 +0000

Fixes a typo in the help section for ZSWAP.

Link: https://lkml.kernel.org/r/Message-ID:
Signed-off-by: Sophia Gabriella <sophia.gabriellla@outlook.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/Kconfig~mm-kconfig-fix-typo
+++ a/mm/Kconfig
@@ -33,7 +33,7 @@ config ZSWAP
 	  pages that are in the process of being swapped out and attempts to
 	  compress them into a dynamically allocated RAM-based memory pool.
 	  This can result in a significant I/O reduction on swap device and,
-	  in the case where decompressing from RAM is faster that swap device
+	  in the case where decompressing from RAM is faster than swap device
 	  reads, can also improve workload performance.
 
 	  This is marked experimental because it is a new feature (as of
_

Patches currently in -mm which might be from sophia.gabriellla@outlook.com are


