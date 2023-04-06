Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23EC5C7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:50:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234995AbjDFCuk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234923AbjDFCuU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:50:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF83A25D
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:49:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A55E62CBA
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB657C433EF;
        Thu,  6 Apr 2023 02:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749358;
        bh=jhZV4+v+2oRoZ0JIRqUsc+ZyloLHIsZAMA5rc355YJM=;
        h=Date:To:From:Subject:From;
        b=OhLp4UYnDkF4iyW9c90CQmpVeRSpVrs6/5i1bHaw+kbqR3+ib+v6/TNJW0/E7hOrD
         s0q4MSLexhY/Cb/6A9S9rNL3W6LKiinTJCh7/mDBz1/ZCWW/q62iWTt74sKUJuGkH+
         ryeKh9D+mEMPpVTf8Sp9TGKLGCUSAaL3N5xPNJGM=
Date:   Wed, 05 Apr 2023 19:49:17 -0700
To:     mm-commits@vger.kernel.org, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kcov-improve-documentation-v2.patch removed from -mm tree
Message-Id: <20230406024917.EB657C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kcov-improve-documentation-v2
has been removed from the -mm tree.  Its filename was
     kcov-improve-documentation-v2.patch

This patch was dropped because it was folded into kcov-improve-documentation.patch

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kcov-improve-documentation-v2
Date: Tue, 28 Feb 2023 21:04:15 +0100

Link: https://lkml.kernel.org/r/583f41c49eef15210fa813e8229730d11427efa7.1677614637.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kcov.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/dev-tools/kcov.rst~kcov-improve-documentation-v2
+++ a/Documentation/dev-tools/kcov.rst
@@ -26,7 +26,7 @@ Prerequisites
 KCOV relies on compiler instrumentation and requires GCC 6.1.0 or later
 or any Clang version supported by the kernel.
 
-Collecting comparison operands is only supported with Clang.
+Collecting comparison operands is supported with GCC 8+ or with Clang.
 
 To enable KCOV, configure the kernel with::
 
_

Patches currently in -mm which might be from andreyknvl@google.com are

kcov-improve-documentation.patch
kcov-improve-documentation-v3.patch

