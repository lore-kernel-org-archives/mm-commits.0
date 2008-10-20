From: akpm@linux-foundation.org
Subject: + viafb-removed-duplicated-includes.patch added to -mm tree
Date: Mon, 20 Oct 2008 14:44:53 -0700
Message-ID: <200810202144.m9KLirCZ023511@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753036AbYJTVo4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 17:44:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: weiyi.huang@gmail.com, josephchan@via.com.tw


The patch titled
     viafb: removed duplicated #include's
has been added to the -mm tree.  Its filename is
     viafb-removed-duplicated-includes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: removed duplicated #include's
From: Huang Weiyi <weiyi.huang@gmail.com>

Removed duplicated #include's in drivers/video/via/global.h.
  debug.h
  viafbdev.h
  viamode.h

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Cc: Joseph Chan <josephchan@via.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/global.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/video/via/global.h~viafb-removed-duplicated-includes drivers/video/via/global.h
--- a/drivers/video/via/global.h~viafb-removed-duplicated-includes
+++ a/drivers/video/via/global.h
@@ -38,7 +38,6 @@
 #include "iface.h"
 #include "viafbdev.h"
 #include "chip.h"
-#include "debug.h"
 #include "accel.h"
 #include "share.h"
 #include "dvi.h"
@@ -48,12 +47,10 @@
 
 #include "lcd.h"
 #include "ioctl.h"
-#include "viamode.h"
 #include "via_utility.h"
 #include "vt1636.h"
 #include "tblDPASetting.h"
 #include "tbl1636.h"
-#include "viafbdev.h"
 
 /* External struct*/
 
_

Patches currently in -mm which might be from weiyi.huang@gmail.com are

origin.patch
viafb-removed-duplicated-includes.patch
linux-next.patch

