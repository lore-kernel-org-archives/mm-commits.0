From: akpm@linux-foundation.org
Subject: + kasan-update-reference-to-kasan-prototype-repo.patch
 tentatively added to -mm tree
Date: Mon, 14 Sep 2015 14:46:37 -0700
Message-ID: <55f7403d.+VvnZikBpQ0ICE2N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49352 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbbINVqi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Sep 2015 17:46:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, dvyukov@google.com, glider@google.com, kcc@google.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: update reference to kasan prototype repo
has been added to the -mm tree.  Its filename is
     kasan-update-reference-to-kasan-prototype-repo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-update-reference-to-kasan-prototype-repo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-update-reference-to-kasan-prototype-repo.patch

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
Subject: kasan: update reference to kasan prototype repo

Update the reference to the kasan prototype repository on github, since it
was renamed.

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Konstantin Serebryany <kcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.c  |    2 +-
 mm/kasan/report.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/kasan/kasan.c~kasan-update-reference-to-kasan-prototype-repo mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~kasan-update-reference-to-kasan-prototype-repo
+++ a/mm/kasan/kasan.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2014 Samsung Electronics Co., Ltd.
  * Author: Andrey Ryabinin <ryabinin.a.a@gmail.com>
  *
- * Some of code borrowed from https://github.com/xairy/linux by
+ * Some code borrowed from https://github.com/xairy/kasan-prototype by
  *        Andrey Konovalov <adech.fo@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
diff -puN mm/kasan/report.c~kasan-update-reference-to-kasan-prototype-repo mm/kasan/report.c
--- a/mm/kasan/report.c~kasan-update-reference-to-kasan-prototype-repo
+++ a/mm/kasan/report.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2014 Samsung Electronics Co., Ltd.
  * Author: Andrey Ryabinin <ryabinin.a.a@gmail.com>
  *
- * Some of code borrowed from https://github.com/xairy/linux by
+ * Some code borrowed from https://github.com/xairy/kasan-prototype by
  *        Andrey Konovalov <adech.fo@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-update-reported-bug-types-for-not-user-nor-kernel-memory-accesses.patch
kasan-update-reported-bug-types-for-kernel-memory-accesses.patch
kasan-accurately-determine-the-type-of-the-bad-access.patch
kasan-update-log-messages.patch
kasan-various-fixes-in-documentation.patch
kasan-move-kasan_sanitize-in-arch-x86-boot-makefile.patch
kasan-update-reference-to-kasan-prototype-repo.patch

