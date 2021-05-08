Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB270C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:38:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4C4F610D2
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:38:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhEHWj0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:39:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:41956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWjZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:39:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE4EA610D2;
        Sat,  8 May 2021 22:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513502;
        bh=kb+4N4wXKb4gD7KaZuVl9aFhlDdlwnKI017eZNqwUgs=;
        h=Date:From:To:Subject:From;
        b=sgQv6HuDITt/wBNbDOqrQc/nXxmfXXHu+FzgvjILu+gn0fmtxQSlWIDtgQlaXouzt
         SkmBishPsZ6xd6Dswn1VsLr0SW3wXY688POdrbHqoFM4PpjTxwR/QrAnZCnCNMUr7A
         5pJppw28e86CXf9swry09wntfa/oLdZO2YyW8b9Y=
Date:   Sat, 08 May 2021 15:38:22 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] cifsd-is-broken.patch removed from -mm tree
Message-ID: <20210508223822.mG6cUr8lG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: cifsd-is-broken
has been removed from the -mm tree.  Its filename was
     cifsd-is-broken.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: cifsd-is-broken

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifsd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/cifsd/Kconfig~cifsd-is-broken
+++ a/fs/cifsd/Kconfig
@@ -3,6 +3,7 @@ config SMB_SERVER
 	depends on INET
 	depends on MULTIUSER
 	depends on FILE_LOCKING
+	depends on BROKEN
 	select NLS
 	select NLS_UTF8
 	select CRYPTO
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

