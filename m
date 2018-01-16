From: akpm@linux-foundation.org
Subject: + kasan-fix-prototype-author-email-address.patch added to -mm
 tree
Date: Tue, 16 Jan 2018 13:56:41 -0800
Message-ID: <5a5e7519.2QFe3prRWqXQgqc/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42988 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750796AbeAPV4n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 Jan 2018 16:56:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix prototype author email address
has been added to the -mm tree.  Its filename is
     kasan-fix-prototype-author-email-address.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-fix-prototype-author-email-address.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-fix-prototype-author-email-address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: fix prototype author email address

Use the new one.

Link: http://lkml.kernel.org/r/de3b7ffc30a55178913a7d3865216aa7accf6c40.1515775666.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.c  |    2 +-
 mm/kasan/report.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/kasan/kasan.c~kasan-fix-prototype-author-email-address mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~kasan-fix-prototype-author-email-address
+++ a/mm/kasan/kasan.c
@@ -5,7 +5,7 @@
  * Author: Andrey Ryabinin <ryabinin.a.a@gmail.com>
  *
  * Some code borrowed from https://github.com/xairy/kasan-prototype by
- *        Andrey Konovalov <adech.fo@gmail.com>
+ *        Andrey Konovalov <andreyknvl@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff -puN mm/kasan/report.c~kasan-fix-prototype-author-email-address mm/kasan/report.c
--- a/mm/kasan/report.c~kasan-fix-prototype-author-email-address
+++ a/mm/kasan/report.c
@@ -5,7 +5,7 @@
  * Author: Andrey Ryabinin <ryabinin.a.a@gmail.com>
  *
  * Some code borrowed from https://github.com/xairy/kasan-prototype by
- *        Andrey Konovalov <adech.fo@gmail.com>
+ *        Andrey Konovalov <andreyknvl@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-prototype-author-email-address.patch
kasan-clean-up-kasan_shadow_scale_shift-usage.patch

