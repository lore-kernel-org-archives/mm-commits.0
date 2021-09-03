Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37DD6C43217
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 233D26112E
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349571AbhICU70 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:59:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349933AbhICU7S (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:59:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DF55610FB;
        Fri,  3 Sep 2021 20:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702697;
        bh=LpcktDIY1EM6Flq4A6up4FvWZ13kjhB7JKf5ey+lZTA=;
        h=Date:From:To:Subject:From;
        b=U8/wSa2UiRZfYW5MUdtMEuOBs6EHJ3GWord/NE58J01WGMMo06/TXQy+XAJDK3pfa
         vCgAZgdQEmiYNX4zUoTNAcwzNUS2t3wVH9fXoupWH6RIoRhHNDDDnLcRjzJvc3IfSm
         Vz+FZ2rVktZjI8sou0wDDY5l/E6JWtSlPtiCSByE=
Date:   Fri, 03 Sep 2021 13:58:17 -0700
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, mm-commits@vger.kernel.org
Subject:  [merged]
 selftests-fix-spelling-mistake-cannt-cannot.patch removed from -mm tree
Message-ID: <20210903205817.bUePzwp7z%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: Fix spelling mistake "cann't" -> "cannot"
has been removed from the -mm tree.  Its filename was
     selftests-fix-spelling-mistake-cannt-cannot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: selftests: Fix spelling mistake "cann't" -> "cannot"

There is a spelling mistake in an error message. Fix it.

Link: https://lkml.kernel.org/r/20210826121217.12885-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/mlock-random-test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/mlock-random-test.c~selftests-fix-spelling-mistake-cannt-cannot
+++ a/tools/testing/selftests/vm/mlock-random-test.c
@@ -70,7 +70,7 @@ int get_proc_locked_vm_size(void)
 		}
 	}
 
-	perror("cann't parse VmLck in /proc/self/status\n");
+	perror("cannot parse VmLck in /proc/self/status\n");
 	fclose(f);
 	return -1;
 }
_

Patches currently in -mm which might be from colin.king@canonical.com are

arch-kconfig-fix-spelling-mistake-seperate-separate.patch

