From: akpm@linux-foundation.org
Subject: [patch 28/94] include/linux/bitfield.h: include
 <linux/build_bug.h> instead of <linux/bug.h>
Date: Fri, 17 Nov 2017 15:27:49 -0800
Message-ID: <20171117232749.ptu1vmc_p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55436 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423266AbdKQX1v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:27:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: abbotti@mev.co.uk, akpm@linux-foundation.org, dinan.gunawardena@netronome.com, jakub.kicinski@netronome.com, kvalo@codeaurora.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, yamada.masahiro@socionext.com

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
