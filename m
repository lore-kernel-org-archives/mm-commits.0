Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D59D0C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:28:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiKIB2t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiKIB2s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:28:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE52E19033
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:28:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89C8A617E2
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E193BC433D7;
        Wed,  9 Nov 2022 01:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957327;
        bh=gC9qiq63DrqX5yhPZ9r5y7BK3eHUeBSLUFKPdqAHXVQ=;
        h=Date:To:From:Subject:From;
        b=YhpwoDCq3Xsw+yOZVnwoOfIjwdDdcYVPb+Z/0gD+2ILB6I3PHLayY67Qc9mfuA9Qs
         xjaAtH3W3GubPLV3WPs4hWXb0Yl0NtdRWllEP2jxqq/iuWufXCYHTMWBCw68lZdu9d
         /PmWptaKpUMC2Gqwp+KAScQOlcSk27djB6ZSML64=
Date:   Tue, 08 Nov 2022 17:28:46 -0800
To:     mm-commits@vger.kernel.org, david@redhat.com,
        abaci@linux.alibaba.com, yang.lee@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-gup_test-start-stop-read-functionality-for-pin-longterm-test-fix-2.patch removed from -mm tree
Message-Id: <20221109012846.E193BC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: gup_test: remove unneeded semicolon
has been removed from the -mm tree.  Its filename was
     mm-gup_test-start-stop-read-functionality-for-pin-longterm-test-fix-2.patch

This patch was dropped because it was folded into mm-gup_test-start-stop-read-functionality-for-pin-longterm-test.patch

------------------------------------------------------
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: mm: gup_test: remove unneeded semicolon
Date: Thu, 20 Oct 2022 10:40:35 +0800

./mm/gup_test.c:281:2-3: Unneeded semicolon

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2455
Link: https://lkml.kernel.org/r/20221020024035.113619-1-yang.lee@linux.alibaba.com
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup_test.c~mm-gup_test-start-stop-read-functionality-for-pin-longterm-test-fix-2
+++ a/mm/gup_test.c
@@ -278,7 +278,7 @@ static inline int pin_longterm_test_star
 		}
 		pin_longterm_test_nr_pages += cur_pages;
 		pages += cur_pages;
-	};
+	}
 
 	if (!fast)
 		mmap_read_unlock(current->mm);
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are

mm-gup_test-start-stop-read-functionality-for-pin-longterm-test.patch

