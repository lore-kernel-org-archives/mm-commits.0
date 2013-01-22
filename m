From: akpm@linux-foundation.org
Subject: [merged] drivers-base-cpuc-fix-typo-in-comment.patch removed from -mm tree
Date: Tue, 22 Jan 2013 13:23:11 -0800
Message-ID: <20130122212311.A8C065A415E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:47306 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab3AVVXM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Jan 2013 16:23:12 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so860948yen.4
        for <mm-commits@vger.kernel.org>; Tue, 22 Jan 2013 13:23:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/base/cpu.c: Fix typo in comment
has been removed from the -mm tree.  Its filename was
     drivers-base-cpuc-fix-typo-in-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ralf Baechle <ralf@linux-mips.org>
Subject: drivers/base/cpu.c: Fix typo in comment

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/cpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/cpu.c~drivers-base-cpuc-fix-typo-in-comment drivers/base/cpu.c
--- a/drivers/base/cpu.c~drivers-base-cpuc-fix-typo-in-comment
+++ a/drivers/base/cpu.c
@@ -224,7 +224,7 @@ static void cpu_device_release(struct de
 	 * by the cpu device.
 	 *
 	 * Never copy this way of doing things, or you too will be made fun of
-	 * on the linux-kerenl list, you have been warned.
+	 * on the linux-kernel list, you have been warned.
 	 */
 }
 
_

Patches currently in -mm which might be from ralf@linux-mips.org are

linux-next.patch

