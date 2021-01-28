Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59088C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 20:15:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1290D64E02
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 20:15:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhA1UPA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Jan 2021 15:15:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:34918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231213AbhA1UND (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 28 Jan 2021 15:13:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3836C64DFF;
        Thu, 28 Jan 2021 20:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611864743;
        bh=CduNRzKKPZ1a+r8UlXNXIeYzGqgAF68b+m+iUlG/BLw=;
        h=Date:From:To:Subject:From;
        b=oTyMfB0L9fa5TFLaC/av2lC75B39N9sr980u4mB1a6HWM7p0A0ziKG2aeo6JQYD6q
         TFvougNI+hSiJ4vPso4s3JREbcaWenbgwMC8rSW3sPnSiEnYmoNQZD7Ata6r7vzVED
         euNGeJOBdrGa/LhBpn1xqr9zqHouguWYbRr8jwqI=
Date:   Thu, 28 Jan 2021 12:12:22 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20210128201222.ePXYra-1m%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/soc/atmel/soc.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/soc/atmel/soc.c~linux-next-git-rejects
+++ a/drivers/soc/atmel/soc.c
@@ -358,10 +358,7 @@ static const struct of_device_id at91_so
 	{ .compatible = "atmel,at91sam9", },
 	{ .compatible = "atmel,sama5", },
 	{ .compatible = "atmel,samv7", },
-<<<<<<< HEAD
-=======
 	{ .compatible = "microchip,sama7g5", },
->>>>>>> linux-next/akpm-base
 	{ }
 };
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fix.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch
mm-memcg-add-swapcache-stat-for-memcg-v2-fix.patch
kasan-add-match-all-tag-tests-fix-fix.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
bdi-use-might_alloc-fix.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
lib-stackdepot-add-support-to-disable-stack-depot-fix.patch
initramfs-panic-with-memory-information-fix.patch
linux-next-rejects.patch
fs-ramfs-inodec-update-inode_operationstmpfile.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch

