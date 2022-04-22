Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 982D7C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 22 Apr 2022 18:26:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbiDVS3E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Apr 2022 14:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233772AbiDVS20 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2022 14:28:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E75C7E93
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 11:25:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCB696181B
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 18:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B93CC385A0;
        Fri, 22 Apr 2022 18:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650651896;
        bh=dVtrEp8ekS0mEaqbt7hS3CArdLjSvYyYKU4joiYiWmY=;
        h=Date:To:From:Subject:From;
        b=bIzjp7/rarsbdZDxGtPBSizk38CJyJlumhL5nq88ygW++A+T5gjL+E2xIRzHnhuBX
         LBh1fq2Zb8DFmpDtywF8gKEND0xoY00rN9hiLfJFNOrQkEZddU2s/ENpLKfSMjjk24
         wJfUJycXpw7ozUfNK1kuVr3Sq+eNtu3R0ID1xOhk=
Date:   Fri, 22 Apr 2022 11:24:55 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, dvyukov@google.com, andreyknvl@gmail.com,
        vincenzo.frascino@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] maintainers-add-vincenzo-frascino-to-kasan-reviewers.patch removed from -mm tree
Message-Id: <20220422182456.3B93CC385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add Vincenzo Frascino to KASAN reviewers
has been removed from the -mm tree.  Its filename was
     maintainers-add-vincenzo-frascino-to-kasan-reviewers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


