From: akpm@linux-foundation.org
Subject: [merged] kasan-fix-prototype-author-email-address.patch
 removed from -mm tree
Date: Wed, 07 Feb 2018 11:55:37 -0800
Message-ID: <20180207195537.FxaMqK3M2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58058 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754127AbeBGTzi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:55:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix prototype author email address
has been removed from the -mm tree.  Its filename was
     kasan-fix-prototype-author-email-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


