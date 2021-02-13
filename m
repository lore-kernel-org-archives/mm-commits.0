Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11432C433DB
	for <mm-commits@archiver.kernel.org>; Sat, 13 Feb 2021 04:53:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C158C60C3E
	for <mm-commits@archiver.kernel.org>; Sat, 13 Feb 2021 04:53:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbhBMExa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 Feb 2021 23:53:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:50598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232134AbhBMEx2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 12 Feb 2021 23:53:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1583264E35;
        Sat, 13 Feb 2021 04:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613191968;
        bh=hMum9ZzmFG+hS95F4LDIX5T3p7yje4CIoI1AzjYlUs4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=e5Mhxn7wg9cpuexZnrcSg6aEBi9CRrOJZzGmxQXK40Wo6CXQ8a+Qj2rsXhyM7AQ2k
         oqxqABLcD6apuuUhABtcsCAIu8v6ePEooXI+KxDCvW1yLdbXPSv47pft/xr1gvQSlx
         5epF3DoRdrn0sFQmIAtY+/EDQfizDn347PtnJlVI=
Date:   Fri, 12 Feb 2021 20:52:47 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        dvyukov@google.com, elver@google.com, glider@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 4/6] MAINTAINERS: update Andrey Konovalov's email
 address
Message-ID: <20210213045247.B45Js3Qsg%akpm@linux-foundation.org>
In-Reply-To: <20210212205206.f99cbe2e7e368c802a385104@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: MAINTAINERS: update Andrey Konovalov's email address

Use my personal email address.

Link: https://lkml.kernel.org/r/b0ec98dabbc12336c162788f5ccde97045a0d65e.1613150186.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-update-andrey-konovalovs-email-address
+++ a/MAINTAINERS
@@ -9584,7 +9584,7 @@ F:	scripts/kconfig/
 
 KCOV
 R:	Dmitry Vyukov <dvyukov@google.com>
-R:	Andrey Konovalov <andreyknvl@google.com>
+R:	Andrey Konovalov <andreyknvl@gmail.com>
 L:	kasan-dev@googlegroups.com
 S:	Maintained
 F:	Documentation/dev-tools/kcov.rst
_
