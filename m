Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B353DC433B4
	for <mm-commits@archiver.kernel.org>; Thu, 20 May 2021 20:42:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F57E6108D
	for <mm-commits@archiver.kernel.org>; Thu, 20 May 2021 20:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbhETUnj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 May 2021 16:43:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:33472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229507AbhETUnj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 May 2021 16:43:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D9BA6135B;
        Thu, 20 May 2021 20:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621543336;
        bh=raK4tzVOX1ZF7soDpHi3pHZVBZtwmyqvXDRjJ8poCuY=;
        h=Date:From:To:Subject:From;
        b=xtcBSjEfPnb6NTt3NCRDxqs5mQwp6iU1HwYMFj0Uo2vijgQnwL0a1NdMzUl8jpuR2
         /wq1rJVGpPSx94/pntj+PdoushfFeU2B4Jgj+FlPyVzNqro6owxdkcbXcziCL1ojAj
         C7Zv4dyhPuBp5O69303e81bB69p1JkKzFnKBfJsE=
Date:   Thu, 20 May 2021 13:42:16 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, mm-commits@vger.kernel.org
Subject:  + proc-remove-myself-from-maintainers.patch added to -mm
 tree
Message-ID: <20210520204216.LGHXPWjwU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: remove Alexey from MAINTAINERS
has been added to the -mm tree.  Its filename is
     proc-remove-myself-from-maintainers.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc-remove-myself-from-maintainers.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc-remove-myself-from-maintainers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: remove Alexey from MAINTAINERS

People Cc me and I don't have time.

Link: https://lkml.kernel.org/r/YKarMxHJBIhMHQIh@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

--- a/MAINTAINERS~proc-remove-myself-from-maintainers
+++ a/MAINTAINERS
@@ -14735,7 +14735,6 @@ W:	https://wireless.wiki.kernel.org/en/u
 F:	drivers/net/wireless/intersil/prism54/
 
 PROC FILESYSTEM
-R:	Alexey Dobriyan <adobriyan@gmail.com>
 L:	linux-kernel@vger.kernel.org
 L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-remove-myself-from-maintainers.patch

