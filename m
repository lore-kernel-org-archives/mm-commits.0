Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 299E1C4167D
	for <mm-commits@archiver.kernel.org>; Wed,  1 Nov 2023 19:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347370AbjKATrj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Nov 2023 15:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347381AbjKATre (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Nov 2023 15:47:34 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5894D111
        for <mm-commits@vger.kernel.org>; Wed,  1 Nov 2023 12:47:27 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E746FC433CC;
        Wed,  1 Nov 2023 19:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698868047;
        bh=zjoI+G06LLhY6FyEDEjZsVZnmBnvu9SMQn2AxVF7kWc=;
        h=Date:To:From:Subject:From;
        b=JQC+6Z+8fMFu39BzbIfXApkml/vUWDl3kDANxLHKRWqdS1i2x+k4RNvLxbiFh02aY
         U4xZgqymWbJLkSmFOHHbtOvRPvzGKcb3jMsfQhZfzwgGmtnOXuRhOku990j2WrDAA3
         Q+WE52pnPiQY28jvVAzSapBgJ5PyGWh04HW8ZISQ=
Date:   Wed, 01 Nov 2023 12:47:26 -0700
To:     mm-commits@vger.kernel.org, oleg@redhat.com,
        abaci@linux.alibaba.com, yang.lee@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-remove-unneeded-semicolon.patch removed from -mm tree
Message-Id: <20231101194726.E746FC433CC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs/proc/base.c: remove unneeded semicolon
has been removed from the -mm tree.  Its filename was
     fs-remove-unneeded-semicolon.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: fs/proc/base.c: remove unneeded semicolon
Date: Thu, 26 Oct 2023 08:56:34 +0800

./fs/proc/base.c:3829:2-3: Unneeded semicolon

Link: https://lkml.kernel.org/r/20231026005634.6581-1-yang.lee@linux.alibaba.com
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=7057
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/base.c~fs-remove-unneeded-semicolon
+++ a/fs/proc/base.c
@@ -3826,7 +3826,7 @@ static struct task_struct *first_tid(str
 	for_each_thread(task, pos) {
 		if (!nr--)
 			goto found;
-	};
+	}
 fail:
 	pos = NULL;
 	goto out;
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are


