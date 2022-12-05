Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57366C47089
	for <mm-commits@archiver.kernel.org>; Mon,  5 Dec 2022 21:09:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbiLEVJB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Dec 2022 16:09:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233484AbiLEVIn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Dec 2022 16:08:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0322D2AE38
        for <mm-commits@vger.kernel.org>; Mon,  5 Dec 2022 13:08:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2B0DB8122C
        for <mm-commits@vger.kernel.org>; Mon,  5 Dec 2022 21:08:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC6CC433C1;
        Mon,  5 Dec 2022 21:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670274511;
        bh=fTaUhdXJIhlZA3ZkevfsCwfMnx+gD9K2iXsnzrhkgGI=;
        h=Date:To:From:Subject:From;
        b=UnSwu4CWcz1Lu7MWOANGhn7mh3QDBWyAtZibSQBNfBLAovWnvXTfmqTJvlHc1JMhS
         kQNm4e81xEofg+oeai3TDTdnBv705lciYzvclJ6bORNhTUTAniVf9Rr7n7o3OcvFY2
         O6DsY8iVdymC5OX7F57dTy44XX+6tR4l3Q5otUtw=
Date:   Mon, 05 Dec 2022 13:08:30 -0800
To:     mm-commits@vger.kernel.org, dvyukov@google.com,
        andreyknvl@gmail.com, rongtao@cestc.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kcov-fix-spelling-typos-in-comments.patch added to mm-nonmm-unstable branch
Message-Id: <20221205210831.3CC6CC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: fix spelling typos in comments
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kcov-fix-spelling-typos-in-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kcov-fix-spelling-typos-in-comments.patch

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

kcov-fix-spelling-typos-in-comments.patch

