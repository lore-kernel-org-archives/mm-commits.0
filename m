Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3EC7C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  1 Nov 2023 19:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345925AbjKATjL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Nov 2023 15:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345926AbjKATjK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Nov 2023 15:39:10 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D1D10F
        for <mm-commits@vger.kernel.org>; Wed,  1 Nov 2023 12:39:04 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBBDC43391;
        Wed,  1 Nov 2023 19:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698867543;
        bh=mruai9s+EBcVWEglcSq6GKcx23+heDS72Hm9wnWWcKQ=;
        h=Date:To:From:Subject:From;
        b=qfuDEFXjJb/oPejYQb0E6w8gImZuGyppkSOk4ysNObJt0lipBSDeKcsNYNcctHpRw
         9CTwvbvnCsDnIsuTT1ud7KzesUs6C35RbHaHaXdVsAN/q9hUDSRZ3GmFcDdKznf67k
         PWcRkN/oqTjJ2kQ6+/Mag6r79qPqmgS9LzxNsJOc=
Date:   Wed, 01 Nov 2023 12:39:01 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-ubsan-drop-the-from-article-title.patch removed from -mm tree
Message-Id: <20231101193903.AFBBDC43391@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Documentation: ubsan: drop "the" from article title
has been removed from the -mm tree.  Its filename was
     documentation-ubsan-drop-the-from-article-title.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


