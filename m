From: akpm@linux-foundation.org
Subject: + kernel-watchdog-use-better-pr_fmt-prefix.patch added to -mm
 tree
Date: Thu, 13 Jul 2017 12:24:18 -0700
Message-ID: <5967c8e2.IAOtTiTecWiEopuz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49176 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752735AbdGMTYY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 15:24:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangkefeng.wang@huawei.com, babu.moger@oracle.com, mingo@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog.c: use better pr_fmt prefix
has been added to the -mm tree.  Its filename is
     kernel-watchdog-use-better-pr_fmt-prefix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-watchdog-use-better-pr_fmt-prefix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-watchdog-use-better-pr_fmt-prefix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: kernel/watchdog.c: use better pr_fmt prefix

After 73ce0511c436 ("kernel/watchdog.c: move hardlockup detector to
separate file"), 'NMI watchdog' is inappropriate in kernel/watchdog.c,
using 'watchdog' only.

Link: http://lkml.kernel.org/r/1499928642-48983-1-git-send-email-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Babu Moger <babu.moger@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/watchdog.c~kernel-watchdog-use-better-pr_fmt-prefix kernel/watchdog.c
--- a/kernel/watchdog.c~kernel-watchdog-use-better-pr_fmt-prefix
+++ a/kernel/watchdog.c
@@ -9,7 +9,7 @@
  * to those contributors as well.
  */
 
-#define pr_fmt(fmt) "NMI watchdog: " fmt
+#define pr_fmt(fmt) "watchdog: " fmt
 
 #include <linux/mm.h>
 #include <linux/cpu.h>
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

kernel-watchdog-use-better-pr_fmt-prefix.patch

