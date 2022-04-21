Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CF2BC43217
	for <mm-commits@archiver.kernel.org>; Thu, 21 Apr 2022 23:36:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442594AbiDUXi7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Apr 2022 19:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442591AbiDUXi6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2022 19:38:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931C51260A
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 16:36:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4745EB829A7
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 23:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9B0C385A7;
        Thu, 21 Apr 2022 23:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650584165;
        bh=MzcMSe+kMEsRMZ4YRLUrtJdcODmvPwMv63+fwiOkfm4=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=Fm9Xl7FU3ieQ2fFOI6Rwf8+JMlYE3FSYgXzBgmYgizSwEUueeig/V0/W6u5jF+j9t
         Zd7wxPHbBcqKLvWybXT1KbdqzDqlcm3vaLsNAXEX//ONo7HsrQafXx8MM7rynAsUAJ
         kpIYvcSsI4eK7rBETIJt25icgCVMOKuUSS+G4TKo=
Date:   Thu, 21 Apr 2022 16:36:04 -0700
To:     ryabinin.a.a@gmail.com, glider@google.com, dvyukov@google.com,
        andreyknvl@gmail.com, vincenzo.frascino@arm.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220421163508.66028a9ac2d9fb6ea05b1342@linux-foundation.org>
Subject: [patch 11/13] MAINTAINERS: add Vincenzo Frascino to KASAN reviewers
Message-Id: <20220421233604.DB9B0C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
