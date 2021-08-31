Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0103CC432BE
	for <mm-commits@archiver.kernel.org>; Tue, 31 Aug 2021 22:41:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE21F60FC3
	for <mm-commits@archiver.kernel.org>; Tue, 31 Aug 2021 22:41:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239694AbhHaWmP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Aug 2021 18:42:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:43324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229602AbhHaWmP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 31 Aug 2021 18:42:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D44D60698;
        Tue, 31 Aug 2021 22:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630449679;
        bh=JuyQRqh/dWSrZUzNRRt5M2iI+3dB2DQtVekpccRv3Bg=;
        h=Date:From:To:Subject:From;
        b=EaG0KhV5oxTNxaOqG87F0UeRm8vK2ZHK0FfzJslmdKO8wTLACtPTan5GFPnJQmAVY
         vD1sqFup3zyqUehg0bDbALO0+MFUfgr1qzbjaJy6szka4slLGYh0Z5ogMKYlMDmAJx
         wkLlUafbJnFa2aFNbqDnfpr0me2jcyFuhNftkvcM=
Date:   Tue, 31 Aug 2021 15:41:19 -0700
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, mm-commits@vger.kernel.org
Subject:  + selftests-fix-spelling-mistake-cannt-cannot.patch added
 to -mm tree
Message-ID: <20210831224119.k1mwxUl0S%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: Fix spelling mistake "cann't" -> "cannot"
has been added to the -mm tree.  Its filename is
     selftests-fix-spelling-mistake-cannt-cannot.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-fix-spelling-mistake-cannt-cannot.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-fix-spelling-mistake-cannt-cannot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

selftests-fix-spelling-mistake-cannt-cannot.patch
arch-kconfig-fix-spelling-mistake-seperate-separate.patch

