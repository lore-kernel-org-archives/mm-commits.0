From: akpm@linux-foundation.org
Subject: + drivers-base-cpuc-fix-typo-in-comment.patch added to -mm tree
Date: Tue, 15 Jan 2013 13:18:41 -0800
Message-ID: <20130115211841.87A3182004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:63752 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248Ab3AOVSm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Jan 2013 16:18:42 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so74879ghb.2
        for <mm-commits@vger.kernel.org>; Tue, 15 Jan 2013 13:18:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org


The patch titled
     Subject: drivers/base/cpu.c: Fix typo in comment
has been added to the -mm tree.  Its filename is
     drivers-base-cpuc-fix-typo-in-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ralf Baechle <ralf@linux-mips.org>
Subject: drivers/base/cpu.c: Fix typo in comment



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

include-asm-generic-pgtableh-fix-mips-build.patch
linux-next.patch
drivers-base-cpuc-fix-typo-in-comment.patch

