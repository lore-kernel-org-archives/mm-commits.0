Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B9DFC25B48
	for <mm-commits@archiver.kernel.org>; Tue, 24 Oct 2023 15:54:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343648AbjJXPyo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 24 Oct 2023 11:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343525AbjJXPyn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Oct 2023 11:54:43 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897AF83
        for <mm-commits@vger.kernel.org>; Tue, 24 Oct 2023 08:54:41 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262A2C433C7;
        Tue, 24 Oct 2023 15:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698162881;
        bh=EKdx4UPe8rIOksJaY0/a7SPkLQltXFSyLP9b07jqLPU=;
        h=Date:To:From:Subject:From;
        b=05IZUsB+7ytr1naP5VQmxcQ8K2x5htM/CVkFeggEGz+trcBNZzXKvD5rcxUDOJ8jX
         pKg/O6xswGGRVq5qw9nkUPPqWqSyNjnfY7Rnob7rMooDjBDA7hx1YE3PP6UmUuo3KI
         Y/MF59UqI+L6dnyS0mNjoIUJlGWTPdkMuCwVKayQ=
Date:   Tue, 24 Oct 2023 08:54:40 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-ubsan-drop-the-from-article-title.patch added to mm-unstable branch
Message-Id: <20231024155441.262A2C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: ubsan: drop "the" from article title
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-ubsan-drop-the-from-article-title.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-ubsan-drop-the-from-article-title.patch

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
From: Andrey Konovalov <andreyknvl@google.com>
Subject: Documentation: ubsan: drop "the" from article title
Date: Tue, 24 Oct 2023 17:37:50 +0200

Drop "the" from the title of the documentation article for UBSAN, as it is
redundant.

Also add SPDX-License-Identifier for ubsan.rst.

Link: https://lkml.kernel.org/r/5fb11a4743eea9d9232a5284dea0716589088fec.1698161845.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/ubsan.rst |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/Documentation/dev-tools/ubsan.rst~documentation-ubsan-drop-the-from-article-title
+++ a/Documentation/dev-tools/ubsan.rst
@@ -1,5 +1,7 @@
-The Undefined Behavior Sanitizer - UBSAN
-========================================
+.. SPDX-License-Identifier: GPL-2.0
+
+Undefined Behavior Sanitizer - UBSAN
+====================================
 
 UBSAN is a runtime undefined behaviour checker.
 
_

Patches currently in -mm which might be from andreyknvl@google.com are

documentation-ubsan-drop-the-from-article-title.patch

