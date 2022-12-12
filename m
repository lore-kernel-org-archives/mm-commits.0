Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F747C10F1D
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 03:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbiLLDbl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 22:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbiLLDb2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 22:31:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6984FDE90
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 19:31:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01A2E60EA4
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 03:31:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DED4C433F0;
        Mon, 12 Dec 2022 03:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670815879;
        bh=zjrmqPLhZaouyeURoqKWlImOZyR5dp5GhYyHTNJeHdY=;
        h=Date:To:From:Subject:From;
        b=z4Aztkha49/fPj6C1d6uxLkujFrQg8kdyKWf0hYnB2LS+bQ2Q4msBHB2RHx97uLaL
         rEuiyKFZxCoasEq/2eb2rC7QOxS8xpeEnfm16vf6s6sEhnoduUCFBargv+RoHguFUV
         SIzirSBDESYfZhpuqIXfO1ibtz16P7X4kb/8YgdE=
Date:   Sun, 11 Dec 2022 19:31:18 -0800
To:     mm-commits@vger.kernel.org, dvyukov@google.com,
        andreyknvl@gmail.com, rongtao@cestc.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kcov-fix-spelling-typos-in-comments.patch removed from -mm tree
Message-Id: <20221212033119.5DED4C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kcov: fix spelling typos in comments
has been removed from the -mm tree.  Its filename was
     kcov-fix-spelling-typos-in-comments.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rong Tao <rongtao@cestc.cn>
Subject: kcov: fix spelling typos in comments
Date: Sat, 3 Dec 2022 18:25:21 +0800

Fix the typo of 'suport' in kcov.h

Link: https://lkml.kernel.org/r/tencent_922CA94B789587D79FD154445D035AA19E07@qq.com
Signed-off-by: Rong Tao <rongtao@cestc.cn>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kcov.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/kcov.h~kcov-fix-spelling-typos-in-comments
+++ a/include/linux/kcov.h
@@ -56,7 +56,7 @@ static inline void kcov_remote_start_usb
 /*
  * The softirq flavor of kcov_remote_*() functions is introduced as a temporary
  * work around for kcov's lack of nested remote coverage sections support in
- * task context. Adding suport for nested sections is tracked in:
+ * task context. Adding support for nested sections is tracked in:
  * https://bugzilla.kernel.org/show_bug.cgi?id=210337
  */
 
_

Patches currently in -mm which might be from rongtao@cestc.cn are


