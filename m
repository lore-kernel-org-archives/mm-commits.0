Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01825C433DB
	for <mm-commits@archiver.kernel.org>; Sat, 13 Feb 2021 04:53:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B92F964DEC
	for <mm-commits@archiver.kernel.org>; Sat, 13 Feb 2021 04:53:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbhBMExh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 Feb 2021 23:53:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:50666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232134AbhBMExg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 12 Feb 2021 23:53:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FD9064E39;
        Sat, 13 Feb 2021 04:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613191971;
        bh=vuON6ycST+shrwdWNmlgxIjr6b3s05mu1r/OqNXwZmk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=t1SSwnTPbB5d0yIXCBrRqw3ErCMkg0V1lKiVNxA1sD/zGtlYqwa937x+yulcwDZww
         xmAjqCz3RQi0ah9kpQ3BiiqXnsLXwTG3LvVrsqlI2l2vYzCphfQHde9Ea0EtNsqBFv
         YOZ/P4clkWjz4BzGJkcGYCA5yM73vMSgaReSjpJA=
Date:   Fri, 12 Feb 2021 20:52:50 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        dvyukov@google.com, elver@google.com, glider@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 5/6] MAINTAINERS: add Andrey Konovalov to KASAN
 reviewers
Message-ID: <20210213045250.ChyFKKyEt%akpm@linux-foundation.org>
In-Reply-To: <20210212205206.f99cbe2e7e368c802a385104@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: MAINTAINERS: add Andrey Konovalov to KASAN reviewers

Add my personal email address to KASAN reviewers list.

Link: https://lkml.kernel.org/r/c1ce89a7aae0e2d6852249c280b1eb59aeac30c0.1613150186.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-andrey-konovalov-to-kasan-reviewers
+++ a/MAINTAINERS
@@ -9561,6 +9561,7 @@ F:	drivers/hwmon/k8temp.c
 KASAN
 M:	Andrey Ryabinin <ryabinin.a.a@gmail.com>
 R:	Alexander Potapenko <glider@google.com>
+R:	Andrey Konovalov <andreyknvl@gmail.com>
 R:	Dmitry Vyukov <dvyukov@google.com>
 L:	kasan-dev@googlegroups.com
 S:	Maintained
_
