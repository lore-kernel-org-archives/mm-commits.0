From: akpm@linux-foundation.org
Subject: + bitfieldh-include-linux-build_bugh-instead-of-linux-bugh.patch
 added to -mm tree
Date: Wed, 27 Sep 2017 15:47:01 -0700
Message-ID: <59cc2a65.xn/gdtRlkUZxP2Gt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56318 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752050AbdI0WrC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Sep 2017 18:47:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, abbotti@mev.co.uk, dinan.gunawardena@netronome.com, jakub.kicinski@netronome.com, kvalo@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/bitfield.h: include <linux/build_bug.h> instead of <linux/bug.h>
has been added to the -mm tree.  Its filename is
     bitfieldh-include-linux-build_bugh-instead-of-linux-bugh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bitfieldh-include-linux-build_bugh-instead-of-linux-bugh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bitfieldh-include-linux-build_bugh-instead-of-linux-bugh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: include/linux/bitfield.h: include <linux/build_bug.h> instead of <linux/bug.h>

Since bc6245e5efd7 ("bug: split BUILD_BUG stuff out into
<linux/build_bug.h>"), #include <linux/build_bug.h> is better to pull
minimal headers needed for BUILG_BUG() family.

Link: http://lkml.kernel.org/r/1505700775-19826-1-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: Dinan Gunawardena <dinan.gunawardena@netronome.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitfield.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/bitfield.h~bitfieldh-include-linux-build_bugh-instead-of-linux-bugh include/linux/bitfield.h
--- a/include/linux/bitfield.h~bitfieldh-include-linux-build_bugh-instead-of-linux-bugh
+++ a/include/linux/bitfield.h
@@ -15,7 +15,7 @@
 #ifndef _LINUX_BITFIELD_H
 #define _LINUX_BITFIELD_H
 
-#include <linux/bug.h>
+#include <linux/build_bug.h>
 
 /*
  * Bitfield access macros
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

bitfieldh-remove-32bit-from-field_get-comment-block.patch
bitfieldh-include-linux-build_bugh-instead-of-linux-bugh.patch
init-version-include-linux-exporth-instead-of-linux-moduleh.patch

