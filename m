Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A077EC761A6
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:50:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbjDFCuk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235035AbjDFCuU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:50:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427397EF0
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:49:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E72A61E28
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0293BC433D2;
        Thu,  6 Apr 2023 02:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749359;
        bh=JDbCgWkmdrdHiJN2sw9oRF6FkcZynib918h+DRNfCSA=;
        h=Date:To:From:Subject:From;
        b=E6q+u093KFe3xR56hm8N0sCqILHYdwFr6rpL7V2Q3hmby583+z+WGkuYBHFi/nKuE
         kNA3DwBaH1did2OUhXJbM3I/bMawL/Z0CK+Z05S1aBDcYpAQnkfeIgovZk3mUJG+ep
         JkKKcXzjGW8KrmPPui1usnkMmnuYI2tUVY03Y6rU=
Date:   Wed, 05 Apr 2023 19:49:18 -0700
To:     mm-commits@vger.kernel.org, dvyukov@google.com,
        bagasdotme@gmail.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kcov-improve-documentation-v3.patch removed from -mm tree
Message-Id: <20230406024919.0293BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kcov-improve-documentation-v3
has been removed from the -mm tree.  Its filename was
     kcov-improve-documentation-v3.patch

This patch was dropped because it was folded into kcov-improve-documentation.patch

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

 Documentation/dev-tools/kcov.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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

