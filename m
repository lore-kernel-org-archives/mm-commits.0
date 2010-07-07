From: akpm@linux-foundation.org
Subject: + include-linux-vgaarbh-add-missing-part-of-include-guard.patch added to -mm tree
Date: Wed, 07 Jul 2010 13:14:38 -0700
Message-ID: <201007072014.o67KEd9G024514@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755466Ab0GGUP0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jul 2010 16:15:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cardoe@gentoo.org, airlied@redhat.com, jbarnes@virtuousgeek.org


The patch titled
     include/linux/vgaarb.h: add missing part of include guard
has been added to the -mm tree.  Its filename is
     include-linux-vgaarbh-add-missing-part-of-include-guard.patch

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
Subject: include/linux/vgaarb.h: add missing part of include guard
From: Doug Goldstein <cardoe@gentoo.org>

vgaarb.h was missing the #define of the #ifndef at the top for the guard
to prevent multiple #include's from causing re-define errors

Signed-off-by: Doug Goldstein <cardoe@gentoo.org>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vgaarb.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/vgaarb.h~include-linux-vgaarbh-add-missing-part-of-include-guard include/linux/vgaarb.h
--- a/include/linux/vgaarb.h~include-linux-vgaarbh-add-missing-part-of-include-guard
+++ a/include/linux/vgaarb.h
@@ -29,6 +29,7 @@
  */
 
 #ifndef LINUX_VGA_H
+#define LINUX_VGA_H
 
 #include <asm/vga.h>
 
_

Patches currently in -mm which might be from cardoe@gentoo.org are

include-linux-vgaarbh-add-missing-part-of-include-guard.patch

