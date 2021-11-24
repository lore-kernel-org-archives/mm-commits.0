Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C08E6C4321E
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 00:31:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239923AbhKXAeI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Nov 2021 19:34:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:55444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234256AbhKXAdz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Nov 2021 19:33:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5A36608FB;
        Wed, 24 Nov 2021 00:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637713846;
        bh=kZdOB9op9cq4pdJVN8QqCNll7TvM69F0BWeYu7z7WJQ=;
        h=Date:From:To:Subject:From;
        b=NUSIKZQeyXtHkPFjR1O5D8MhmQO0NuY6jwBiWEWynETzTpQOTsLRpx6dm7E4zQyvd
         cxjpqU1SzD04zpeafOL5IN8CUl+nWQYj/x/v2BAto03Dmo7wcmQZAQWwlzHauu0WqA
         m69cdrkbBylBksM52OOfK5s+PyRTXBmWQzf3X0pE=
Date:   Tue, 23 Nov 2021 16:30:46 -0800
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, dyoung@redhat.com, mm-commits@vger.kernel.org
Subject:  + maintainers-update-kdump-maintainers.patch added to -mm
 tree
Message-ID: <20211124003046.NsixWZbxF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update kdump maintainers
has been added to the -mm tree.  Its filename is
     maintainers-update-kdump-maintainers.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-kdump-maintainers.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-kdump-maintainers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Young <dyoung@redhat.com>
Subject: MAINTAINERS: update kdump maintainers

Remove myself from kdump maintainers as I have no enough time to maintain
it now.  But I can review patches on demand though.

Link: https://lkml.kernel.org/r/YZyKilzKFsWJYdgn@dhcp-128-65.nay.redhat.com
Signed-off-by: Dave Young <dyoung@redhat.com>
Acked-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-update-kdump-maintainers
+++ a/MAINTAINERS
@@ -10269,9 +10269,9 @@ F:	lib/Kconfig.kcsan
 F:	scripts/Makefile.kcsan
 
 KDUMP
-M:	Dave Young <dyoung@redhat.com>
 M:	Baoquan He <bhe@redhat.com>
 R:	Vivek Goyal <vgoyal@redhat.com>
+R:	Dave Young <dyoung@redhat.com>
 L:	kexec@lists.infradead.org
 S:	Maintained
 W:	http://lse.sourceforge.net/kdump/
_

Patches currently in -mm which might be from dyoung@redhat.com are

maintainers-update-kdump-maintainers.patch

