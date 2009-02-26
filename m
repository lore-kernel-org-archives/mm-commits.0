From: akpm@linux-foundation.org
Subject: + cirrusfb-fix-error-paths-in-cirrusfb_xxx_register-fix.patch added to -mm tree
Date: Thu, 26 Feb 2009 12:51:17 -0800
Message-ID: <200902262051.n1QKpHse021095@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752441AbZBZUvZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Feb 2009 15:51:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@poczta.fm, krzysztof.h1@wp.pl


The patch titled
     From: Krzysztof Helt <krzysztof.h1@poczta.fm>
has been added to the -mm tree.  Its filename is
     cirrusfb-fix-error-paths-in-cirrusfb_xxx_register-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: From: Krzysztof Helt <krzysztof.h1@poczta.fm>
From: Krzysztof Helt <krzysztof.h1@wp.pl>


My latest change introduced a typo
so fix it.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
---

Where can I get m68 cross compiler for PC able
to compile Amiga kernel?

Regards,
Krzysztof

index b96bc5d..070bf5f 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-fix-error-paths-in-cirrusfb_xxx_register-fix drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-fix-error-paths-in-cirrusfb_xxx_register-fix
+++ a/drivers/video/cirrusfb.c
@@ -2327,7 +2327,7 @@ static int __devinit cirrusfb_zorro_regi
 
 	ret = cirrusfb_register(info);
 	if (!ret)
-		return 0
+		return 0;
 
 	if (btype == BT_PICASSO4 || board_addr > 0x01000000)
 		iounmap(info->screen_base);
_

Patches currently in -mm which might be from krzysztof.h1@poczta.fm are

cirrusfb-convert-printks-to-dev_foo.patch
cirrusfb-convert-printks-to-dev_foo-fix.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
cirrusfb-various-improvements.patch
cirrusfb-fix-error-paths-in-cirrusfb_xxx_register-fix.patch
fbmem-fix-fb_info-lock-and-mm-mmap_sem-circular-locking-dependency.patch
fbdev-uninline-lock_fb_info.patch
skeletonfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
sm501fb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
sunxvr500-fix-cmap-memory-leaks.patch
tgafb-fix-cmap-memory-leak.patch
fbdev-newport-newport_wait-return-0-on-timeout.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-checkpatch-fixes.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-simplification.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-fix.patch
arkfb-fix-misplaced-parentheses.patch
uvesafb-bitwise-or-has-higher-precedence-than.patch
vesafb-bitwise-or-has-higher-precedence-than.patch
intelfb-support-i854.patch

