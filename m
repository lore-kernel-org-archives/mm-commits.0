From: akpm@linux-foundation.org
Subject: + maintainers-greybus-dev-list-is-members-only.patch added to -mm tree
Date: Mon, 15 May 2017 13:11:08 -0700
Message-ID: <591a0b5c.jGxquIbbr88qtl4y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39508 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965476AbdEOULQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 May 2017 16:11:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: greybus-dev list is members-only
has been added to the -mm tree.  Its filename is
     maintainers-greybus-dev-list-is-members-only.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-greybus-dev-list-is-members-only.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-greybus-dev-list-is-members-only.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: MAINTAINERS: greybus-dev list is members-only

The greybus-dev mailing list is a members-only list and is moderated for
non-subscribers.

Link: http://lkml.kernel.org/r/a61338f1-5274-ca34-f028-9db316f22d0f@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-greybus-dev-list-is-members-only MAINTAINERS
--- a/MAINTAINERS~maintainers-greybus-dev-list-is-members-only
+++ a/MAINTAINERS
@@ -5695,7 +5695,7 @@ M:	Alex Elder <elder@kernel.org>
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 S:	Maintained
 F:	drivers/staging/greybus/
-L:	greybus-dev@lists.linaro.org
+L:	greybus-dev@lists.linaro.org (moderated for non-subscribers)
 
 GREYBUS AUDIO PROTOCOLS DRIVERS
 M:	Vaibhav Agarwal <vaibhav.sr@gmail.com>
_

Patches currently in -mm which might be from rdunlap@infradead.org are

maintainers-greybus-dev-list-is-members-only.patch
imx7-fix-kconfig-warning-and-build-errors.patch

