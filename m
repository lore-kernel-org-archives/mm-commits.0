From: akpm@linux-foundation.org
Subject: [merged] scripts-spellingtxt-add-syfs-sysfs-pattern.patch
 removed from -mm tree
Date: Fri, 03 Apr 2020 13:34:55 -0700
Message-ID: <20200403203455.UMjdREQTs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUe4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:34:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris.paterson2@renesas.com, colin.king@canonical.com, j.neuschaefer@gmx.net, luca@lucaceresoli.net, mm-commits@vger.kernel.org, paul.walmsley@sifive.com, sboyd@kernel.org, xndchn@gmail.com


The patch titled
     Subject: scripts/spelling.txt: add syfs/sysfs pattern
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-syfs-sysfs-pattern.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
Subject: scripts/spelling.txt: add syfs/sysfs pattern

There are a few cases in the tree where "sysfs" is misspelled as "syfs".

Link: http://lkml.kernel.org/r/20200218152010.27349-1-j.neuschaefer@gmx.net
Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.ne>
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
