Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E87EC25B48
	for <mm-commits@archiver.kernel.org>; Thu, 26 Oct 2023 15:22:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbjJZPWx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Oct 2023 11:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbjJZPWw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Oct 2023 11:22:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B868DD7
        for <mm-commits@vger.kernel.org>; Thu, 26 Oct 2023 08:22:50 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48CFAC433C7;
        Thu, 26 Oct 2023 15:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698333770;
        bh=eMAuVONG/nDxA5s17SnSQuc6u+SDofQ7KWgOBOgv14U=;
        h=Date:To:From:Subject:From;
        b=oDICbDl1+9mGPC07bRpMvo6a7ivc8eXhFtFL76dilcRJBpjDxm4Vr7V6FVVMfKIqK
         sd4Stk6vuCgLdbRk82QkrIZ6w2/JDgyPHDfMsWs/pcqSQ/XOyRlLPzUmDeAtmA4g6I
         nCoVFfjYTywR8HV5nTTaKfLdwYQeKVqohOQ/nJO8=
Date:   Thu, 26 Oct 2023 08:22:49 -0700
To:     mm-commits@vger.kernel.org, oleg@redhat.com,
        abaci@linux.alibaba.com, yang.lee@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-remove-unneeded-semicolon.patch added to mm-nonmm-unstable branch
Message-Id: <20231026152250.48CFAC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/base.c: remove unneeded semicolon
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-remove-unneeded-semicolon.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-remove-unneeded-semicolon.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

fs-remove-unneeded-semicolon.patch

