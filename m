From: akpm@linux-foundation.org
Subject: [merged] fs-ncpfs-dirc-remove-redundant-sys_tz-declaration.patch
 removed from -mm tree
Date: Tue, 14 Oct 2014 11:20:03 -0700
Message-ID: <543d6953.LUlv4WaPG/jkhm3y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44190 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbaJNSUC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:20:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, petr@vandrovec.name, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ncpfs/dir.c: remove redundant sys_tz declaration
has been removed from the -mm tree.  Its filename was
     fs-ncpfs-dirc-remove-redundant-sys_tz-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/ncpfs/dir.c: remove redundant sys_tz declaration

sys_tz is already declared in include/linux/time.h

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Petr Vandrovec <petr@vandrovec.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/dir.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/ncpfs/dir.c~fs-ncpfs-dirc-remove-redundant-sys_tz-declaration fs/ncpfs/dir.c
--- a/fs/ncpfs/dir.c~fs-ncpfs-dirc-remove-redundant-sys_tz-declaration
+++ a/fs/ncpfs/dir.c
@@ -1178,9 +1178,6 @@ static int day_n[] =
 {0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 0, 0, 0, 0};
 /* Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec */
 
-
-extern struct timezone sys_tz;
