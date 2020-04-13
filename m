From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-an-entry-for-kfifo-fix.patch added to
 -mm tree
Date: Mon, 13 Apr 2020 13:08:32 -0700
Message-ID: <20200413200832.4VvEFItXw%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388207AbgDMUIf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Apr 2020 16:08:35 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, bgolaszewski@baylibre.com, gregkh@linuxfoundation.org, joe@perches.com, linus.walleij@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: maintainers-add-an-entry-for-kfifo-fix
has been added to the -mm tree.  Its filename is
     maintainers-add-an-entry-for-kfifo-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-an-entry-for-kfifo-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-an-entry-for-kfifo-fix.patch

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
Subject: maintainers-add-an-entry-for-kfifo-fix

alphasort F: entries, per Joa

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-add-an-entry-for-kfifo-fix
+++ a/MAINTAINERS
@@ -9415,8 +9415,8 @@ F:	security/keys/
 KFIFO:
 M:	Stefani Seibold <stefani@seibold.net>
 S:	Maintained
-F:	lib/kfifo.c
 F:	include/linux/kfifo.h
+F:	lib/kfifo.c
 F:	samples/kfifo/
 
 KGDB / KDB /debug_core
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-add-an-entry-for-kfifo-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
mm-clarify-__gfp_memalloc-usage-update-checkpatch-fixes.patch
linux-next-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
