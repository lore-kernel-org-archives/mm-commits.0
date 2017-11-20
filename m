From: akpm@linux-foundation.org
Subject: [merged]
 bitfieldh-include-linux-build_bugh-instead-of-linux-bugh.patch removed from
 -mm tree
Date: Mon, 20 Nov 2017 13:23:56 -0800
Message-ID: <20171120212356.s_8XL7vpY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40192 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753063AbdKTVX5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:23:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: abbotti@mev.co.uk, dinan.gunawardena@netronome.com, jakub.kicinski@netronome.com, kvalo@codeaurora.org, mm-commits@vger.kernel.org, yamada.masahiro@socionext.com


The patch titled
     Subject: include/linux/bitfield.h: include <linux/build_bug.h> instead of <linux/bug.h>
has been removed from the -mm tree.  Its filename was
     bitfieldh-include-linux-build_bugh-instead-of-linux-bugh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


