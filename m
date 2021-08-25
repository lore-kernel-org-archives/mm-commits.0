Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5427CC4338F
	for <mm-commits@archiver.kernel.org>; Wed, 25 Aug 2021 17:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39D5361076
	for <mm-commits@archiver.kernel.org>; Wed, 25 Aug 2021 17:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242178AbhHYRM6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Aug 2021 13:12:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242169AbhHYRM6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 25 Aug 2021 13:12:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AC9261056;
        Wed, 25 Aug 2021 17:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629911532;
        bh=QsaTZDxGNx6fSueRgpQ9GLKKuQoWDYwx2+mquDw9Z28=;
        h=Date:From:To:Subject:From;
        b=Nwvemf30RjbONMIxAy4szceJVDLxpIg7Ic8+ToCHlMbiHRlFx+0oOAoZgKkMM8VC8
         g/+vfyyAn3dBTRi5Pzj+VN4CAjhznpcVFcuL6H66ymOPg+qFmuNs0gs140Z4jTeaa3
         VCz0Zku2xlkvw3ef6aY6MFa6GdyEuotqoXRu8s+s=
Date:   Wed, 25 Aug 2021 10:12:11 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, namjae.jeon@samsung.com
Subject:  + maintainers-exfat-update-my-email-address.patch added to
 -mm tree
Message-ID: <20210825171211.eftPu%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: exfat: update my email address
has been added to the -mm tree.  Its filename is
     maintainers-exfat-update-my-email-address.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-exfat-update-my-email-address.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-exfat-update-my-email-address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: MAINTAINERS: exfat: update my email address

My email address in exfat entry will be not available in a few days. 
Update it to my own kernel.org address.

Link: https://lkml.kernel.org/r/20210825044833.16806-1-namjae.jeon@samsung.com
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-exfat-update-my-email-address
+++ a/MAINTAINERS
@@ -6955,7 +6955,7 @@ F:	include/uapi/linux/mdio.h
 F:	include/uapi/linux/mii.h
 
 EXFAT FILE SYSTEM
-M:	Namjae Jeon <namjae.jeon@samsung.com>
+M:	Namjae Jeon <linkinjeon@kernel.org>
 M:	Sungjong Seo <sj1557.seo@samsung.com>
 L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

maintainers-exfat-update-my-email-address.patch

