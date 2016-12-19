From: akpm@linux-foundation.org
Subject: +
 scripts-spellingtxt-add-efective-pattern-and-fix-typo-instances.patch added to -mm tree
Date: Mon, 19 Dec 2016 14:26:25 -0800
Message-ID: <58585e91.hVbecxA5koREz8JZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43876 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932519AbcLSWZZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2016 17:25:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "efective" pattern and fix typo instances
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-add-efective-pattern-and-fix-typo-instances.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-add-efective-pattern-and-fix-typo-instances.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-add-efective-pattern-and-fix-typo-instances.patch

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
Subject: scripts/spelling.txt: add "efective" pattern and fix typo instances

Fix typos and add the following to the scripts/spelling.txt:

  efective||effective

While we are here, fix the "addres" as well in the touched line in
arch/openrisc/kernel/entry.S.

Link: http://lkml.kernel.org/r/1481573103-11329-10-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/ifpsp060/src/isp.S |    2 +-
 arch/openrisc/kernel/entry.S |    2 +-
 scripts/spelling.txt         |    1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff -puN arch/m68k/ifpsp060/src/isp.S~scripts-spellingtxt-add-efective-pattern-and-fix-typo-instances arch/m68k/ifpsp060/src/isp.S
--- a/arch/m68k/ifpsp060/src/isp.S~scripts-spellingtxt-add-efective-pattern-and-fix-typo-instances
+++ a/arch/m68k/ifpsp060/src/isp.S
@@ -3814,7 +3814,7 @@ CAS2W2_FILLER:
 #	(3) Save current DFC/SFC (ASSUMED TO BE EQUAL!!!); Then set	#
 #	    SFC/DFC according to whether exception occurred in user or	#
 #	    supervisor mode.						#
-#	(4) Use "plpaw" instruction to pre-load ATC with efective	#
+#	(4) Use "plpaw" instruction to pre-load ATC with effective	#
 #	    address page(s). THIS SHOULD NOT FAULT!!! The relevant	#
 #	    page(s) should have been made resident prior to entering	#
 #	    this routine.						#
diff -puN arch/openrisc/kernel/entry.S~scripts-spellingtxt-add-efective-pattern-and-fix-typo-instances arch/openrisc/kernel/entry.S
--- a/arch/openrisc/kernel/entry.S~scripts-spellingtxt-add-efective-pattern-and-fix-typo-instances
+++ a/arch/openrisc/kernel/entry.S
@@ -322,7 +322,7 @@ EXCEPTION_ENTRY(_alignment_handler)
 
 #if 0
 EXCEPTION_ENTRY(_alignment_handler)
-//        l.mfspr r2,r0,SPR_EEAR_BASE     /* Load the efective addres */
+//        l.mfspr r2,r0,SPR_EEAR_BASE     /* Load the effective address */
 	l.addi	r2,r4,0
 //        l.mfspr r5,r0,SPR_EPCR_BASE     /* Load the insn address */
 	l.lwz   r5,PT_PC(r1)
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-efective-pattern-and-fix-typo-instances scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-efective-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -381,6 +381,7 @@ easilly||easily
 ecspecially||especially
 edditable||editable
 editting||editing
+efective||effective
 efficently||efficiently
 ehther||ether
 eigth||eight
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

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

