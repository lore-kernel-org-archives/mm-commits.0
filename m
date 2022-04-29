Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 397E2C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 18:47:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbiD2SuX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 14:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232807AbiD2SuW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 14:50:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E13E8BE39
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 11:47:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C47AEB8376E
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 18:47:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A04C385A7;
        Fri, 29 Apr 2022 18:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651258021;
        bh=VHLU0hJ2MF5h+Bl6sbYO4IKW3FXZ5ZjiA3+rAE2mjIM=;
        h=Date:To:From:Subject:From;
        b=PABl3swueWf5hrEi3oqXHkCs7TVDM11loXCNNT2eDxnEzU0PIwq6vnbtTdalDfS1T
         rqxep9coEJza7UpdmvGKQujI7BBLJmf9kY6sTfyqJkZTrj+5ecWmGpCI4KAtYivDaG
         RwUhEotdLprlLlcx6vBvz2K7ps1Ge5eoCBYluH7w=
Date:   Fri, 29 Apr 2022 11:47:00 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, rientjes@google.com,
        yuanchu@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-damon-add-damon-to-selftests-root-makefile.patch removed from -mm tree
Message-Id: <20220429184701.71A04C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/damon: add damon to selftests root Makefile
has been removed from the -mm tree.  Its filename was
     selftests-damon-add-damon-to-selftests-root-makefile.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Yuanchu Xie <yuanchu@google.com>
Subject: selftests/damon: add damon to selftests root Makefile

Currently the damon selftests are not built with the rest of the
selftests.  We add damon to the list of targets.

Link: https://lkml.kernel.org/r/20220418202017.3583638-1-yuanchu@google.com
Fixes: b348eb7abd09 ("mm/damon: add user space selftests")
Signed-off-by: Yuanchu Xie <yuanchu@google.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/Makefile~selftests-damon-add-damon-to-selftests-root-makefile
+++ a/tools/testing/selftests/Makefile
@@ -9,6 +9,7 @@ TARGETS += clone3
 TARGETS += core
 TARGETS += cpufreq
 TARGETS += cpu-hotplug
+TARGETS += damon
 TARGETS += drivers/dma-buf
 TARGETS += efivarfs
 TARGETS += exec
_

Patches currently in -mm which might be from yuanchu@google.com are


