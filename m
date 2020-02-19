From: akpm@linux-foundation.org
Subject: + scripts-spellingtxt-add-syfs-sysfs-pattern.patch added to
 -mm tree
Date: Wed, 19 Feb 2020 13:25:05 -0800
Message-ID: <20200219212505.MFDoy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726703AbgBSVZG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Feb 2020 16:25:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xndchn@gmail.com, sboyd@kernel.org, paul.walmsley@sifive.com, luca@lucaceresoli.net, colin.king@canonical.com, chris.paterson2@renesas.com, j.neuschaefer@gmx.net


The patch titled
     Subject: scripts/spelling.txt: Add syfs/sysfs pattern
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-add-syfs-sysfs-pattern.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-add-syfs-s=
ysfs-pattern.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-add-syfs-s=
ysfs-pattern.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
Subject: scripts/spelling.txt: Add syfs/sysfs pattern

There are a few cases in the tree where "sysfs" is misspelled as "syfs".

Link: http://lkml.kernel.org/r/20200218152010.27349-1-j.neuschaefer@gmx.net
Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Xiong <xndchn@gmail.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Chris Paterson <chris.paterson2@renesas.com>
Cc: Luca Ceresoli <luca@lucaceresoli.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-syfs-sysfs-pattern
+++ a/scripts/spelling.txt
@@ -1328,6 +1328,7 @@ swithcing||switching
 swithed||switched
 swithing||switching
 swtich||switch
+syfs||sysfs
 symetric||symmetric
 synax||syntax
 synchonized||synchronized
_

Patches currently in -mm which might be from j.neuschaefer@gmx.net are

scripts-spellingtxt-add-syfs-sysfs-pattern.patch
