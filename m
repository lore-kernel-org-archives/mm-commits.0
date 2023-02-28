Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D05C7C64EC4
	for <mm-commits@archiver.kernel.org>; Tue, 28 Feb 2023 21:02:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjB1VC3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Feb 2023 16:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjB1VC2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2023 16:02:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F3F2311B
        for <mm-commits@vger.kernel.org>; Tue, 28 Feb 2023 13:02:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D49A611CE
        for <mm-commits@vger.kernel.org>; Tue, 28 Feb 2023 21:02:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A9EC433D2;
        Tue, 28 Feb 2023 21:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677618146;
        bh=crzQgeADbJY4mdhXF8VLSnC+sAXBQtrfTk6a/gOhbYM=;
        h=Date:To:From:Subject:From;
        b=I1l4I7J6blPYyPK9bbLb2loJWdVqdxZsymNRYSxbEXtX9nEgsZ7E7I5HbNFgM/jrJ
         9UYYG6dhBaiS2ELORTwPwjFE8uI2aQKnM5LC5ESf02pFEyJA+aadB1PeDaqGj/nXTb
         qHJ+sbUT4lxLQ0aSPZXfrtYBJtiMsQq9goTnkLww=
Date:   Tue, 28 Feb 2023 13:02:25 -0800
To:     mm-commits@vger.kernel.org, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kcov-improve-documentation-v2.patch added to mm-nonmm-unstable branch
Message-Id: <20230228210226.77A9EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kcov-improve-documentation-v2
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kcov-improve-documentation-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kcov-improve-documentation-v2.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
kcov-improve-documentation-v2.patch

