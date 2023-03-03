Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A367EC678D4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 02:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjCCCTO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Mar 2023 21:19:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjCCCTO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Mar 2023 21:19:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22345199CB
        for <mm-commits@vger.kernel.org>; Thu,  2 Mar 2023 18:19:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEBC861707
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 02:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE920C433EF;
        Fri,  3 Mar 2023 02:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677809952;
        bh=Rd2qiAR6fRbnVa/RHNy0QGLA5vZ+9v7WePScCz5oHA0=;
        h=Date:To:From:Subject:From;
        b=W8eWwXTwNm/MGaIgTX7H6dXyL+I33Lg+haf+owXt9PvqyskbV0pA2FVNxCdkOX50C
         dHcyyWmcmad7uXouB6k94w8yfPte2Ii46TK8k4Wot7r+nsaaDhMaiuLE2jzdoWp6Jn
         t9Td/LSzIMb8gYjc8MZOHW9a4seOV+HC7r86woy0=
Date:   Thu, 02 Mar 2023 18:19:11 -0800
To:     mm-commits@vger.kernel.org, dvyukov@google.com,
        bagasdotme@gmail.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kcov-improve-documentation-v3.patch added to mm-nonmm-unstable branch
Message-Id: <20230303021911.EE920C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kcov-improve-documentation-v3
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kcov-improve-documentation-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kcov-improve-documentation-v3.patch

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
Subject: kcov-improve-documentation-v3
Date: Wed, 1 Mar 2023 16:36:09 +0100

fix ``annotation`` for KCOV_REMOTE_ENABLE

Link: https://lkml.kernel.org/r/72be5c215c275f35891229b90622ed859f196a46.1677684837.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/dev-tools/kcov.rst~kcov-improve-documentation-v3
+++ a/Documentation/dev-tools/kcov.rst
@@ -229,7 +229,7 @@ Using KCOV to collect remote coverage re
 1. Modifying kernel code to annotate the code section from where coverage
    should be collected with ``kcov_remote_start`` and ``kcov_remote_stop``.
 
-2. Using `KCOV_REMOTE_ENABLE`` instead of ``KCOV_ENABLE`` in the userspace
+2. Using ``KCOV_REMOTE_ENABLE`` instead of ``KCOV_ENABLE`` in the userspace
    process that collects coverage.
 
 Both ``kcov_remote_start`` and ``kcov_remote_stop`` annotations and the
_

Patches currently in -mm which might be from andreyknvl@google.com are

kcov-improve-documentation.patch
kcov-improve-documentation-v2.patch
kcov-improve-documentation-v3.patch

