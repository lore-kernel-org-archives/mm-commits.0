From: akpm@linux-foundation.org
Subject: [merged] kasan-update-reference-to-kasan-prototype-repo.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 12:17:47 -0800
Message-ID: <563d0aeb.MQczNc6bEkQ51IYY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49126 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162975AbbKFURs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:17:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, dvyukov@google.com, glider@google.com, kcc@google.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: update reference to kasan prototype repo
has been removed from the -mm tree.  Its filename was
     kasan-update-reference-to-kasan-prototype-repo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


