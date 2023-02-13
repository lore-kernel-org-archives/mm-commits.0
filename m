Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D467C636D4
	for <mm-commits@archiver.kernel.org>; Mon, 13 Feb 2023 18:06:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjBMSG1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Feb 2023 13:06:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjBMSG0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2023 13:06:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175C84C17
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 10:05:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6118BB80E8E
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 18:05:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE310C433A0;
        Mon, 13 Feb 2023 18:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676311501;
        bh=SvWeu4QUxsPm8bCvIcVPgdMpNsjvr6tRCEha+8E2Xwk=;
        h=Date:To:From:Subject:From;
        b=aNvjI9IPsV1X+ZkPzHiEXw8B1Qq7/pOlNLykDlY7vtNLW9HcVJ7xk3KZaNGb2jgkU
         XNhkMbEcMa9lPxCVnOWmZ05UzELgR90hBJqkn+8tVaKlArHNd+xnK9GFjF3rxQ07qb
         ngJp4jcvbDlsJ25bLrOEJCWpuV+niZ3tuSJ7SxcU=
Date:   Mon, 13 Feb 2023 10:05:00 -0800
To:     mm-commits@vger.kernel.org, glider@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-move-documentation-comments-to-stackdepoth-fix.patch added to mm-unstable branch
Message-Id: <20230213180500.EE310C433A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib-stackdepot-move-documentation-comments-to-stackdepoth-fix
has been added to the -mm mm-unstable branch.  Its filename is
     lib-stackdepot-move-documentation-comments-to-stackdepoth-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-move-documentation-comments-to-stackdepoth-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-stackdepot-move-documentation-comments-to-stackdepoth-fix
Date: Mon Feb 13 10:04:04 AM PST 2023

grammar fix, per Alexander

Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/stackdepot.h~lib-stackdepot-move-documentation-comments-to-stackdepoth-fix
+++ a/include/linux/stackdepot.h
@@ -11,7 +11,7 @@
  * SLUB_DEBUG needs 256 bytes per object for that). Since allocation and free
  * stack traces often repeat, using stack depot allows to save about 100x space.
  *
- * Stack traces are never removed from stack depot.
+ * Stack traces are never removed from the stack depot.
  *
  * Author: Alexander Potapenko <glider@google.com>
  * Copyright (C) 2016 Google, Inc.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch
lib-stackdepot-move-documentation-comments-to-stackdepoth-fix.patch

