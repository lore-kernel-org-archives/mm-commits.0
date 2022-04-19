Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7025DC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 19 Apr 2022 18:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245431AbiDSSkI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Apr 2022 14:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357436AbiDSSkC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Apr 2022 14:40:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4FB13DDD0
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 11:36:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A58AAB818EE
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 18:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61562C385A5;
        Tue, 19 Apr 2022 18:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650393415;
        bh=2euHuxq+AFimsNDTnvdkBsCVxEzXzJ4dBT93zZGI8Jc=;
        h=Date:To:From:Subject:From;
        b=IywyXLMB/t03i5RDdxEQ0swYOsGokI0xAo0+AxfvaQJBett8/2B5PVwP5XJFMvy6s
         I4pQkZ8+2/pAcalBfeWjLX37Q5cXr8Yt7XAbSrLYwXLADA21otpGYFe1kivNcAW81Q
         f5QjlBblcFVReTeUGfEh3iDy9jkPg0P598LJDDEc=
Date:   Tue, 19 Apr 2022 11:36:54 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, dvyukov@google.com, andreyknvl@gmail.com,
        vincenzo.frascino@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-vincenzo-frascino-to-kasan-reviewers.patch added to -mm tree
Message-Id: <20220419183655.61562C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add Vincenzo Frascino to KASAN reviewers
has been added to the -mm tree.  Its filename is
     maintainers-add-vincenzo-frascino-to-kasan-reviewers.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-vincenzo-frascino-to-kasan-reviewers.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-vincenzo-frascino-to-kasan-reviewers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: MAINTAINERS: add Vincenzo Frascino to KASAN reviewers

Add my email address to KASAN reviewers list to make sure that I am Cc'ed
in all the KASAN changes that may affect arm64 MTE.

Link: https://lkml.kernel.org/r/20220419170640.21404-1-vincenzo.frascino@arm.com
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-vincenzo-frascino-to-kasan-reviewers
+++ a/MAINTAINERS
@@ -10549,6 +10549,7 @@ M:	Andrey Ryabinin <ryabinin.a.a@gmail.c
 R:	Alexander Potapenko <glider@google.com>
 R:	Andrey Konovalov <andreyknvl@gmail.com>
 R:	Dmitry Vyukov <dvyukov@google.com>
+R:	Vincenzo Frascino <vincenzo.frascino@arm.com>
 L:	kasan-dev@googlegroups.com
 S:	Maintained
 F:	Documentation/dev-tools/kasan.rst
_

Patches currently in -mm which might be from vincenzo.frascino@arm.com are

maintainers-add-vincenzo-frascino-to-kasan-reviewers.patch

