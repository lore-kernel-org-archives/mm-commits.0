Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9C65EE49B8
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:39:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbjHUUjb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbjHUUjV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:39:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC81130
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F19B6462E
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C515FC433C8;
        Mon, 21 Aug 2023 20:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650355;
        bh=WN1rB+SVW9pMxbgkylXod33ygQ8+rD2p4EZ8suin4UA=;
        h=Date:To:From:Subject:From;
        b=p4wa7ic3Fg83PzJAiyKsDlbLx2bobX+fHoeQ7luZw3MJ16UK5/vCkJ/w0Z/j5ITpI
         L3k11Ng+NeTZN3kKLf49TDUTk+BcisyjtoboGKYzrF7lnXkgJJ2RtSpU6V5WinRvVm
         D1JvpQsk9eK4s6o9KpcjJjuskU1AG/dZI/GFQyEg=
Date:   Mon, 21 Aug 2023 13:39:15 -0700
To:     mm-commits@vger.kernel.org, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_poison-remove-unused-page_exth-from-page_poison.patch removed from -mm tree
Message-Id: <20230821203915.C515FC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_poison: remove unused page_ext.h from page_poison
has been removed from the -mm tree.  Its filename was
     mm-page_poison-remove-unused-page_exth-from-page_poison.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/page_poison: remove unused page_ext.h from page_poison
Date: Mon, 17 Jul 2023 19:32:25 +0800

Patch series "minor cleanups to page_ext header".

No page_ext function or structure is used in page_poison.  Just remove
page_ext header from page_poison.

Link: https://lkml.kernel.org/r/20230717113227.1897173-1-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20230717113227.1897173-2-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_poison.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/page_poison.c~mm-page_poison-remove-unused-page_exth-from-page_poison
+++ a/mm/page_poison.c
@@ -4,7 +4,6 @@
 #include <linux/mm.h>
 #include <linux/mmdebug.h>
 #include <linux/highmem.h>
-#include <linux/page_ext.h>
 #include <linux/poison.h>
 #include <linux/ratelimit.h>
 #include <linux/kasan.h>
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


