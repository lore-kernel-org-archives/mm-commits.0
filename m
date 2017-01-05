From: akpm@linux-foundation.org
Subject: + linux-consth-refactor-_bitul-and-_bitull-a-bit.patch added to
 -mm tree
Date: Thu, 05 Jan 2017 15:08:52 -0800
Message-ID: <586ed204.MOfu/IFR0KiYaEjo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50204 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763732AbdAEXHe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2017 18:07:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: linux/const.h: refactor _BITUL and _BITULL a bit
has been added to the -mm tree.  Its filename is
     linux-consth-refactor-_bitul-and-_bitull-a-bit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-consth-refactor-_bitul-and-_bitull-a-bit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-consth-refactor-_bitul-and-_bitull-a-bit.patch

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
Subject: linux/const.h: refactor _BITUL and _BITULL a bit

Minor cleanups available by _UL and _ULL.

Link: http://lkml.kernel.org/r/1483582810-7046-4-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/const.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/uapi/linux/const.h~linux-consth-refactor-_bitul-and-_bitull-a-bit include/uapi/linux/const.h
--- a/include/uapi/linux/const.h~linux-consth-refactor-_bitul-and-_bitull-a-bit
+++ a/include/uapi/linux/const.h
@@ -24,7 +24,7 @@
 #define _UL(x)		(_AC(x, UL))
 #define _ULL(x)		(_AC(x, ULL))
 
-#define _BITUL(x)	(_AC(1,UL) << (x))
-#define _BITULL(x)	(_AC(1,ULL) << (x))
+#define _BITUL(x)	(_UL(1) << (x))
+#define _BITULL(x)	(_ULL(1) << (x))
 
 #endif /* _UAPI_LINUX_CONST_H */
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

m68k-rename-ul-to-to_ul.patch
linux-consth-move-ul-macro-to-include-linux-consth.patch
linux-consth-refactor-_bitul-and-_bitull-a-bit.patch
linux-consth-move-bit_ull-to-linux-consth-for-use-in-assembly.patch
scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-swithc-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-one-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-algined-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-efective-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-varible-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-embeded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-againt-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-neded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-unneded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-initialiazation-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-comsumer-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-configuartion-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-applys-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-explictely-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-omited-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disassocation-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-deintialized-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overwritting-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overwriten-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-therfore-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances.patch

