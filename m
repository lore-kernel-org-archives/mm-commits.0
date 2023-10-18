Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6378ACDB483
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:36:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235356AbjJRVg6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235267AbjJRVgG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431A4191
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:38 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD9BC116AA;
        Wed, 18 Oct 2023 21:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664928;
        bh=UIBusxFO80B/bFG9vU5qlMifE4C0rdj5Uk3etfGFgmQ=;
        h=Date:To:From:Subject:From;
        b=ODJD83lMwCFwLzscZwVwMaOBqfF9lc3US9/k+U/TQqmPCtMR8lYbePmSYTaPPaDzy
         YNRrA4hNuIO2aOc22ARrPjMxhN2WPpaCER+R8hG8D0rWU7VvqKFSGQPeRYXq9vwOmk
         1f++RviNaYf2nbO5agP9p//xsyDSra7gZV+EaA9k=
Date:   Wed, 18 Oct 2023 14:35:27 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, lkp@intel.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-san-drop-the-from-article-titles.patch removed from -mm tree
Message-Id: <20231018213528.7BD9BC116AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Documentation: *san: drop "the" from article titles
has been removed from the -mm tree.  Its filename was
     documentation-san-drop-the-from-article-titles.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: Documentation: *san: drop "the" from article titles
Date: Fri, 6 Oct 2023 17:18:46 +0200

Drop "the" from the titles of documentation articles for KASAN, KCSAN,
and KMSAN, as it is redundant.

Also add SPDX-License-Identifier for kasan.rst.

Link: https://lkml.kernel.org/r/1c4eb354a3a7b8ab56bf0c2fc6157c22050793ca.1696605143.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |    7 +++++--
 Documentation/dev-tools/kcsan.rst |    4 ++--
 Documentation/dev-tools/kmsan.rst |    6 +++---
 3 files changed, 10 insertions(+), 7 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~documentation-san-drop-the-from-article-titles
+++ a/Documentation/dev-tools/kasan.rst
@@ -1,5 +1,8 @@
-The Kernel Address Sanitizer (KASAN)
-====================================
+.. SPDX-License-Identifier: GPL-2.0
+.. Copyright (C) 2023, Google LLC.
+
+Kernel Address Sanitizer (KASAN)
+================================
 
 Overview
 --------
--- a/Documentation/dev-tools/kcsan.rst~documentation-san-drop-the-from-article-titles
+++ a/Documentation/dev-tools/kcsan.rst
@@ -1,8 +1,8 @@
 .. SPDX-License-Identifier: GPL-2.0
 .. Copyright (C) 2019, Google LLC.
 
-The Kernel Concurrency Sanitizer (KCSAN)
-========================================
+Kernel Concurrency Sanitizer (KCSAN)
+====================================
 
 The Kernel Concurrency Sanitizer (KCSAN) is a dynamic race detector, which
 relies on compile-time instrumentation, and uses a watchpoint-based sampling
--- a/Documentation/dev-tools/kmsan.rst~documentation-san-drop-the-from-article-titles
+++ a/Documentation/dev-tools/kmsan.rst
@@ -1,9 +1,9 @@
 .. SPDX-License-Identifier: GPL-2.0
 .. Copyright (C) 2022, Google LLC.
 
-===================================
-The Kernel Memory Sanitizer (KMSAN)
-===================================
+===============================
+Kernel Memory Sanitizer (KMSAN)
+===============================
 
 KMSAN is a dynamic error detector aimed at finding uses of uninitialized
 values. It is based on compiler instrumentation, and is quite similar to the
_

Patches currently in -mm which might be from andreyknvl@google.com are


