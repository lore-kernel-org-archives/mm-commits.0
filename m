From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-an-entry-for-kfifo-fix-fix.patch added
 to -mm tree
Date: Tue, 14 Apr 2020 15:30:11 -0700
Message-ID: <20200414223011.KhRoyd5W2%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391879AbgDNWaM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Apr 2020 18:30:12 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, bgolaszewski@baylibre.com, gregkh@linuxfoundation.org, joe@perches.com, linus.walleij@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: maintainers-add-an-entry-for-kfifo-fix-fix
has been added to the -mm tree.  Its filename is
     maintainers-add-an-entry-for-kfifo-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-an-entry-for-kfifo-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-an-entry-for-kfifo-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: maintainers-add-an-entry-for-kfifo-fix-fix

remove colon, per Bartosz

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-add-an-entry-for-kfifo-fix-fix
+++ a/MAINTAINERS
@@ -9412,7 +9412,7 @@ F:	include/linux/keyctl.h
 F:	include/uapi/linux/keyctl.h
 F:	security/keys/
 
-KFIFO:
+KFIFO
 M:	Stefani Seibold <stefani@seibold.net>
 S:	Maintained
 F:	include/linux/kfifo.h
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-add-an-entry-for-kfifo-fix.patch
maintainers-add-an-entry-for-kfifo-fix-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
linux-next-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
